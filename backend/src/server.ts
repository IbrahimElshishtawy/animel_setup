import mongoose from 'mongoose';
import app from './app';
import { env } from './config/env';
import { connectDatabase } from './config/database';

mongoose.set('strictQuery', true);

const startServer = async () => {
  await connectDatabase();

  app.listen(env.port, () => {
    console.log(`Animal Connect backend listening on port ${env.port}`);
  });
};

startServer().catch((error) => {
  console.error('Failed to start Animal Connect backend', error);
  process.exit(1);
});
