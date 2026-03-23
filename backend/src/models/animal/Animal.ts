import { Document, Schema, Types, model } from 'mongoose';

export interface IAnimal extends Document {
  name: string;
  type: string;
  breed: string;
  age: string;
  gender: string;
  size: string;
  price: number;
  location: string;
  latitude: number;
  longitude: number;
  description: string;
  imageUrls: string[];
  isForAdoption: boolean;
  ownerId: Types.ObjectId;
  healthStatus: string;
}

const animalSchema = new Schema<IAnimal>(
  {
    name: { type: String, required: true, trim: true },
    type: { type: String, required: true, trim: true },
    breed: { type: String, required: true, trim: true },
    age: { type: String, required: true, trim: true },
    gender: { type: String, required: true, trim: true },
    size: { type: String, required: true, trim: true },
    price: { type: Number, required: true, min: 0 },
    location: { type: String, required: true, trim: true },
    latitude: { type: Number, required: true },
    longitude: { type: Number, required: true },
    description: { type: String, required: true, trim: true },
    imageUrls: { type: [String], required: true, default: [] },
    isForAdoption: { type: Boolean, required: true, default: false },
    ownerId: { type: Schema.Types.ObjectId, ref: 'User', required: true },
    healthStatus: { type: String, required: true, trim: true },
  },
  { timestamps: true },
);

const Animal = model<IAnimal>('Animal', animalSchema);

export default Animal;
