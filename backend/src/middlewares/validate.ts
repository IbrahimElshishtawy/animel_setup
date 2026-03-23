import type { NextFunction, Request, Response } from 'express';
import { ApiError } from '../utils/ApiError';

type Rule = {
  field: string;
  required?: boolean;
  type?: 'string' | 'number' | 'boolean' | 'array';
  minLength?: number;
  validator?: (value: unknown, req: Request) => boolean;
  message: string;
};

export const validateBody =
  (rules: Rule[]) => (req: Request, _res: Response, next: NextFunction) => {
    for (const rule of rules) {
      const value = req.body?.[rule.field];

      if (rule.required && (value === undefined || value === null || value === '')) {
        return next(new ApiError(400, rule.message));
      }

      if (value === undefined || value === null) {
        continue;
      }

      if (rule.type === 'string' && typeof value !== 'string') {
        return next(new ApiError(400, rule.message));
      }

      if (rule.type === 'number' && typeof value !== 'number') {
        return next(new ApiError(400, rule.message));
      }

      if (rule.type === 'boolean' && typeof value !== 'boolean') {
        return next(new ApiError(400, rule.message));
      }

      if (rule.type === 'array' && !Array.isArray(value)) {
        return next(new ApiError(400, rule.message));
      }

      if (
        rule.type === 'string' &&
        rule.minLength &&
        typeof value === 'string' &&
        value.trim().length < rule.minLength
      ) {
        return next(new ApiError(400, rule.message));
      }

      if (rule.validator && !rule.validator(value, req)) {
        return next(new ApiError(400, rule.message));
      }
    }

    next();
  };
