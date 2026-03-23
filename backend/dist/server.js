"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const mongoose_1 = __importDefault(require("mongoose"));
const app_1 = __importDefault(require("./app"));
const env_1 = require("./config/env");
const database_1 = require("./config/database");
mongoose_1.default.set('strictQuery', true);
const startServer = async () => {
    await (0, database_1.connectDatabase)();
    app_1.default.listen(env_1.env.port, env_1.env.host, () => {
        console.log(`Animal Connect backend listening on http://${env_1.env.host}:${env_1.env.port}`);
    });
};
startServer().catch((error) => {
    console.error('Failed to start Animal Connect backend', error);
    process.exit(1);
});
//# sourceMappingURL=server.js.map