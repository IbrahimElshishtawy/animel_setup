import mongoose from 'mongoose';
import { env } from './env';

let isConnected = false;

export const connectDatabase = async () => {
  if (isConnected) {
    return mongoose.connection;
  }

  try {
    await mongoose.connect(env.mongoUri);
    isConnected = true;
    console.log('Connected to MongoDB');
    return mongoose.connection;
  } catch (error) {
    const originalError =
      error instanceof Error ? `${error.name}: ${error.message}` : String(error);
    const setupHint = env.isDefaultMongoUri
      ? 'No MONGO_URI was found, so the app tried the default local MongoDB instance. Start MongoDB on port 27017 or create a .env file based on .env.example with a reachable MONGO_URI.'
      : 'The configured MONGO_URI could not be reached. Verify the value in your .env file and make sure that MongoDB is running and accessible from this machine.';

    throw new Error(
      [
        `MongoDB connection failed for URI: ${env.mongoUri}`,
        setupHint,
        `Original error: ${originalError}`,
      ].join('\n'),
    );
  }
};
