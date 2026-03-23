"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const mongoose_1 = require("mongoose");
const adoptionRequestSchema = new mongoose_1.Schema({
    animalId: { type: mongoose_1.Schema.Types.ObjectId, ref: 'Animal', required: true },
    requesterId: { type: mongoose_1.Schema.Types.ObjectId, ref: 'User', required: true },
    ownerId: { type: mongoose_1.Schema.Types.ObjectId, ref: 'User', required: true },
    message: { type: String, required: true, trim: true },
    status: {
        type: String,
        enum: ['pending', 'approved', 'rejected'],
        default: 'pending',
    },
}, { timestamps: true });
adoptionRequestSchema.index({ animalId: 1, requesterId: 1 }, {
    unique: true,
});
const AdoptionRequest = (0, mongoose_1.model)('AdoptionRequest', adoptionRequestSchema);
exports.default = AdoptionRequest;
//# sourceMappingURL=AdoptionRequest.js.map