"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const chatController_1 = require("../controllers/chatController");
const authMiddleware_1 = require("../middlewares/authMiddleware");
const validate_1 = require("../middlewares/validate");
const router = (0, express_1.Router)();
router.get('/conversations', authMiddleware_1.authMiddleware, chatController_1.getConversations);
router.get('/conversations/:conversationId/messages', authMiddleware_1.authMiddleware, chatController_1.getConversationMessages);
router.get('/messages/:otherUserId', authMiddleware_1.authMiddleware, chatController_1.getMessages);
router.post('/messages', authMiddleware_1.authMiddleware, (0, validate_1.validateBody)([
    {
        field: 'receiverId',
        required: true,
        type: 'string',
        minLength: 8,
        message: 'Receiver ID is required',
    },
    {
        field: 'content',
        required: true,
        type: 'string',
        minLength: 1,
        message: 'Message content is required',
    },
]), chatController_1.sendMessage);
exports.default = router;
//# sourceMappingURL=chatRoutes.js.map