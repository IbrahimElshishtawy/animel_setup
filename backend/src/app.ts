import cors from 'cors';
import path from 'path';
import dotenv from 'dotenv';
import express from 'express';
import animalRoutes from './routes/animalRoutes';
import chatRoutes from './routes/chatRoutes';
import mapRoutes from './routes/mapRoutes';
import shopRoutes from './routes/shopRoutes';
import userRoutes from './routes/userRoutes';
import { errorHandler } from './middlewares/errorMiddleware';
import { notFoundHandler } from './middlewares/notFoundMiddleware';

dotenv.config({ path: path.resolve(__dirname, '../.env') });

const app = express();

app.use(
  cors({
    origin: '*',
    credentials: true,
  }),
);
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));

app.get('/health', (_req, res) => {
  res.status(200).json({
    status: 'ok',
    service: 'animal-connect-backend',
    timestamp: new Date().toISOString(),
  });
});

app.use('/api/users', userRoutes);
app.use('/api/animals', animalRoutes);
app.use('/api/shop', shopRoutes);
app.use('/api/chat', chatRoutes);
app.use('/api/maps', mapRoutes);

app.use(notFoundHandler);
app.use(errorHandler);

export default app;
