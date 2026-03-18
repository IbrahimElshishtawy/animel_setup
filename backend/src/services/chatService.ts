import { Types } from 'mongoose';
import Conversation from '../models/Conversation';

export const ensureConversation = async (userId: string, otherUserId: string) => {
  const sortedIds = [userId, otherUserId].sort();

  let conversation = await Conversation.findOne({
    participantIds: { $all: sortedIds, $size: 2 },
  });

  if (!conversation) {
    conversation = await Conversation.create({
      participantIds: sortedIds.map((id) => new Types.ObjectId(id)),
    });
  }

  return conversation;
};
