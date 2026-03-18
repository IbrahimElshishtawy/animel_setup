const ensureString = (value: string | undefined, fallback = '') => value?.trim() || fallback;

export const env = {
  nodeEnv: ensureString(process.env.NODE_ENV, 'development'),
  port: Number(process.env.PORT || 5000),
  mongoUri: ensureString(
    process.env.MONGO_URI,
    'mongodb://127.0.0.1:27017/animal-connect',
  ),
  jwtSecret: ensureString(process.env.JWT_SECRET, 'animal-connect-dev-secret'),
  jwtExpiresIn: ensureString(process.env.JWT_EXPIRES_IN, '7d'),
};
