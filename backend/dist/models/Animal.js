"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const mongoose_1 = require("mongoose");
const animalSchema = new mongoose_1.Schema({
    name: { type: String, required: true, trim: true },
    type: { type: String, required: true, trim: true },
    breed: { type: String, required: true, trim: true },
    age: { type: String, required: true, trim: true },
    gender: { type: String, required: true, trim: true },
    size: { type: String, required: true, trim: true },
    price: { type: Number, required: true, min: 0 },
    location: { type: String, required: true, trim: true },
    latitude: { type: Number, required: true },
    longitude: { type: Number, required: true },
    description: { type: String, required: true, trim: true },
    imageUrls: { type: [String], required: true, default: [] },
    isForAdoption: { type: Boolean, required: true, default: false },
    ownerId: { type: mongoose_1.Schema.Types.ObjectId, ref: 'User', required: true },
    healthStatus: { type: String, required: true, trim: true },
}, { timestamps: true });
const Animal = (0, mongoose_1.model)('Animal', animalSchema);
exports.default = Animal;
//# sourceMappingURL=Animal.js.map