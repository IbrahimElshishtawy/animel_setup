import { Router } from 'express';
import { getAnimals, createAnimal, updateAnimal, deleteAnimal } from '../controllers/animalController';
import { authMiddleware } from '../middlewares/authMiddleware';

const router = Router();

router.get('/', getAnimals);
router.post('/', authMiddleware, createAnimal);
router.put('/:id', authMiddleware, updateAnimal);
router.delete('/:id', authMiddleware, deleteAnimal);

export default router;
