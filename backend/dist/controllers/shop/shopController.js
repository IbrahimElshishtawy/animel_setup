"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.removeCartItem = exports.updateCartItem = exports.addCartItem = exports.getCart = exports.createProduct = exports.getProductCategories = exports.getProductDetails = exports.getProducts = void 0;
const Cart_1 = __importDefault(require("../../models/Cart"));
const Product_1 = __importDefault(require("../../models/product/Product"));
const ApiError_1 = require("../../utils/ApiError");
const asyncHandler_1 = require("../../utils/asyncHandler");
const serializeCart = async (userId) => {
    const cart = await Cart_1.default.findOne({ userId }).populate('items.productId');
    if (!cart) {
        return {
            items: [],
            itemCount: 0,
            total: 0,
        };
    }
    const items = cart.items.map((item) => {
        const product = item.productId;
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
exports.getProducts = (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const { category, query, animalType } = req.query;
    const filter = {};
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
    const products = await Product_1.default.find(filter).sort({ createdAt: -1 });
    res.status(200).json(products);
});
exports.getProductDetails = (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const product = await Product_1.default.findById(req.params.id);
    if (!product) {
        throw new ApiError_1.ApiError(404, 'Product not found');
    }
    res.status(200).json(product);
});
exports.getProductCategories = (0, asyncHandler_1.asyncHandler)(async (_req, res) => {
    const categories = await Product_1.default.distinct('category');
    res.status(200).json(['All', ...categories]);
});
exports.createProduct = (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const product = await Product_1.default.create({
        ...req.body,
        price: Number(req.body.price),
        stock: Number(req.body.stock ?? 0),
    });
    res.status(201).json(product);
});
exports.getCart = (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    res.status(200).json(await serializeCart(req.user.id));
});
exports.addCartItem = (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const { productId, quantity } = req.body;
    const product = await Product_1.default.findById(productId);
    if (!product) {
        throw new ApiError_1.ApiError(404, 'Product not found');
    }
    let cart = await Cart_1.default.findOne({ userId: req.user.id });
    if (!cart) {
        cart = await Cart_1.default.create({ userId: req.user.id, items: [] });
    }
    const existingItem = cart.items.find((item) => item.productId.toString() === String(productId));
    if (existingItem) {
        existingItem.quantity += Number(quantity);
        existingItem.priceSnapshot = product.price;
    }
    else {
        cart.items.push({
            productId: product._id,
            quantity: Number(quantity),
            priceSnapshot: product.price,
        });
    }
    await cart.save();
    res.status(200).json(await serializeCart(req.user.id));
});
exports.updateCartItem = (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const { quantity } = req.body;
    const cart = await Cart_1.default.findOne({ userId: req.user.id });
    if (!cart) {
        throw new ApiError_1.ApiError(404, 'Cart not found');
    }
    const item = cart.items.find((entry) => entry.productId.toString() === String(req.params.productId));
    if (!item) {
        throw new ApiError_1.ApiError(404, 'Cart item not found');
    }
    item.quantity = Number(quantity);
    if (item.quantity <= 0) {
        cart.items = cart.items.filter((entry) => entry.productId.toString() !== String(req.params.productId));
    }
    await cart.save();
    res.status(200).json(await serializeCart(req.user.id));
});
exports.removeCartItem = (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const cart = await Cart_1.default.findOne({ userId: req.user.id });
    if (!cart) {
        throw new ApiError_1.ApiError(404, 'Cart not found');
    }
    cart.items = cart.items.filter((entry) => entry.productId.toString() !== String(req.params.productId));
    await cart.save();
    res.status(200).json(await serializeCart(req.user.id));
});
//# sourceMappingURL=shopController.js.map