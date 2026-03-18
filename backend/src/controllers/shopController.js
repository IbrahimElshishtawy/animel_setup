"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.createProduct = exports.getProducts = void 0;
const express_1 = require("express");
const Product_1 = __importDefault(require("../models/Product"));
const getProducts = async (req, res) => {
    try {
        const { category, query } = req.query;
        const filter = {};
        if (category && category !== 'All') {
            filter.category = category;
        }
        if (query) {
            filter.name = { $regex: query, $options: 'i' };
        }
        const products = await Product_1.default.find(filter);
        res.json(products);
    }
    catch (error) {
        res.status(500).json({ message: 'Error fetching products', error });
    }
};
exports.getProducts = getProducts;
const createProduct = async (req, res) => {
    try {
        const product = new Product_1.default(req.body);
        await product.save();
        res.status(201).json(product);
    }
    catch (error) {
        res.status(400).json({ message: 'Error creating product', error });
    }
};
exports.createProduct = createProduct;
//# sourceMappingURL=shopController.js.map