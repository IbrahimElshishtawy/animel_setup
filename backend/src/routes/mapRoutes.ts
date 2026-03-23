import { Router } from 'express';
import { getMapMarkers } from '../controllers/user/mapController';

const router = Router();

router.get('/markers', getMapMarkers);

export default router;
