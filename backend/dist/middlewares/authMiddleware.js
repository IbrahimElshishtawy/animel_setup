"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.authMiddleware = void 0;
const jsonwebtoken_1 = __importDefault(require("jsonwebtoken"));
const env_1 = require("../config/env");
const ApiError_1 = require("../utils/ApiError");
const authMiddleware = (req, _res, next) => {
    const token = req.header('Authorization')?.replace('Bearer ', '').trim();
    if (!token) {
        next(new ApiError_1.ApiError(401, 'Authentication token is required'));
        return;
    }
    try {
        const decoded = jsonwebtoken_1.default.verify(token, env_1.env.jwtSecret);
        req.user = { id: decoded.id };
        next();
    }
    catch (_error) {
        next(new ApiError_1.ApiError(401, 'Authentication token is invalid or expired'));
    }
};
exports.authMiddleware = authMiddleware;
//# sourceMappingURL=authMiddleware.js.map