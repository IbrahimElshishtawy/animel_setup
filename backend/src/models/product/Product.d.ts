import mongoose, { Document } from 'mongoose';
export interface IProduct extends Document {
    name: string;
    category: string;
    price: number;
    description: string;
    imageUrl: string;
    animalType: string;
}
declare const _default: mongoose.Model<IProduct, {}, {}, {}, mongoose.Document<unknown, {}, IProduct, {}, mongoose.DefaultSchemaOptions> & IProduct & Required<{
    _id: mongoose.Types.ObjectId;
}> & {
    __v: number;
} & {
    id: string;
}, any, IProduct>;
export default _default;
//# sourceMappingURL=Product.d.ts.map