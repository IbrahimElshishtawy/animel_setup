"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const bcryptjs_1 = __importDefault(require("bcryptjs"));
const mongoose_1 = require("mongoose");
const userSchema = new mongoose_1.Schema({
    name: { type: String, required: true, trim: true },
    email: { type: String, required: true, unique: true, lowercase: true, trim: true },
    password: { type: String, required: true, minlength: 6 },
    phoneNumber: { type: String, required: true, trim: true },
    journey: {
        type: String,
        enum: ['pet_owner', 'buyer', 'adopter'],
    },
    profileImageUrl: { type: String, trim: true },
    location: { type: String, trim: true },
    language: {
        type: String,
        enum: ['en', 'ar'],
        default: 'en',
    },
    bio: { type: String, trim: true, maxlength: 280 },
}, { timestamps: true });
userSchema.pre('save', async function saveHook() {
    if (!this.isModified('password')) {
        return;
    }
    this.password = await bcryptjs_1.default.hash(this.password, 10);
});
userSchema.methods.comparePassword = function comparePassword(password) {
    return bcryptjs_1.default.compare(password, this.password);
};
const User = (0, mongoose_1.model)('User', userSchema);
exports.default = User;
//# sourceMappingURL=User.js.map