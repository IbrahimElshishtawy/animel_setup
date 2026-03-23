"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const mongoose_1 = require("mongoose");
const cartSchema = new mongoose_1.Schema({
    userId: { type: mongoose_1.Schema.Types.ObjectId, ref: 'User', required: true, unique: true },
    items: [
        {
            productId: { type: mongoose_1.Schema.Types.ObjectId, ref: 'Product', required: true },
            quantity: { type: Number, required: true, min: 1 },
            priceSnapshot: { type: Number, required: true, min: 0 },
        },
    ],
}, { timestamps: true });
const Cart = (0, mongoose_1.model)('Cart', cartSchema);
exports.default = Cart;
//# sourceMappingURL=Cart.js.map