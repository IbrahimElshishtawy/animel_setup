import type { Request, Response } from 'express';
import Cart from '../models/Cart';
import Product from '../models/product/Product';
import { ApiError } from '../utils/ApiError';
import { asyncHandler } from '../utils/asyncHandler';

const serializeCart = async (userId: string) => {
  const cart = await Cart.findOne({ userId }).populate('items.productId');

  if (!cart) {
    return {
      items: [],
      itemCount: 0,
      total: 0,
    };
  }

  const items = cart.items.map((item) => {
    const product = item.productId as unknown as {
      _id: string;
      name: string;
      category: string;
      imageUrl: string;
      price: number;
      animalType: string;
    };

    return {
      productId: product?._id || item.productId,
      product,
      quantity: item.quantity,
      priceSnapshot: item.priceSnapshot,
      lineTotal: item.quantity * item.priceSnapshot,
    };
  });

  return {
    items,
    itemCount: items.reduce((sum, item) => sum + item.quantity, 0),
    total: items.reduce((sum, item) => sum + item.lineTotal, 0),
  };
};

export const getProducts = asyncHandler(async (req: Request, res: Response) => {
  const { category, query, animalType } = req.query;
  const filter: Record<string, unknown> = {};

  if (category && String(category) !== 'All') {
    filter.category = String(category);
  }

  if (animalType && String(animalType) !== 'All') {
    filter.animalType = String(animalType);
  }

  if (query) {
    filter.$or = [
      { name: { $regex: String(query), $options: 'i' } },
      { description: { $regex: String(query), $options: 'i' } },
      { category: { $regex: String(query), $options: 'i' } },
    ];
  }

  const products = await Product.find(filter).sort({ createdAt: -1 });
  res.status(200).json(products);
});

export const getProductDetails = asyncHandler(async (req: Request, res: Response) => {
  const product = await Product.findById(req.params.id);
  if (!product) {
    throw new ApiError(404, 'Product not found');
  }

  res.status(200).json(product);
});

export const getProductCategories = asyncHandler(async (_req: Request, res: Response) => {
  const categories = await Product.distinct('category');
  res.status(200).json(['All', ...categories]);
});

export const createProduct = asyncHandler(async (req: Request, res: Response) => {
  const product = await Product.create({
    ...req.body,
    price: Number(req.body.price),
    stock: Number(req.body.stock ?? 0),
  });

  res.status(201).json(product);
});

export const getCart = asyncHandler(async (req: Request, res: Response) => {
  res.status(200).json(await serializeCart(req.user!.id));
});

export const addCartItem = asyncHandler(async (req: Request, res: Response) => {
  const { productId, quantity } = req.body;
  const product = await Product.findById(productId);

  if (!product) {
    throw new ApiError(404, 'Product not found');
  }

  let cart = await Cart.findOne({ userId: req.user!.id });
  if (!cart) {
    cart = await Cart.create({ userId: req.user!.id, items: [] });
  }

  const existingItem = cart.items.find(
    (item) => item.productId.toString() === String(productId),
  );

  if (existingItem) {
    existingItem.quantity += Number(quantity);
    existingItem.priceSnapshot = product.price;
  } else {
    cart.items.push({
      productId: product._id,
      quantity: Number(quantity),
      priceSnapshot: product.price,
    });
  }

  await cart.save();

  res.status(200).json(await serializeCart(req.user!.id));
});

export const updateCartItem = asyncHandler(async (req: Request, res: Response) => {
  const { quantity } = req.body;
  const cart = await Cart.findOne({ userId: req.user!.id });

  if (!cart) {
    throw new ApiError(404, 'Cart not found');
  }

  const item = cart.items.find(
    (entry) => entry.productId.toString() === String(req.params.productId),
  );

  if (!item) {
    throw new ApiError(404, 'Cart item not found');
  }

  item.quantity = Number(quantity);

  if (item.quantity <= 0) {
    cart.items = cart.items.filter(
      (entry) => entry.productId.toString() !== String(req.params.productId),
    );
  }

  await cart.save();

  res.status(200).json(await serializeCart(req.user!.id));
});

export const removeCartItem = asyncHandler(async (req: Request, res: Response) => {
  const cart = await Cart.findOne({ userId: req.user!.id });

  if (!cart) {
    throw new ApiError(404, 'Cart not found');
  }

  cart.items = cart.items.filter(
    (entry) => entry.productId.toString() !== String(req.params.productId),
  );

  await cart.save();

  res.status(200).json(await serializeCart(req.user!.id));
});
