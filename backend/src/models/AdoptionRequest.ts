import { Document, Schema, Types, model } from 'mongoose';

export interface IAdoptionRequest extends Document {
  animalId: Types.ObjectId;
  requesterId: Types.ObjectId;
  ownerId: Types.ObjectId;
  message: string;
  status: 'pending' | 'approved' | 'rejected';
}

const adoptionRequestSchema = new Schema<IAdoptionRequest>(
  {
    animalId: { type: Schema.Types.ObjectId, ref: 'Animal', required: true },
    requesterId: { type: Schema.Types.ObjectId, ref: 'User', required: true },
    ownerId: { type: Schema.Types.ObjectId, ref: 'User', required: true },
    message: { type: String, required: true, trim: true },
    status: {
      type: String,
      enum: ['pending', 'approved', 'rejected'],
      default: 'pending',
    },
  },
  { timestamps: true },
);

adoptionRequestSchema.index(
  { animalId: 1, requesterId: 1 },
  {
    unique: true,
  },
);

const AdoptionRequest = model<IAdoptionRequest>(
  'AdoptionRequest',
  adoptionRequestSchema,
);

export default AdoptionRequest;
