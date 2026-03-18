import { Request, Response } from 'express';
import Animal from '../models/Animal';

export const getAnimals = async (req: Request, res: Response) => {
  try {
    const { isForAdoption, query } = req.query;
    const filter: any = {};
    if (isForAdoption !== undefined) {
      filter.isForAdoption = isForAdoption === 'true';
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
    const animal = new Animal(req.body);
    await animal.save();
    res.status(201).json(animal);
  } catch (error) {
    res.status(400).json({ message: 'Error creating animal', error });
  }
};
