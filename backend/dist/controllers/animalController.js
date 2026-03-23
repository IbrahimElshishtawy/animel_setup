"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.updateAdoptionRequestStatus = exports.getMyReceivedAdoptionRequests = exports.getMySentAdoptionRequests = exports.createAdoptionRequest = exports.deleteAnimal = exports.updateAnimal = exports.createAnimal = exports.getMyAnimals = exports.getAnimalById = exports.getAnimals = void 0;
const AdoptionRequest_1 = __importDefault(require("../models/AdoptionRequest"));
const Animal_1 = __importDefault(require("../models/Animal"));
const ApiError_1 = require("../utils/ApiError");
const asyncHandler_1 = require("../utils/asyncHandler");
const buildAnimalFilter = (req) => {
    const { isForAdoption, query, type, ownerId, gender, size, minPrice, maxPrice } = req.query;
    const filter = {};
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
            filter.price.$gte = Number(minPrice);
        }
        if (maxPrice) {
            filter.price.$lte = Number(maxPrice);
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
exports.getAnimals = (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const animals = await Animal_1.default.find(buildAnimalFilter(req))
        .populate('ownerId', 'name email phoneNumber location profileImageUrl')
        .sort({ createdAt: -1 });
    res.status(200).json(animals);
});
exports.getAnimalById = (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const animal = await Animal_1.default.findById(req.params.id).populate('ownerId', 'name email phoneNumber location profileImageUrl');
    if (!animal) {
        throw new ApiError_1.ApiError(404, 'Listing not found');
    }
    res.status(200).json(animal);
});
exports.getMyAnimals = (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const animals = await Animal_1.default.find({ ownerId: req.user?.id }).sort({ createdAt: -1 });
    res.status(200).json(animals);
});
exports.createAnimal = (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const animal = await Animal_1.default.create({
        ...req.body,
        ownerId: req.user?.id,
        isForAdoption: Boolean(req.body.isForAdoption),
        price: Number(req.body.price || 0),
        latitude: Number(req.body.latitude),
        longitude: Number(req.body.longitude),
    });
    const createdAnimal = await Animal_1.default.findById(animal._id).populate('ownerId', 'name email phoneNumber location profileImageUrl');
    res.status(201).json(createdAnimal);
});
exports.updateAnimal = (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const animal = await Animal_1.default.findOne({
        _id: req.params.id,
        ownerId: req.user?.id,
    });
    if (!animal) {
        throw new ApiError_1.ApiError(404, 'Listing not found or you do not have access');
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
    ];
    for (const field of fields) {
        if (req.body?.[field] !== undefined) {
            animal[field] = req.body[field];
        }
    }
    await animal.save();
    const updatedAnimal = await Animal_1.default.findById(animal._id).populate('ownerId', 'name email phoneNumber location profileImageUrl');
    res.status(200).json(updatedAnimal);
});
exports.deleteAnimal = (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const animal = await Animal_1.default.findOneAndDelete({
        _id: req.params.id,
        ownerId: req.user?.id,
    });
    if (!animal) {
        throw new ApiError_1.ApiError(404, 'Listing not found or you do not have access');
    }
    await AdoptionRequest_1.default.deleteMany({ animalId: animal._id });
    res.status(200).json({ message: 'Listing deleted successfully' });
});
exports.createAdoptionRequest = (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const animal = await Animal_1.default.findById(req.params.id);
    if (!animal || !animal.isForAdoption) {
        throw new ApiError_1.ApiError(404, 'Adoption listing not found');
    }
    if (animal.ownerId.toString() === req.user?.id) {
        throw new ApiError_1.ApiError(400, 'You cannot request adoption for your own listing');
    }
    const adoptionRequest = await AdoptionRequest_1.default.create({
        animalId: animal._id,
        requesterId: req.user?.id,
        ownerId: animal.ownerId,
        message: req.body.message,
    });
    const populated = await AdoptionRequest_1.default.findById(adoptionRequest._id)
        .populate('animalId')
        .populate('requesterId', 'name email phoneNumber')
        .populate('ownerId', 'name email phoneNumber');
    res.status(201).json(populated);
});
exports.getMySentAdoptionRequests = (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const requests = await AdoptionRequest_1.default.find({ requesterId: req.user?.id })
        .populate('animalId')
        .populate('ownerId', 'name email phoneNumber')
        .sort({ createdAt: -1 });
    res.status(200).json(requests);
});
exports.getMyReceivedAdoptionRequests = (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const requests = await AdoptionRequest_1.default.find({ ownerId: req.user?.id })
        .populate('animalId')
        .populate('requesterId', 'name email phoneNumber')
        .sort({ createdAt: -1 });
    res.status(200).json(requests);
});
exports.updateAdoptionRequestStatus = (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const request = await AdoptionRequest_1.default.findOne({
        _id: req.params.requestId,
        ownerId: req.user?.id,
    });
    if (!request) {
        throw new ApiError_1.ApiError(404, 'Adoption request not found');
    }
    request.status = req.body.status;
    await request.save();
    const populated = await AdoptionRequest_1.default.findById(request._id)
        .populate('animalId')
        .populate('requesterId', 'name email phoneNumber')
        .populate('ownerId', 'name email phoneNumber');
    res.status(200).json(populated);
});
//# sourceMappingURL=animalController.js.map