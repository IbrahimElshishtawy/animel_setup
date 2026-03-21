import mongoose, { Document } from 'mongoose';
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
    ownerId: string;
    healthStatus: string;
}
declare const _default: mongoose.Model<IAnimal, {}, {}, {}, mongoose.Document<unknown, {}, IAnimal, {}, mongoose.DefaultSchemaOptions> & IAnimal & Required<{
    _id: mongoose.Types.ObjectId;
}> & {
    __v: number;
} & {
    id: string;
}, any, IAnimal>;
export default _default;
//# sourceMappingURL=Animal.d.ts.map