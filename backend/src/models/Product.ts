import { Document, Schema, model } from 'mongoose';

export interface IProduct extends Document {
  name: string;
  category: string;
  price: number;
  description: string;
  imageUrl: string;
  animalType: string;
  stock: number;
}

const productSchema = new Schema<IProduct>(
  {
    name: { type: String, required: true, trim: true },
    category: { type: String, required: true, trim: true },
    price: { type: Number, required: true, min: 0 },
    description: { type: String, required: true, trim: true },
    imageUrl: { type: String, required: true, trim: true },
    animalType: { type: String, required: true, trim: true },
    stock: { type: Number, required: true, default: 0, min: 0 },
  },
  { timestamps: true },
);

const Product = model<IProduct>('Product', productSchema);

export default Product;
