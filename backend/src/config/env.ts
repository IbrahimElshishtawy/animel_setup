import dotenv from 'dotenv';

dotenv.config();

const ensureString = (value: string | undefined, fallback = '') => value?.trim() || fallback;

const defaultMongoUri = 'mongodb://127.0.0.1:27017/animal-connect';
const configuredMongoUri = ensureString(process.env.MONGO_URI);

export const env = {
  nodeEnv: ensureString(process.env.NODE_ENV, 'development'),
  host: ensureString(process.env.HOST, '0.0.0.0'),
  port: Number(process.env.PORT || 5000),
  mongoUri: configuredMongoUri || defaultMongoUri,
  isDefaultMongoUri: !configuredMongoUri,
  jwtSecret: ensureString(process.env.JWT_SECRET, 'animal-connect-dev-secret'),
  jwtExpiresIn: ensureString(process.env.JWT_EXPIRES_IN, '7d'),
};
