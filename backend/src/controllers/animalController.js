"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.deleteAnimal = exports.updateAnimal = exports.createAnimal = exports.getAnimals = void 0;
const express_1 = require("express");
const Animal_1 = __importDefault(require("../models/Animal"));
const getAnimals = async (req, res) => {
    try {
        const { isForAdoption, query, type } = req.query;
        const filter = {};
        if (isForAdoption !== undefined) {
            filter.isForAdoption = isForAdoption === 'true';
        }
        if (type) {
            filter.type = type;
        }
        if (query) {
            filter.$or = [
                { name: { $regex: query, $options: 'i' } },
                { breed: { $regex: query, $options: 'i' } },
                { type: { $regex: query, $options: 'i' } },
            ];
        }
        const animals = await Animal_1.default.find(filter);
        res.json(animals);
    }
    catch (error) {
        res.status(500).json({ message: 'Error fetching animals', error });
    }
};
exports.getAnimals = getAnimals;
const createAnimal = async (req, res) => {
    try {
        const ownerId = req.user.id;
        const animal = new Animal_1.default({ ...req.body, ownerId });
        await animal.save();
        res.status(201).json(animal);
    }
    catch (error) {
        res.status(400).json({ message: 'Error creating animal', error });
    }
};
exports.createAnimal = createAnimal;
const updateAnimal = async (req, res) => {
    try {
        const { id } = req.params;
        const ownerId = req.user.id;
        const animal = await Animal_1.default.findOneAndUpdate({ _id: id, ownerId }, req.body, { new: true });
        if (!animal)
            return res.status(404).json({ message: 'Animal not found or unauthorized' });
        res.json(animal);
    }
    catch (error) {
        res.status(400).json({ message: 'Error updating animal', error });
    }
};
exports.updateAnimal = updateAnimal;
const deleteAnimal = async (req, res) => {
    try {
        const { id } = req.params;
        const ownerId = req.user.id;
        const animal = await Animal_1.default.findOneAndDelete({ _id: id, ownerId });
        if (!animal)
            return res.status(404).json({ message: 'Animal not found or unauthorized' });
        res.json({ message: 'Animal deleted successfully' });
    }
    catch (error) {
        res.status(400).json({ message: 'Error deleting animal', error });
    }
};
exports.deleteAnimal = deleteAnimal;
//# sourceMappingURL=animalController.js.map