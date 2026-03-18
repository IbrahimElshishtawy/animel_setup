"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const cors_1 = __importDefault(require("cors"));
const dotenv_1 = __importDefault(require("dotenv"));
const animalRoutes_1 = __importDefault(require("./routes/animalRoutes"));
const userRoutes_1 = __importDefault(require("./routes/userRoutes"));
const shopRoutes_1 = __importDefault(require("./routes/shopRoutes"));
const chatRoutes_1 = __importDefault(require("./routes/chatRoutes"));
dotenv_1.default.config();
const app = (0, express_1.default)();
const PORT = process.env.PORT || 5000;
app.use((0, cors_1.default)());
app.use(express_1.default.json());
// Routes
app.use('/api/animals', animalRoutes_1.default);
app.use('/api/users', userRoutes_1.default);
app.use('/api/shop', shopRoutes_1.default);
app.use('/api/chat', chatRoutes_1.default);
// Basic health check
app.get('/health', (req, res) => {
    res.status(200).json({ status: 'OK', message: 'Backend is running' });
});
// Start server
if (process.env.NODE_ENV !== 'test') {
    app.listen(PORT, () => {
        console.log(`Server is running on port ${PORT}`);
    });
}
exports.default = app;
//# sourceMappingURL=index.js.map