"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.sendMessage = exports.getMessages = void 0;
const express_1 = require("express");
const Message_1 = __importDefault(require("../models/Message"));
const getMessages = async (req, res) => {
    try {
        const { otherUserId } = req.params;
        const userId = req.user.id;
        const messages = await Message_1.default.find({
            $or: [
                { senderId: userId, receiverId: otherUserId },
                { senderId: otherUserId, receiverId: userId },
            ],
        }).sort({ timestamp: 1 });
        res.json(messages);
    }
    catch (error) {
        res.status(500).json({ message: 'Error fetching messages', error });
    }
};
exports.getMessages = getMessages;
const sendMessage = async (req, res) => {
    try {
        const { receiverId, content } = req.body;
        const senderId = req.user.id;
        const message = new Message_1.default({
            senderId,
            receiverId,
            content,
        });
        await message.save();
        res.status(201).json(message);
    }
    catch (error) {
        res.status(400).json({ message: 'Error sending message', error });
    }
};
exports.sendMessage = sendMessage;
//# sourceMappingURL=chatController.js.map