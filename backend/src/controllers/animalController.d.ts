import { Request, Response } from 'express';
export declare const getAnimals: (req: Request, res: Response) => Promise<void>;
export declare const createAnimal: (req: Request, res: Response) => Promise<void>;
export declare const updateAnimal: (req: Request, res: Response) => Promise<Response<any, Record<string, any>> | undefined>;
export declare const deleteAnimal: (req: Request, res: Response) => Promise<Response<any, Record<string, any>> | undefined>;
//# sourceMappingURL=animalController.d.ts.map