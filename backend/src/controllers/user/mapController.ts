import type { Request, Response } from 'express';
import Animal from '../../models/animal/Animal';
import { defaultPlaces } from '../../constants/defaultPlaces';
import { asyncHandler } from '../../utils/asyncHandler';

export const getMapMarkers = asyncHandler(async (req: Request, res: Response) => {
  const { isForAdoption, query } = req.query;
  const filter: Record<string, unknown> = {};

  if (isForAdoption !== undefined) {
    filter.isForAdoption = String(isForAdoption) === 'true';
  }

  if (query) {
    filter.$or = [
      { name: { $regex: String(query), $options: 'i' } },
      { breed: { $regex: String(query), $options: 'i' } },
      { location: { $regex: String(query), $options: 'i' } },
    ];
  }

  const animals = await Animal.find(filter)
    .populate('ownerId', 'name phoneNumber')
    .sort({ createdAt: -1 })
    .limit(100);

  const animalMarkers = animals.map((animal) => ({
    id: animal._id,
    title: animal.name,
    subtitle: animal.location,
    latitude: animal.latitude,
    longitude: animal.longitude,
    type: animal.isForAdoption ? 'adoption' : 'listing',
    referenceId: animal._id,
  }));

  const placeMarkers = defaultPlaces.map((place) => ({
    id: place.id,
    title: place.name,
    subtitle: `${place.category} - ${place.address}`,
    latitude: place.latitude,
    longitude: place.longitude,
    type: 'place',
    category: place.category,
    referenceId: place.id,
  }));

  res.status(200).json({
    markers: [...animalMarkers, ...placeMarkers],
  });
});
