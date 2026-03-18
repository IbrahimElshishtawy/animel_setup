import { Router } from 'express';
import { getMessages, sendMessage } from '../controllers/chatController';
import { authMiddleware } from '../middlewares/authMiddleware';

const router = Router();

router.get('/messages/:otherUserId', authMiddleware, getMessages);
router.post('/messages', authMiddleware, sendMessage);

export default router;
