import bcrypt from 'bcryptjs';
import { Document, Schema, model } from 'mongoose';

export interface IUser extends Document {
  name: string;
  email: string;
  password: string;
  phoneNumber: string;
  profileImageUrl?: string;
  location?: string;
  language: 'en' | 'ar';
  bio?: string;
  createdAt?: Date;
  updatedAt?: Date;
  comparePassword: (password: string) => Promise<boolean>;
}

const userSchema = new Schema<IUser>(
  {
    name: { type: String, required: true, trim: true },
    email: { type: String, required: true, unique: true, lowercase: true, trim: true },
    password: { type: String, required: true, minlength: 6 },
    phoneNumber: { type: String, required: true, trim: true },
    profileImageUrl: { type: String, trim: true },
    location: { type: String, trim: true },
    language: {
      type: String,
      enum: ['en', 'ar'],
      default: 'en',
    },
    bio: { type: String, trim: true, maxlength: 280 },
  },
  { timestamps: true },
);

userSchema.pre('save', async function saveHook() {
  if (!this.isModified('password')) {
    return;
  }

  this.password = await bcrypt.hash(this.password, 10);
});

userSchema.methods.comparePassword = function comparePassword(password: string) {
  return bcrypt.compare(password, this.password);
};

const User = model<IUser>('User', userSchema);

export default User;
