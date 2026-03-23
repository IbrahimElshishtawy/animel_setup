"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const cors_1 = __importDefault(require("cors"));
const path_1 = __importDefault(require("path"));
const dotenv_1 = __importDefault(require("dotenv"));
const express_1 = __importDefault(require("express"));
const animalRoutes_1 = __importDefault(require("./routes/animal/animalRoutes"));
const chatRoutes_1 = __importDefault(require("./routes/chat/chatRoutes"));
const mapRoutes_1 = __importDefault(require("./routes/mapRoutes"));
const shopRoutes_1 = __importDefault(require("./routes/shop/shopRoutes"));
const userRoutes_1 = __importDefault(require("./routes/user/userRoutes"));
const errorMiddleware_1 = require("./middlewares/errorMiddleware");
const notFoundMiddleware_1 = require("./middlewares/notFoundMiddleware");
dotenv_1.default.config({ path: path_1.default.resolve(__dirname, '../.env') });
const app = (0, express_1.default)();
app.use((0, cors_1.default)({
    origin: '*',
    credentials: true,
}));
app.use(express_1.default.json({ limit: '10mb' }));
app.use(express_1.default.urlencoded({ extended: true }));
app.get('/health', (_req, res) => {
    res.status(200).json({
        status: 'ok',
        service: 'animal-connect-backend',
        timestamp: new Date().toISOString(),
    });
});
app.use('/api/users', userRoutes_1.default);
app.use('/api/animals', animalRoutes_1.default);
app.use('/api/shop', shopRoutes_1.default);
app.use('/api/chat', chatRoutes_1.default);
app.use('/api/maps', mapRoutes_1.default);
app.use(notFoundMiddleware_1.notFoundHandler);
app.use(errorMiddleware_1.errorHandler);
exports.default = app;
//# sourceMappingURL=app.js.map