import { Document, Schema, Types, model } from 'mongoose';

export interface IConversation extends Document {
  participantIds: Types.ObjectId[];
  lastMessage?: string;
  lastMessageAt?: Date;
}

const conversationSchema = new Schema<IConversation>(
  {
    participantIds: [
      {
        type: Schema.Types.ObjectId,
        ref: 'User',
        required: true,
      },
    ],
    lastMessage: { type: String, trim: true },
    lastMessageAt: { type: Date },
  },
  { timestamps: true },
);

conversationSchema.index({ participantIds: 1 });

const Conversation = model<IConversation>('Conversation', conversationSchema);

export default Conversation;
