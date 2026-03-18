import type { NextFunction, Request, Response } from 'express';
import jwt from 'jsonwebtoken';
import { env } from '../config/env';
import { ApiError } from '../utils/ApiError';

type JwtPayload = {
  id: string;
};

export const authMiddleware = (
  req: Request,
  _res: Response,
  next: NextFunction,
) => {
  const token = req.header('Authorization')?.replace('Bearer ', '').trim();

  if (!token) {
    next(new ApiError(401, 'Authentication token is required'));
    return;
  }

  try {
    const decoded = jwt.verify(token, env.jwtSecret) as JwtPayload;
    req.user = { id: decoded.id };
    next();
  } catch (_error) {
    next(new ApiError(401, 'Authentication token is invalid or expired'));
  }
};
