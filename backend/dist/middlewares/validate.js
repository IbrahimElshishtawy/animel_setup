"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.validateBody = void 0;
const ApiError_1 = require("../utils/ApiError");
const validateBody = (rules) => (req, _res, next) => {
    for (const rule of rules) {
        const value = req.body?.[rule.field];
        if (rule.required && (value === undefined || value === null || value === '')) {
            return next(new ApiError_1.ApiError(400, rule.message));
        }
        if (value === undefined || value === null) {
            continue;
        }
        if (rule.type === 'string' && typeof value !== 'string') {
            return next(new ApiError_1.ApiError(400, rule.message));
        }
        if (rule.type === 'number' && typeof value !== 'number') {
            return next(new ApiError_1.ApiError(400, rule.message));
        }
        if (rule.type === 'boolean' && typeof value !== 'boolean') {
            return next(new ApiError_1.ApiError(400, rule.message));
        }
        if (rule.type === 'array' && !Array.isArray(value)) {
            return next(new ApiError_1.ApiError(400, rule.message));
        }
        if (rule.type === 'string' &&
            rule.minLength &&
            typeof value === 'string' &&
            value.trim().length < rule.minLength) {
            return next(new ApiError_1.ApiError(400, rule.message));
        }
        if (rule.validator && !rule.validator(value, req)) {
            return next(new ApiError_1.ApiError(400, rule.message));
        }
    }
    next();
};
exports.validateBody = validateBody;
//# sourceMappingURL=validate.js.map