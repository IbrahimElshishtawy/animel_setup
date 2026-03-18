import { Request, Response } from 'express';
import Message from '../models/Message';

export const getMessages = async (req: Request, res: Response) => {
  try {
    const { otherUserId } = req.params;
    const userId = (req as any).user.id;

    const messages = await Message.find({
      $or: [
        { senderId: userId, receiverId: otherUserId },
        { senderId: otherUserId, receiverId: userId },
      ],
    }).sort({ timestamp: 1 });

    res.json(messages);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching messages', error });
  }
};

export const sendMessage = async (req: Request, res: Response) => {
  try {
    const { receiverId, content } = req.body;
    const senderId = (req as any).user.id;

    const message = new Message({
      senderId,
      receiverId,
      content,
    });

    await message.save();
    res.status(201).json(message);
  } catch (error) {
    res.status(400).json({ message: 'Error sending message', error });
  }
};
