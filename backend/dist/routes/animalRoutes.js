"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const animalController_1 = require("../controllers/animalController");
const authMiddleware_1 = require("../middlewares/authMiddleware");
const validate_1 = require("../middlewares/validate");
const router = (0, express_1.Router)();
router.get('/', animalController_1.getAnimals);
router.get('/mine', authMiddleware_1.authMiddleware, animalController_1.getMyAnimals);
router.get('/adoption-requests/sent', authMiddleware_1.authMiddleware, animalController_1.getMySentAdoptionRequests);
router.get('/adoption-requests/received', authMiddleware_1.authMiddleware, animalController_1.getMyReceivedAdoptionRequests);
router.patch('/adoption-requests/:requestId', authMiddleware_1.authMiddleware, (0, validate_1.validateBody)([
    {
        field: 'status',
        required: true,
        type: 'string',
        validator: (value) => ['pending', 'approved', 'rejected'].includes(String(value)),
        message: 'Status must be pending, approved, or rejected',
    },
]), animalController_1.updateAdoptionRequestStatus);
router.get('/:id', animalController_1.getAnimalById);
router.post('/', authMiddleware_1.authMiddleware, (0, validate_1.validateBody)([
    { field: 'name', required: true, type: 'string', minLength: 2, message: 'Name is required' },
    { field: 'type', required: true, type: 'string', minLength: 2, message: 'Type is required' },
    { field: 'breed', required: true, type: 'string', minLength: 2, message: 'Breed is required' },
    { field: 'age', required: true, type: 'string', minLength: 1, message: 'Age is required' },
    { field: 'gender', required: true, type: 'string', minLength: 1, message: 'Gender is required' },
    { field: 'size', required: true, type: 'string', minLength: 1, message: 'Size is required' },
    { field: 'price', required: true, message: 'Price is required' },
    { field: 'location', required: true, type: 'string', minLength: 2, message: 'Location is required' },
    { field: 'latitude', required: true, message: 'Latitude is required' },
    { field: 'longitude', required: true, message: 'Longitude is required' },
    { field: 'description', required: true, type: 'string', minLength: 10, message: 'Description is required' },
    { field: 'imageUrls', required: true, type: 'array', message: 'At least one image URL is required' },
    { field: 'healthStatus', required: true, type: 'string', minLength: 2, message: 'Health status is required' },
]), animalController_1.createAnimal);
router.put('/:id', authMiddleware_1.authMiddleware, animalController_1.updateAnimal);
router.delete('/:id', authMiddleware_1.authMiddleware, animalController_1.deleteAnimal);
router.post('/:id/adoption-request', authMiddleware_1.authMiddleware, (0, validate_1.validateBody)([
    {
        field: 'message',
        required: true,
        type: 'string',
        minLength: 5,
        message: 'Adoption message is required',
    },
]), animalController_1.createAdoptionRequest);
exports.default = router;
//# sourceMappingURL=animalRoutes.js.map