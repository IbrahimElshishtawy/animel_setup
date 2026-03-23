"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.sanitizeUser = exports.generateToken = void 0;
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const env_1 = require("../config/env");
const generateToken = (userId) => jsonwebtoken_1.default.sign({ id: userId.toString() }, env_1.env.jwtSecret, {
    expiresIn: env_1.env.jwtExpiresIn,
});
exports.generateToken = generateToken;
const sanitizeUser = (user) => ({
    _id: user._id,
    name: user.name,
    email: user.email,
    phoneNumber: user.phoneNumber,
    journey: user.journey,
    profileImageUrl: user.profileImageUrl,
    location: user.location,
    language: user.language,
    bio: user.bio,
    createdAt: user.createdAt,
    updatedAt: user.updatedAt,
});
exports.sanitizeUser = sanitizeUser;
//# sourceMappingURL=authService.js.map