import { Router } from 'express';
import { getAnimals, createAnimal } from '../controllers/animalController';

const router = Router();

router.get('/', getAnimals);
router.post('/', createAnimal);

export default router;
