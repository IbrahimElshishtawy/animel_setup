import { Router } from 'express';
import {
  createAdoptionRequest,
  createAnimal,
  deleteAnimal,
  getAnimalById,
  getAnimals,
  getMyAnimals,
  getMyReceivedAdoptionRequests,
  getMySentAdoptionRequests,
  updateAdoptionRequestStatus,
  updateAnimal,
} from '../controllers/animalController';
import { authMiddleware } from '../middlewares/authMiddleware';
import { validateBody } from '../middlewares/validate';

const router = Router();

router.get('/', getAnimals);
router.get('/mine', authMiddleware, getMyAnimals);
router.get('/adoption-requests/sent', authMiddleware, getMySentAdoptionRequests);
router.get('/adoption-requests/received', authMiddleware, getMyReceivedAdoptionRequests);
router.patch(
  '/adoption-requests/:requestId',
  authMiddleware,
  validateBody([
    {
      field: 'status',
      required: true,
      type: 'string',
      validator: (value) => ['pending', 'approved', 'rejected'].includes(String(value)),
      message: 'Status must be pending, approved, or rejected',
    },
  ]),
  updateAdoptionRequestStatus,
);
router.get('/:id', getAnimalById);
router.post(
  '/',
  authMiddleware,
  validateBody([
    { field: 'name', required: true, type: 'string', minLength: 2, message: 'Name is required' },
    { field: 'type', required: true, type: 'string', minLength: 2, message: 'Type is required' },
    { field: 'breed', required: true, type: 'string', minLength: 2, message: 'Breed is required' },
    { field: 'age', required: true, type: 'string', minLength: 1, message: 'Age is required' },
    { field: 'gender', required: true, type: 'string', minLength: 1, message: 'Gender is required' },
    { field: 'size', required: true, type: 'string', minLength: 1, message: 'Size is required' },
    { field: 'price', required: true, message: 'Price is required' },
    { field: 'location', required: true, type: 'string', minLength: 2, message: 'Location is required' },
    { field: 'latitude', required: true, message: 'Latitude is required' },
    { field: 'longitude', required: true, message: 'Longitude is required' },
    { field: 'description', required: true, type: 'string', minLength: 10, message: 'Description is required' },
    { field: 'imageUrls', required: true, type: 'array', message: 'At least one image URL is required' },
    { field: 'healthStatus', required: true, type: 'string', minLength: 2, message: 'Health status is required' },
  ]),
  createAnimal,
);
router.put('/:id', authMiddleware, updateAnimal);
router.delete('/:id', authMiddleware, deleteAnimal);
router.post(
  '/:id/adoption-request',
  authMiddleware,
  validateBody([
    {
      field: 'message',
      required: true,
      type: 'string',
      minLength: 5,
      message: 'Adoption message is required',
    },
  ]),
  createAdoptionRequest,
);

export default router;
