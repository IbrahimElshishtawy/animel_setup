"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.sendMessage = exports.getMessages = exports.getConversationMessages = exports.getConversations = void 0;
const Conversation_1 = __importDefault(require("../models/Conversation"));
const Message_1 = __importDefault(require("../models/Message"));
const User_1 = __importDefault(require("../models/User"));
const chatService_1 = require("../services/chatService");
const ApiError_1 = require("../utils/ApiError");
const asyncHandler_1 = require("../utils/asyncHandler");
exports.getConversations = (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const conversations = await Conversation_1.default.find({
        participantIds: req.user.id,
    })
        .populate('participantIds', 'name email phoneNumber profileImageUrl')
        .sort({ lastMessageAt: -1, updatedAt: -1 });
    const payload = conversations.map((conversation) => {
        const participants = conversation.participantIds.filter((participant) => participant._id.toString() !== req.user.id);
        return {
            _id: conversation._id,
            participants,
            lastMessage: conversation.lastMessage,
            lastMessageAt: conversation.lastMessageAt,
        };
    });
    res.status(200).json(payload);
});
exports.getConversationMessages = (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const conversation = await Conversation_1.default.findOne({
        _id: req.params.conversationId,
        participantIds: req.user.id,
    });
    if (!conversation) {
        throw new ApiError_1.ApiError(404, 'Conversation not found');
    }
    const messages = await Message_1.default.find({ conversationId: conversation._id }).sort({
        createdAt: 1,
    });
    res.status(200).json(messages);
});
exports.getMessages = (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const otherUser = await User_1.default.findById(req.params.otherUserId);
    if (!otherUser) {
        throw new ApiError_1.ApiError(404, 'Recipient not found');
    }
    const conversation = await (0, chatService_1.ensureConversation)(req.user.id, String(req.params.otherUserId));
    const messages = await Message_1.default.find({ conversationId: conversation._id }).sort({
        createdAt: 1,
    });
    res.status(200).json({
        conversationId: conversation._id,
        messages,
    });
});
exports.sendMessage = (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const { receiverId, content } = req.body;
    const receiver = await User_1.default.findById(receiverId);
    if (!receiver) {
        throw new ApiError_1.ApiError(404, 'Recipient not found');
    }
    if (req.user.id === String(receiverId)) {
        throw new ApiError_1.ApiError(400, 'You cannot message yourself');
    }
    const conversation = await (0, chatService_1.ensureConversation)(req.user.id, String(receiverId));
    const message = await Message_1.default.create({
        conversationId: conversation._id,
        senderId: req.user.id,
        receiverId,
        content,
    });
    conversation.lastMessage = content;
    conversation.lastMessageAt = new Date();
    await conversation.save();
    res.status(201).json({
        conversationId: conversation._id,
        message,
    });
});
//# sourceMappingURL=chatController.js.map