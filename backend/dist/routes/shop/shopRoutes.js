"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const shopController_1 = require("../../controllers/shop/shopController");
const authMiddleware_1 = require("../../middlewares/authMiddleware");
const validate_1 = require("../../middlewares/validate");
const router = (0, express_1.Router)();
router.get('/products', shopController_1.getProducts);
router.get('/products/:id', shopController_1.getProductDetails);
router.get('/categories', shopController_1.getProductCategories);
router.post('/products', authMiddleware_1.authMiddleware, (0, validate_1.validateBody)([
    { field: 'name', required: true, type: 'string', minLength: 2, message: 'Name is required' },
    { field: 'category', required: true, type: 'string', minLength: 2, message: 'Category is required' },
    { field: 'description', required: true, type: 'string', minLength: 5, message: 'Description is required' },
    { field: 'imageUrl', required: true, type: 'string', minLength: 5, message: 'Image URL is required' },
    { field: 'animalType', required: true, type: 'string', minLength: 2, message: 'Animal type is required' },
    { field: 'price', required: true, message: 'Price is required' },
]), shopController_1.createProduct);
router.get('/cart', authMiddleware_1.authMiddleware, shopController_1.getCart);
router.post('/cart/items', authMiddleware_1.authMiddleware, (0, validate_1.validateBody)([
    { field: 'productId', required: true, type: 'string', minLength: 8, message: 'Product ID is required' },
    {
        field: 'quantity',
        required: true,
        validator: (value) => Number(value) > 0,
        message: 'Quantity must be greater than zero',
    },
]), shopController_1.addCartItem);
router.put('/cart/items/:productId', authMiddleware_1.authMiddleware, (0, validate_1.validateBody)([
    {
        field: 'quantity',
        required: true,
        validator: (value) => Number(value) >= 0,
        message: 'Quantity must be zero or more',
    },
]), shopController_1.updateCartItem);
router.delete('/cart/items/:productId', authMiddleware_1.authMiddleware, shopController_1.removeCartItem);
exports.default = router;
//# sourceMappingURL=shopRoutes.js.map