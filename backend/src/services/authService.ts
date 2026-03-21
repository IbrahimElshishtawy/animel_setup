import jwt, { type SignOptions } from 'jsonwebtoken';
import { Types } from 'mongoose';
import { env } from '../config/env';
import type { IUser } from '../models/user/User';

export const generateToken = (userId: Types.ObjectId | string) =>
  jwt.sign(
    { id: userId.toString() },
    env.jwtSecret,
    {
      expiresIn: env.jwtExpiresIn as SignOptions['expiresIn'],
    },
  );

export const sanitizeUser = (user: IUser) => ({
  _id: user._id,
  name: user.name,
  email: user.email,
  phoneNumber: user.phoneNumber,
  journey: user.journey,
  profileImageUrl: user.profileImageUrl,
  location: user.location,
  language: user.language,
  bio: user.bio,
  createdAt: user.createdAt,
  updatedAt: user.updatedAt,
});
