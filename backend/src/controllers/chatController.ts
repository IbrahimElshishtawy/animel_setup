import type { Request, Response } from 'express';
import Conversation from '../models/Conversation';
import Message from '../models/Message';
import User from '../models/User';
import { ensureConversation } from '../services/chatService';
import { ApiError } from '../utils/ApiError';
import { asyncHandler } from '../utils/asyncHandler';

export const getConversations = asyncHandler(async (req: Request, res: Response) => {
  const conversations = await Conversation.find({
    participantIds: req.user!.id,
  })
    .populate('participantIds', 'name email phoneNumber profileImageUrl')
    .sort({ lastMessageAt: -1, updatedAt: -1 });

  const payload = conversations.map((conversation) => {
    const participants = (
      conversation.participantIds as unknown as Array<{
        _id: string;
        name: string;
        email: string;
        phoneNumber: string;
        profileImageUrl?: string;
      }>
    ).filter((participant) => participant._id.toString() !== req.user!.id);

    return {
      _id: conversation._id,
      participants,
      lastMessage: conversation.lastMessage,
      lastMessageAt: conversation.lastMessageAt,
    };
  });

  res.status(200).json(payload);
});

export const getConversationMessages = asyncHandler(
  async (req: Request, res: Response) => {
    const conversation = await Conversation.findOne({
      _id: req.params.conversationId,
      participantIds: req.user!.id,
    });

    if (!conversation) {
      throw new ApiError(404, 'Conversation not found');
    }

    const messages = await Message.find({ conversationId: conversation._id }).sort({
      createdAt: 1,
    });

    res.status(200).json(messages);
  },
);

export const getMessages = asyncHandler(async (req: Request, res: Response) => {
  const otherUser = await User.findById(req.params.otherUserId);
  if (!otherUser) {
    throw new ApiError(404, 'Recipient not found');
  }

  const conversation = await ensureConversation(req.user!.id, String(req.params.otherUserId));
  const messages = await Message.find({ conversationId: conversation._id }).sort({
    createdAt: 1,
  });

  res.status(200).json({
    conversationId: conversation._id,
    messages,
  });
});

export const sendMessage = asyncHandler(async (req: Request, res: Response) => {
  const { receiverId, content } = req.body;

  const receiver = await User.findById(receiverId);
  if (!receiver) {
    throw new ApiError(404, 'Recipient not found');
  }

  if (req.user!.id === String(receiverId)) {
    throw new ApiError(400, 'You cannot message yourself');
  }

  const conversation = await ensureConversation(req.user!.id, String(receiverId));
  const message = await Message.create({
    conversationId: conversation._id,
    senderId: req.user!.id,
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
