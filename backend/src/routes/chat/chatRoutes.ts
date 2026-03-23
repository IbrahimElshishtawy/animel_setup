import { Router } from 'express';
import {
  getConversationMessages,
  getConversations,
  getMessages,
  sendMessage,
} from '../../controllers/chat/chatController';
import { authMiddleware } from '../../middlewares/authMiddleware';
import { validateBody } from '../../middlewares/validate';

const router = Router();

router.get('/conversations', authMiddleware, getConversations);
router.get(
  '/conversations/:conversationId/messages',
  authMiddleware,
  getConversationMessages,
);
router.get('/messages/:otherUserId', authMiddleware, getMessages);
router.post(
  '/messages',
  authMiddleware,
  validateBody([
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
  ]),
  sendMessage,
);

export default router;
