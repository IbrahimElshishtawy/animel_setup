import type { NextFunction, Request, Response } from 'express';
import { ApiError } from '../utils/ApiError';

export const errorHandler = (
  error: Error,
  _req: Request,
  res: Response,
  _next: NextFunction,
) => {
  const statusCode = error instanceof ApiError ? error.statusCode : 500;

  res.status(statusCode).json({
    message:
      statusCode === 500 ? 'Something went wrong on the server' : error.message,
  });
};
