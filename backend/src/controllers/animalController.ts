import { Request, Response } from 'express';
import Animal from '../models/Animal';

export const getAnimals = async (req: Request, res: Response) => {
  try {
    const { isForAdoption, query, type } = req.query;
    const filter: any = {};
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
    const animals = await Animal.find(filter);
    res.json(animals);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching animals', error });
  }
};

export const createAnimal = async (req: Request, res: Response) => {
  try {
    const ownerId = (req as any).user.id;
    const animal = new Animal({ ...req.body, ownerId });
    await animal.save();
    res.status(201).json(animal);
  } catch (error) {
    res.status(400).json({ message: 'Error creating animal', error });
  }
};

export const updateAnimal = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const ownerId = (req as any).user.id;
    const animal = await Animal.findOneAndUpdate({ _id: id, ownerId }, req.body, { new: true });
    if (!animal) return res.status(404).json({ message: 'Animal not found or unauthorized' });
    res.json(animal);
  } catch (error) {
    res.status(400).json({ message: 'Error updating animal', error });
  }
};

export const deleteAnimal = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;
    const ownerId = (req as any).user.id;
    const animal = await Animal.findOneAndDelete({ _id: id, ownerId });
    if (!animal) return res.status(404).json({ message: 'Animal not found or unauthorized' });
    res.json({ message: 'Animal deleted successfully' });
  } catch (error) {
    res.status(400).json({ message: 'Error deleting animal', error });
  }
};
