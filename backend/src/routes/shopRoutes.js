"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const shopController_1 = require("../controllers/shopController");
const authMiddleware_1 = require("../middlewares/authMiddleware");
const router = (0, express_1.Router)();
router.get('/products', shopController_1.getProducts);
router.post('/products', authMiddleware_1.authMiddleware, shopController_1.createProduct);
exports.default = router;
//# sourceMappingURL=shopRoutes.js.map