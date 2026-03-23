import { Router } from 'express';
import {
  addCartItem,
  createProduct,
  getCart,
  getProductCategories,
  getProductDetails,
  getProducts,
  removeCartItem,
  updateCartItem,
} from '../../controllers/shop/shopController';
import { authMiddleware } from '../../middlewares/authMiddleware';
import { validateBody } from '../../middlewares/validate';

const router = Router();

router.get('/products', getProducts);
router.get('/products/:id', getProductDetails);
router.get('/categories', getProductCategories);
router.post(
  '/products',
  authMiddleware,
  validateBody([
    { field: 'name', required: true, type: 'string', minLength: 2, message: 'Name is required' },
    { field: 'category', required: true, type: 'string', minLength: 2, message: 'Category is required' },
    { field: 'description', required: true, type: 'string', minLength: 5, message: 'Description is required' },
    { field: 'imageUrl', required: true, type: 'string', minLength: 5, message: 'Image URL is required' },
    { field: 'animalType', required: true, type: 'string', minLength: 2, message: 'Animal type is required' },
    { field: 'price', required: true, message: 'Price is required' },
  ]),
  createProduct,
);
router.get('/cart', authMiddleware, getCart);
router.post(
  '/cart/items',
  authMiddleware,
  validateBody([
    { field: 'productId', required: true, type: 'string', minLength: 8, message: 'Product ID is required' },
    {
      field: 'quantity',
      required: true,
      validator: (value) => Number(value) > 0,
      message: 'Quantity must be greater than zero',
    },
  ]),
  addCartItem,
);
router.put(
  '/cart/items/:productId',
  authMiddleware,
  validateBody([
    {
      field: 'quantity',
      required: true,
      validator: (value) => Number(value) >= 0,
      message: 'Quantity must be zero or more',
    },
  ]),
  updateCartItem,
);
router.delete('/cart/items/:productId', authMiddleware, removeCartItem);

export default router;
