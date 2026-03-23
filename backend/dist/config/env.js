"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.env = void 0;
const path_1 = __importDefault(require("path"));
const dotenv_1 = __importDefault(require("dotenv"));
dotenv_1.default.config({ path: path_1.default.resolve(__dirname, '../../.env') });
const ensureString = (value, fallback = '') => value?.trim() || fallback;
const defaultMongoUri = 'mongodb://127.0.0.1:27017/animal-connect';
const configuredMongoUri = ensureString(process.env.MONGO_URI);
exports.env = {
    nodeEnv: ensureString(process.env.NODE_ENV, 'development'),
    host: ensureString(process.env.HOST, '0.0.0.0'),
    port: Number(process.env.PORT || 5000),
    mongoUri: configuredMongoUri || defaultMongoUri,
    isDefaultMongoUri: !configuredMongoUri,
    jwtSecret: ensureString(process.env.JWT_SECRET, 'animal-connect-dev-secret'),
    jwtExpiresIn: ensureString(process.env.JWT_EXPIRES_IN, '7d'),
};
//# sourceMappingURL=env.js.map