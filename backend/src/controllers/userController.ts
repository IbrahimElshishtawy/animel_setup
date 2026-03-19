import type { Request, Response } from 'express';
import User from '../models/User';
import { generateToken, sanitizeUser } from '../services/authService';
import { ApiError } from '../utils/ApiError';
import { asyncHandler } from '../utils/asyncHandler';

export const register = asyncHandler(async (req: Request, res: Response) => {
  const {
    name,
    email,
    password,
    phoneNumber,
    journey,
    language,
    location,
    bio,
    profileImageUrl,
  } =
    req.body;

  const existingUser = await User.findOne({ email: String(email).toLowerCase() });
  if (existingUser) {
    throw new ApiError(409, 'An account already exists for this email');
  }

  const user = await User.create({
    name,
    email,
    password,
    phoneNumber,
    journey,
    language: language || 'en',
    location,
    bio,
    profileImageUrl,
  });

  res.status(201).json({
    user: sanitizeUser(user),
    token: generateToken(user._id),
  });
});

export const login = asyncHandler(async (req: Request, res: Response) => {
  const { email, password } = req.body;

  const user = await User.findOne({ email: String(email).toLowerCase() });
  if (!user || !(await user.comparePassword(String(password))) ) {
    throw new ApiError(401, 'Invalid email or password');
  }

  res.status(200).json({
    user: sanitizeUser(user),
    token: generateToken(user._id),
  });
});

export const logout = asyncHandler(async (_req: Request, res: Response) => {
  res.status(200).json({ message: 'Logged out successfully' });
});

export const getProfile = asyncHandler(async (req: Request, res: Response) => {
  const user = await User.findById(req.user?.id);
  if (!user) {
    throw new ApiError(404, 'User not found');
  }

  res.status(200).json(sanitizeUser(user));
});

export const updateProfile = asyncHandler(async (req: Request, res: Response) => {
  const user = await User.findById(req.user?.id);
  if (!user) {
    throw new ApiError(404, 'User not found');
  }

  const updatableFields = [
    'name',
    'phoneNumber',
    'journey',
    'profileImageUrl',
    'location',
    'language',
    'bio',
  ] as const;

  for (const field of updatableFields) {
    const nextValue = req.body?.[field];
    if (nextValue !== undefined) {
      (user as unknown as Record<string, unknown>)[field] = nextValue;
    }
  }

  if (req.body?.password) {
    user.password = req.body.password;
  }

  await user.save();

  res.status(200).json(sanitizeUser(user));
});

export const searchUsers = asyncHandler(async (req: Request, res: Response) => {
  const query = String(req.query.query || '').trim();
  const filter = query
    ? {
        $or: [
          { name: { $regex: query, $options: 'i' } },
          { email: { $regex: query, $options: 'i' } },
        ],
      }
    : {};

  const users = await User.find(filter).sort({ createdAt: -1 }).limit(20);

  res.status(200).json(users.map((user) => sanitizeUser(user)));
});
