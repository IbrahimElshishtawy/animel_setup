import mongoose from 'mongoose';
import { env } from './env';

let isConnected = false;

export const connectDatabase = async () => {
  if (isConnected) {
    return mongoose.connection;
  }

  await mongoose.connect(env.mongoUri);
  isConnected = true;
  console.log('Connected to MongoDB');
  return mongoose.connection;
};
