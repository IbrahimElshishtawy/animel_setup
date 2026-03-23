"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getNearbyUsers = exports.searchUsers = exports.updateProfile = exports.getProfile = exports.logout = exports.login = exports.register = void 0;
const User_1 = __importDefault(require("../../models/user/User"));
const authService_1 = require("../../services/authService");
const ApiError_1 = require("../../utils/ApiError");
const asyncHandler_1 = require("../../utils/asyncHandler");
const normalizeLocation = (value) => value
    .toLowerCase()
    .replace(/[^\p{L}\p{N}\s,]/gu, ' ')
    .replace(/\s+/g, ' ')
    .trim();
const locationKeywords = (value) => {
    const tokens = normalizeLocation(value)
        .split(/[\s,]+/)
        .map((token) => token.trim())
        .filter((token) => token.length >= 3);
    return Array.from(new Set(tokens)).slice(0, 6);
};
exports.register = (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const { name, email, password, phoneNumber, journey, language, location, bio, profileImageUrl, } = req.body;
    const existingUser = await User_1.default.findOne({ email: String(email).toLowerCase() });
    if (existingUser) {
        throw new ApiError_1.ApiError(409, 'An account already exists for this email');
    }
    const user = await User_1.default.create({
        name,
        email,
        password,
        phoneNumber,
        journey,
        language: language || 'en',
        location,
        bio,
        profileImageUrl,
    });
    res.status(201).json({
        user: (0, authService_1.sanitizeUser)(user),
        token: (0, authService_1.generateToken)(user._id),
    });
});
exports.login = (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const { email, password } = req.body;
    const user = await User_1.default.findOne({ email: String(email).toLowerCase() });
    if (!user || !(await user.comparePassword(String(password)))) {
        throw new ApiError_1.ApiError(401, 'Invalid email or password');
    }
    res.status(200).json({
        user: (0, authService_1.sanitizeUser)(user),
        token: (0, authService_1.generateToken)(user._id),
    });
});
exports.logout = (0, asyncHandler_1.asyncHandler)(async (_req, res) => {
    res.status(200).json({ message: 'Logged out successfully' });
});
exports.getProfile = (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const user = await User_1.default.findById(req.user?.id);
    if (!user) {
        throw new ApiError_1.ApiError(404, 'User not found');
    }
    res.status(200).json((0, authService_1.sanitizeUser)(user));
});
exports.updateProfile = (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const user = await User_1.default.findById(req.user?.id);
    if (!user) {
        throw new ApiError_1.ApiError(404, 'User not found');
    }
    const updatableFields = [
        'name',
        'phoneNumber',
        'journey',
        'profileImageUrl',
        'location',
        'language',
        'bio',
    ];
    for (const field of updatableFields) {
        const nextValue = req.body?.[field];
        if (nextValue !== undefined) {
            user[field] = nextValue;
        }
    }
    if (req.body?.password) {
        user.password = req.body.password;
    }
    await user.save();
    res.status(200).json((0, authService_1.sanitizeUser)(user));
});
exports.searchUsers = (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const query = String(req.query.query || '').trim();
    const filter = query
        ? {
            $or: [
                { name: { $regex: query, $options: 'i' } },
                { email: { $regex: query, $options: 'i' } },
            ],
        }
        : {};
    const users = await User_1.default.find(filter).sort({ createdAt: -1 }).limit(20);
    res.status(200).json(users.map((user) => (0, authService_1.sanitizeUser)(user)));
});
exports.getNearbyUsers = (0, asyncHandler_1.asyncHandler)(async (req, res) => {
    const currentUser = await User_1.default.findById(req.user?.id);
    if (!currentUser) {
        throw new ApiError_1.ApiError(404, 'User not found');
    }
    const requestedJourney = String(req.query.journey || '').trim();
    const journey = requestedJourney === 'pet_owner' ||
        requestedJourney === 'buyer' ||
        requestedJourney === 'adopter'
        ? requestedJourney
        : undefined;
    const targetLocation = String(currentUser.location || '').trim();
    const normalizedTargetLocation = normalizeLocation(targetLocation);
    const keywords = locationKeywords(targetLocation);
    const candidates = await User_1.default.find({
        _id: { $ne: currentUser._id },
        location: { $exists: true, $ne: '' },
        ...(journey ? { journey } : {}),
    })
        .sort({ createdAt: -1 })
        .limit(normalizedTargetLocation ? 40 : 16);
    const scoredUsers = candidates
        .map((user) => {
        const normalizedCandidateLocation = normalizeLocation(user.location || '');
        let score = 0;
        if (normalizedTargetLocation && normalizedCandidateLocation) {
            if (normalizedCandidateLocation === normalizedTargetLocation) {
                score += 6;
            }
            if (normalizedCandidateLocation.includes(normalizedTargetLocation) ||
                normalizedTargetLocation.includes(normalizedCandidateLocation)) {
                score += 4;
            }
            for (const keyword of keywords) {
                if (normalizedCandidateLocation.includes(keyword)) {
                    score += 1;
                }
            }
        }
        return { user, score };
    })
        .filter(({ score }) => normalizedTargetLocation ? score > 0 : true)
        .sort((left, right) => right.score - left.score);
    const nearbyUsers = (scoredUsers.length > 0 ? scoredUsers.map(({ user }) => user) : candidates).slice(0, 16);
    res.status(200).json({
        basedOnLocation: targetLocation || null,
        count: nearbyUsers.length,
        users: nearbyUsers.map((user) => (0, authService_1.sanitizeUser)(user)),
    });
});
//# sourceMappingURL=userController.js.map