import mongoose, { Schema, Document } from 'mongoose';

export interface IProduct extends Document {
  name: string;
  category: string;
  price: number;
  description: string;
  imageUrl: string;
  animalType: string;
}

const ProductSchema: Schema = new Schema({
  name: { type: String, required: true },
  category: { type: String, required: true },
  price: { type: Number, required: true },
  description: { type: String, required: true },
  imageUrl: { type: String, required: true },
  animalType: { type: String, required: true },
}, { timestamps: true });

export default mongoose.model<IProduct>('Product', ProductSchema);
