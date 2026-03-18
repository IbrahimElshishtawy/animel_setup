import mongoose, { Schema, Document } from 'mongoose';

export interface IAnimal extends Document {
  name: string;
  type: string;
  breed: string;
  age: string;
  gender: string;
  size: string;
  price: number;
  location: string;
  description: string;
  imageUrls: string[];
  isForAdoption: boolean;
  ownerId: string;
  healthStatus: string;
}

const AnimalSchema: Schema = new Schema({
  name: { type: String, required: true },
  type: { type: String, required: true },
  breed: { type: String, required: true },
  age: { type: String, required: true },
  gender: { type: String, required: true },
  size: { type: String, required: true },
  price: { type: Number, required: true },
  location: { type: String, required: true },
  description: { type: String, required: true },
  imageUrls: { type: [String], required: true },
  isForAdoption: { type: Boolean, required: true },
  ownerId: { type: String, required: true },
  healthStatus: { type: String, required: true },
}, { timestamps: true });

export default mongoose.model<IAnimal>('Animal', AnimalSchema);
