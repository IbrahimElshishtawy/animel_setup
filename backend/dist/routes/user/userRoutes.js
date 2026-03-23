"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const userController_1 = require("../../controllers/user/userController");
const authMiddleware_1 = require("../../middlewares/authMiddleware");
const validate_1 = require("../../middlewares/validate");
const router = (0, express_1.Router)();
router.post('/register', (0, validate_1.validateBody)([
    { field: 'name', required: true, type: 'string', minLength: 2, message: 'Name is required' },
    {
        field: 'email',
        required: true,
        type: 'string',
        validator: (value) => /\S+@\S+\.\S+/.test(String(value)),
        message: 'A valid email is required',
    },
    {
        field: 'password',
        required: true,
        type: 'string',
        minLength: 6,
        message: 'Password must be at least 6 characters',
    },
    {
        field: 'phoneNumber',
        required: true,
        type: 'string',
        minLength: 6,
        message: 'Phone number is required',
    },
]), userController_1.register);
router.post('/login', (0, validate_1.validateBody)([
    {
        field: 'email',
        required: true,
        type: 'string',
        validator: (value) => /\S+@\S+\.\S+/.test(String(value)),
        message: 'A valid email is required',
    },
    {
        field: 'password',
        required: true,
        type: 'string',
        minLength: 6,
        message: 'Password must be at least 6 characters',
    },
]), userController_1.login);
router.post('/logout', authMiddleware_1.authMiddleware, userController_1.logout);
router.get('/profile', authMiddleware_1.authMiddleware, userController_1.getProfile);
router.put('/profile', authMiddleware_1.authMiddleware, userController_1.updateProfile);
router.get('/nearby', authMiddleware_1.authMiddleware, userController_1.getNearbyUsers);
router.get('/search', authMiddleware_1.authMiddleware, userController_1.searchUsers);
exports.default = router;
//# sourceMappingURL=userRoutes.js.map