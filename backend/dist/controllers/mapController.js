"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getMapMarkers = void 0;
const Animal_1 = __importDefault(require("../models/Animal"));
const defaultPlaces_1 = require("../constants/defaultPlaces");
const asyncHandler_1 = require("../utils/asyncHandler");
exports.getMapMarkers = (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const { isForAdoption, query } = req.query;
    const filter = {};
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
    const animals = await Animal_1.default.find(filter)
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
    const placeMarkers = defaultPlaces_1.defaultPlaces.map((place) => ({
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
//# sourceMappingURL=mapController.js.map