import { Router } from 'express';
import { getProducts, createProduct } from '../controllers/shopController';
import { authMiddleware } from '../middlewares/authMiddleware';

const router = Router();

router.get('/products', getProducts);
router.post('/products', authMiddleware, createProduct);

export default router;
