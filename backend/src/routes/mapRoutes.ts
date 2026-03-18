import { Router } from 'express';
import { getMapMarkers } from '../controllers/mapController';

const router = Router();

router.get('/markers', getMapMarkers);

export default router;
