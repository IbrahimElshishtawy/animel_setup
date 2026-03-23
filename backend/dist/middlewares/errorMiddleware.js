"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.errorHandler = void 0;
const ApiError_1 = require("../utils/ApiError");
const errorHandler = (error, _req, res, _next) => {
    const statusCode = error instanceof ApiError_1.ApiError ? error.statusCode : 500;
    res.status(statusCode).json({
        message: statusCode === 500 ? 'Something went wrong on the server' : error.message,
    });
};
exports.errorHandler = errorHandler;
//# sourceMappingURL=errorMiddleware.js.map