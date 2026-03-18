import { Router } from 'express';
import {
  getProfile,
  login,
  logout,
  register,
  searchUsers,
  updateProfile,
} from '../controllers/userController';
import { authMiddleware } from '../middlewares/authMiddleware';
import { validateBody } from '../middlewares/validate';

const router = Router();

router.post(
  '/register',
  validateBody([
    { field: 'name', required: true, type: 'string', minLength: 2, message: 'Name is required' },
    {
      field: 'email',
      required: true,
      type: 'string',
      validator: (value) => /\S+@\S+\.\S+/.test(String(value)),
      message: 'A valid email is required',
    },
    {
      field: 'password',
      required: true,
      type: 'string',
      minLength: 6,
      message: 'Password must be at least 6 characters',
    },
    {
      field: 'phoneNumber',
      required: true,
      type: 'string',
      minLength: 6,
      message: 'Phone number is required',
    },
  ]),
  register,
);
router.post(
  '/login',
  validateBody([
    {
      field: 'email',
      required: true,
      type: 'string',
      validator: (value) => /\S+@\S+\.\S+/.test(String(value)),
      message: 'A valid email is required',
    },
    {
      field: 'password',
      required: true,
      type: 'string',
      minLength: 6,
      message: 'Password must be at least 6 characters',
    },
  ]),
  login,
);
router.post('/logout', authMiddleware, logout);
router.get('/profile', authMiddleware, getProfile);
router.put('/profile', authMiddleware, updateProfile);
router.get('/search', authMiddleware, searchUsers);

export default router;
