"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const chatController_1 = require("../controllers/chatController");
const authMiddleware_1 = require("../middlewares/authMiddleware");
const router = (0, express_1.Router)();
router.get('/messages/:otherUserId', authMiddleware_1.authMiddleware, chatController_1.getMessages);
router.post('/messages', authMiddleware_1.authMiddleware, chatController_1.sendMessage);
exports.default = router;
//# sourceMappingURL=chatRoutes.js.map