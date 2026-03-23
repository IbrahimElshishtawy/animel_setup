"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const mongoose_1 = __importDefault(require("mongoose"));
mongoose_1.default.set('bufferCommands', false);
const tests = [
    {
        name: 'Health check',
        method: 'GET',
        path: '/health',
        expected: [200],
    },
    {
        name: 'Unknown route',
        method: 'GET',
        path: '/api/__smoke_missing__',
        expected: [404],
    },
    {
        name: 'Users register validation',
        method: 'POST',
        path: '/api/users/register',
        expected: [400],
        body: {},
    },
    {
        name: 'Users login validation',
        method: 'POST',
        path: '/api/users/login',
        expected: [400],
        body: {},
    },
    {
        name: 'Users logout auth',
        method: 'POST',
        path: '/api/users/logout',
        expected: [401],
    },
    {
        name: 'Users profile auth',
        method: 'GET',
        path: '/api/users/profile',
        expected: [401],
    },
    {
        name: 'Users update profile auth',
        method: 'PUT',
        path: '/api/users/profile',
        expected: [401],
        body: { name: 'Smoke Test' },
    },
    {
        name: 'Users search auth',
        method: 'GET',
        path: '/api/users/search?query=test',
        expected: [401],
    },
    {
        name: 'Animals list',
        method: 'GET',
        path: '/api/animals',
        expected: [200, 500],
    },
    {
        name: 'Animals details',
        method: 'GET',
        path: '/api/animals/507f1f77bcf86cd799439011',
        expected: [404, 500],
    },
    {
        name: 'Animals mine auth',
        method: 'GET',
        path: '/api/animals/mine',
        expected: [401],
    },
    {
        name: 'Animals adoption sent auth',
        method: 'GET',
        path: '/api/animals/adoption-requests/sent',
        expected: [401],
    },
    {
        name: 'Animals adoption received auth',
        method: 'GET',
        path: '/api/animals/adoption-requests/received',
        expected: [401],
    },
    {
        name: 'Animals adoption status auth',
        method: 'PATCH',
        path: '/api/animals/adoption-requests/507f1f77bcf86cd799439011',
        expected: [401],
        body: { status: 'approved' },
    },
    {
        name: 'Animals create auth',
        method: 'POST',
        path: '/api/animals',
        expected: [401],
        body: {
            name: 'Smoke Cat',
            type: 'Cat',
            breed: 'Mix',
            age: '2',
            gender: 'Female',
            size: 'Small',
            price: 100,
            location: 'Cairo',
            latitude: 30.0444,
            longitude: 31.2357,
            description: 'Healthy and friendly smoke test animal',
            imageUrls: ['https://example.com/cat.jpg'],
            healthStatus: 'Healthy',
        },
    },
    {
        name: 'Animals update auth',
        method: 'PUT',
        path: '/api/animals/507f1f77bcf86cd799439011',
        expected: [401],
        body: { name: 'Updated Smoke Animal' },
    },
    {
        name: 'Animals delete auth',
        method: 'DELETE',
        path: '/api/animals/507f1f77bcf86cd799439011',
        expected: [401],
    },
    {
        name: 'Animals adoption request auth',
        method: 'POST',
        path: '/api/animals/507f1f77bcf86cd799439011/adoption-request',
        expected: [401],
        body: { message: 'Please allow me to adopt this animal' },
    },
    {
        name: 'Shop products list',
        method: 'GET',
        path: '/api/shop/products',
        expected: [200, 500],
    },
    {
        name: 'Shop product details',
        method: 'GET',
        path: '/api/shop/products/507f1f77bcf86cd799439011',
        expected: [404, 500],
    },
    {
        name: 'Shop categories',
        method: 'GET',
        path: '/api/shop/categories',
        expected: [200, 500],
    },
    {
        name: 'Shop create product auth',
        method: 'POST',
        path: '/api/shop/products',
        expected: [401],
        body: {
            name: 'Smoke Food',
            category: 'Food',
            description: 'Dry food for smoke testing',
            imageUrl: 'https://example.com/food.jpg',
            animalType: 'Cat',
            price: 50,
        },
    },
    {
        name: 'Shop cart auth',
        method: 'GET',
        path: '/api/shop/cart',
        expected: [401],
    },
    {
        name: 'Shop add cart item auth',
        method: 'POST',
        path: '/api/shop/cart/items',
        expected: [401],
        body: {
            productId: '507f1f77bcf86cd799439011',
            quantity: 1,
        },
    },
    {
        name: 'Shop update cart item auth',
        method: 'PUT',
        path: '/api/shop/cart/items/507f1f77bcf86cd799439011',
        expected: [401],
        body: { quantity: 2 },
    },
    {
        name: 'Shop remove cart item auth',
        method: 'DELETE',
        path: '/api/shop/cart/items/507f1f77bcf86cd799439011',
        expected: [401],
    },
    {
        name: 'Chat conversations auth',
        method: 'GET',
        path: '/api/chat/conversations',
        expected: [401],
    },
    {
        name: 'Chat conversation messages auth',
        method: 'GET',
        path: '/api/chat/conversations/507f1f77bcf86cd799439011/messages',
        expected: [401],
    },
    {
        name: 'Chat direct messages auth',
        method: 'GET',
        path: '/api/chat/messages/507f1f77bcf86cd799439011',
        expected: [401],
    },
    {
        name: 'Chat send message auth',
        method: 'POST',
        path: '/api/chat/messages',
        expected: [401],
        body: {
            receiverId: '507f1f77bcf86cd799439011',
            content: 'Smoke test message',
        },
    },
    {
        name: 'Maps markers',
        method: 'GET',
        path: '/api/maps/markers',
        expected: [200, 500],
    },
];
const previewBody = (body) => {
    const normalized = body.replace(/\s+/g, ' ').trim();
    return normalized.length > 140 ? `${normalized.slice(0, 137)}...` : normalized;
};
const run = async () => {
    const app = require('../app').default;
    const server = app.listen(0);
    await new Promise((resolve) => {
        server.once('listening', () => resolve());
    });
    const address = server.address();
    if (!address || typeof address === 'string') {
        throw new Error('Could not determine smoke test server address');
    }
    const baseUrl = `http://127.0.0.1:${address.port}`;
    const results = [];
    try {
        for (const test of tests) {
            const response = await fetch(`${baseUrl}${test.path}`, {
                method: test.method,
                headers: test.body ? { 'Content-Type': 'application/json' } : undefined,
                body: test.body ? JSON.stringify(test.body) : undefined,
            });
            const text = await response.text();
            results.push({
                test,
                status: response.status,
                ok: test.expected.includes(response.status),
                bodyPreview: previewBody(text),
            });
        }
    }
    finally {
        await new Promise((resolve, reject) => {
            server.close((error) => {
                if (error) {
                    reject(error);
                    return;
                }
                resolve();
            });
        });
    }
    const failed = results.filter((result) => !result.ok);
    console.log(`Smoke test base URL: ${baseUrl}`);
    console.log('');
    for (const result of results) {
        const label = result.ok ? 'PASS' : 'FAIL';
        const expected = result.test.expected.join(' or ');
        console.log(`[${label}] ${result.test.method.padEnd(6)} ${result.test.path} -> ${result.status} (expected ${expected})`);
        if (result.bodyPreview) {
            console.log(`       ${result.bodyPreview}`);
        }
    }
    console.log('');
    console.log(`Summary: ${results.length - failed.length}/${results.length} passed`);
    if (failed.length > 0) {
        process.exitCode = 1;
    }
};
run().catch((error) => {
    console.error('Smoke test failed to run', error);
    process.exit(1);
});
//# sourceMappingURL=smokeTest.js.map