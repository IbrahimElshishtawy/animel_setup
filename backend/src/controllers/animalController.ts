import type { Request, Response } from 'express';
import AdoptionRequest from '../models/AdoptionRequest';
import Animal from '../models/Animal';
import { ApiError } from '../utils/ApiError';
import { asyncHandler } from '../utils/asyncHandler';

const buildAnimalFilter = (req: Request) => {
  const { isForAdoption, query, type, ownerId, gender, size, minPrice, maxPrice } =
    req.query;

  const filter: Record<string, unknown> = {};

  if (isForAdoption !== undefined) {
    filter.isForAdoption = String(isForAdoption) === 'true';
  }

  if (type) {
    filter.type = String(type);
  }

  if (ownerId) {
    filter.ownerId = String(ownerId);
  }

  if (gender) {
    filter.gender = String(gender);
  }

  if (size) {
    filter.size = String(size);
  }

  if (minPrice || maxPrice) {
    filter.price = {};
    if (minPrice) {
      (filter.price as Record<string, number>).$gte = Number(minPrice);
    }
    if (maxPrice) {
      (filter.price as Record<string, number>).$lte = Number(maxPrice);
    }
  }

  if (query) {
    filter.$or = [
      { name: { $regex: String(query), $options: 'i' } },
      { breed: { $regex: String(query), $options: 'i' } },
      { type: { $regex: String(query), $options: 'i' } },
      { location: { $regex: String(query), $options: 'i' } },
    ];
  }

  return filter;
};

export const getAnimals = asyncHandler(async (req: Request, res: Response) => {
  const animals = await Animal.find(buildAnimalFilter(req))
    .populate('ownerId', 'name email phoneNumber location profileImageUrl')
    .sort({ createdAt: -1 });

  res.status(200).json(animals);
});

export const getAnimalById = asyncHandler(async (req: Request, res: Response) => {
  const animal = await Animal.findById(req.params.id).populate(
    'ownerId',
    'name email phoneNumber location profileImageUrl',
  );

  if (!animal) {
    throw new ApiError(404, 'Listing not found');
  }

  res.status(200).json(animal);
});

export const getMyAnimals = asyncHandler(async (req: Request, res: Response) => {
  const animals = await Animal.find({ ownerId: req.user?.id }).sort({ createdAt: -1 });
  res.status(200).json(animals);
});

export const createAnimal = asyncHandler(async (req: Request, res: Response) => {
  const animal = await Animal.create({
    ...req.body,
    ownerId: req.user?.id,
    isForAdoption: Boolean(req.body.isForAdoption),
    price: Number(req.body.price || 0),
    latitude: Number(req.body.latitude),
    longitude: Number(req.body.longitude),
  });

  const createdAnimal = await Animal.findById(animal._id).populate(
    'ownerId',
    'name email phoneNumber location profileImageUrl',
  );

  res.status(201).json(createdAnimal);
});

export const updateAnimal = asyncHandler(async (req: Request, res: Response) => {
  const animal = await Animal.findOne({
    _id: req.params.id,
    ownerId: req.user?.id,
  });

  if (!animal) {
    throw new ApiError(404, 'Listing not found or you do not have access');
  }

  const fields = [
    'name',
    'type',
    'breed',
    'age',
    'gender',
    'size',
    'price',
    'location',
    'latitude',
    'longitude',
    'description',
    'imageUrls',
    'isForAdoption',
    'healthStatus',
  ] as const;

  for (const field of fields) {
    if (req.body?.[field] !== undefined) {
      (animal as unknown as Record<string, unknown>)[field] = req.body[field];
    }
  }

  await animal.save();
  const updatedAnimal = await Animal.findById(animal._id).populate(
    'ownerId',
    'name email phoneNumber location profileImageUrl',
  );

  res.status(200).json(updatedAnimal);
});

export const deleteAnimal = asyncHandler(async (req: Request, res: Response) => {
  const animal = await Animal.findOneAndDelete({
    _id: req.params.id,
    ownerId: req.user?.id,
  });

  if (!animal) {
    throw new ApiError(404, 'Listing not found or you do not have access');
  }

  await AdoptionRequest.deleteMany({ animalId: animal._id });

  res.status(200).json({ message: 'Listing deleted successfully' });
});

export const createAdoptionRequest = asyncHandler(async (req: Request, res: Response) => {
  const animal = await Animal.findById(req.params.id);
  if (!animal || !animal.isForAdoption) {
    throw new ApiError(404, 'Adoption listing not found');
  }

  if (animal.ownerId.toString() === req.user?.id) {
    throw new ApiError(400, 'You cannot request adoption for your own listing');
  }

  const adoptionRequest = await AdoptionRequest.create({
    animalId: animal._id,
    requesterId: req.user?.id,
    ownerId: animal.ownerId,
    message: req.body.message,
  });

  const populated = await AdoptionRequest.findById(adoptionRequest._id)
    .populate('animalId')
    .populate('requesterId', 'name email phoneNumber')
    .populate('ownerId', 'name email phoneNumber');

  res.status(201).json(populated);
});

export const getMySentAdoptionRequests = asyncHandler(
  async (req: Request, res: Response) => {
    const requests = await AdoptionRequest.find({ requesterId: req.user?.id })
      .populate('animalId')
      .populate('ownerId', 'name email phoneNumber')
      .sort({ createdAt: -1 });

    res.status(200).json(requests);
  },
);

export const getMyReceivedAdoptionRequests = asyncHandler(
  async (req: Request, res: Response) => {
    const requests = await AdoptionRequest.find({ ownerId: req.user?.id })
      .populate('animalId')
      .populate('requesterId', 'name email phoneNumber')
      .sort({ createdAt: -1 });

    res.status(200).json(requests);
  },
);

export const updateAdoptionRequestStatus = asyncHandler(
  async (req: Request, res: Response) => {
    const request = await AdoptionRequest.findOne({
      _id: req.params.requestId,
      ownerId: req.user?.id,
    });

    if (!request) {
      throw new ApiError(404, 'Adoption request not found');
    }

    request.status = req.body.status;
    await request.save();

    const populated = await AdoptionRequest.findById(request._id)
      .populate('animalId')
      .populate('requesterId', 'name email phoneNumber')
      .populate('ownerId', 'name email phoneNumber');

    res.status(200).json(populated);
  },
);
