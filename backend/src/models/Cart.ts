import { Document, Schema, Types, model } from 'mongoose';

interface ICartItem {
  productId: Types.ObjectId;
  quantity: number;
  priceSnapshot: number;
}

export interface ICart extends Document {
  userId: Types.ObjectId;
  items: ICartItem[];
}

const cartSchema = new Schema<ICart>(
  {
    userId: { type: Schema.Types.ObjectId, ref: 'User', required: true, unique: true },
    items: [
      {
        productId: { type: Schema.Types.ObjectId, ref: 'Product', required: true },
        quantity: { type: Number, required: true, min: 1 },
        priceSnapshot: { type: Number, required: true, min: 0 },
      },
    ],
  },
  { timestamps: true },
);

const Cart = model<ICart>('Cart', cartSchema);

export default Cart;
