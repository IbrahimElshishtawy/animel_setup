import type { Request, Response } from 'express';
import User from '../models/User';
import { generateToken, sanitizeUser } from '../services/authService';
import { ApiError } from '../utils/ApiError';
import { asyncHandler } from '../utils/asyncHandler';

const normalizeLocation = (value: string) =>
  value
    .toLowerCase()
    .replace(/[^\p{L}\p{N}\s,]/gu, ' ')
    .replace(/\s+/g, ' ')
    .trim();

const locationKeywords = (value: string) => {
  const tokens = normalizeLocation(value)
    .split(/[\s,]+/)
    .map((token) => token.trim())
    .filter((token) => token.length >= 3);

  return Array.from(new Set(tokens)).slice(0, 6);
};

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

export const getNearbyUsers = asyncHandler(async (req: Request, res: Response) => {
  const currentUser = await User.findById(req.user?.id);
  if (!currentUser) {
    throw new ApiError(404, 'User not found');
  }

  const requestedJourney = String(req.query.journey || '').trim();
  const journey =
    requestedJourney === 'pet_owner' ||
    requestedJourney === 'buyer' ||
    requestedJourney === 'adopter'
      ? requestedJourney
      : undefined;

  const targetLocation = String(currentUser.location || '').trim();
  const normalizedTargetLocation = normalizeLocation(targetLocation);
  const keywords = locationKeywords(targetLocation);

  const candidates = await User.find({
    _id: { $ne: currentUser._id },
    location: { $exists: true, $ne: '' },
    ...(journey ? { journey } : {}),
  })
    .sort({ createdAt: -1 })
    .limit(normalizedTargetLocation ? 40 : 16);

  const scoredUsers = candidates
    .map((user) => {
      const normalizedCandidateLocation = normalizeLocation(user.location || '');
      let score = 0;

      if (normalizedTargetLocation && normalizedCandidateLocation) {
        if (normalizedCandidateLocation === normalizedTargetLocation) {
          score += 6;
        }

        if (
          normalizedCandidateLocation.includes(normalizedTargetLocation) ||
          normalizedTargetLocation.includes(normalizedCandidateLocation)
        ) {
          score += 4;
        }

        for (const keyword of keywords) {
          if (normalizedCandidateLocation.includes(keyword)) {
            score += 1;
          }
        }
      }

      return { user, score };
    })
    .filter(({ score }) => normalizedTargetLocation ? score > 0 : true)
    .sort((left, right) => right.score - left.score);

  const nearbyUsers = (
    scoredUsers.length > 0 ? scoredUsers.map(({ user }) => user) : candidates
  ).slice(0, 16);

  res.status(200).json({
    basedOnLocation: targetLocation || null,
    count: nearbyUsers.length,
    users: nearbyUsers.map((user) => sanitizeUser(user)),
  });
});
