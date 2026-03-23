"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.connectDatabase = void 0;
const mongoose_1 = __importDefault(require("mongoose"));
const env_1 = require("./env");
let isConnected = false;
const connectDatabase = async () => {
    if (isConnected) {
        return mongoose_1.default.connection;
    }
    try {
        await mongoose_1.default.connect(env_1.env.mongoUri);
        isConnected = true;
        console.log('Connected to MongoDB');
        return mongoose_1.default.connection;
    }
    catch (error) {
        const originalError = error instanceof Error ? `${error.name}: ${error.message}` : String(error);
        const setupHint = env_1.env.isDefaultMongoUri
            ? 'No MONGO_URI was found, so the app tried the default local MongoDB instance. Start MongoDB on port 27017 or create a .env file based on .env.example with a reachable MONGO_URI.'
            : 'The configured MONGO_URI could not be reached. Verify the value in your .env file and make sure that MongoDB is running and accessible from this machine.';
        throw new Error([
            `MongoDB connection failed for URI: ${env_1.env.mongoUri}`,
            setupHint,
            `Original error: ${originalError}`,
        ].join('\n'));
    }
};
exports.connectDatabase = connectDatabase;
//# sourceMappingURL=database.js.map