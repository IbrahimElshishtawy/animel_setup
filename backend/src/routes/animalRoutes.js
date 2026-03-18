"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const animalController_1 = require("../controllers/animalController");
const authMiddleware_1 = require("../middlewares/authMiddleware");
const router = (0, express_1.Router)();
router.get('/', animalController_1.getAnimals);
router.post('/', authMiddleware_1.authMiddleware, animalController_1.createAnimal);
router.put('/:id', authMiddleware_1.authMiddleware, animalController_1.updateAnimal);
router.delete('/:id', authMiddleware_1.authMiddleware, animalController_1.deleteAnimal);
exports.default = router;
//# sourceMappingURL=animalRoutes.js.map