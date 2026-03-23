"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ensureConversation = void 0;
const mongoose_1 = require("mongoose");
const Conversation_1 = __importDefault(require("../models/Conversation"));
const ensureConversation = async (userId, otherUserId) => {
    const sortedIds = [userId, otherUserId].sort();
    let conversation = await Conversation_1.default.findOne({
        participantIds: { $all: sortedIds, $size: 2 },
    });
    if (!conversation) {
        conversation = await Conversation_1.default.create({
            participantIds: sortedIds.map((id) => new mongoose_1.Types.ObjectId(id)),
        });
    }
    return conversation;
};
exports.ensureConversation = ensureConversation;
//# sourceMappingURL=chatService.js.map