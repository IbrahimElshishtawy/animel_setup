# Animal Connect - Technical Documentation

## 1. Backend API Endpoints (Base URL: `/api`)

### Auth Module (`/users`)
- `POST /register`: Register a new user.
- `POST /login`: Login and receive a JWT.
- `GET /profile`: Get the current authenticated user's profile (Protected).
- `PUT /profile`: Update the current user's profile (Protected).

### Marketplace & Adoption Module (`/animals`)
- `GET /`: Fetch list of animals. Supports query params: `isForAdoption` (bool), `query` (search term), `type` (animal type).
- `POST /`: Create a new animal listing or adoption post (Protected).
- `PUT /:id`: Update an existing animal listing (Protected, Owner only).
- `DELETE /:id`: Delete an animal listing (Protected, Owner only).

### Shop Module (`/shop`)
- `GET /products`: Fetch product catalog. Supports `category` and `query` search.
- `POST /products`: Create a new product (Protected).

### Chat Module (`/chat`)
- `GET /messages/:otherUserId`: Retrieve message history between current user and another (Protected).
- `POST /messages`: Send a new message (Protected).

---

## 2. Database Schemas (Mongoose)

### User
- `name`: String, required
- `email`: String, required, unique
- `password`: String, required (hashed)
- `phoneNumber`: String, required
- `profileImageUrl`: String
- `location`: String

### Animal
- `name`: String, required
- `type`: String, required
- `breed`: String, required
- `age`: String, required
- `gender`: String, required
- `size`: String, required
- `price`: Number, required
- `location`: String, required
- `latitude`: Number, required
- `longitude`: Number, required
- `description`: String, required
- `imageUrls`: [String], required
- `isForAdoption`: Boolean, required
- `ownerId`: ObjectId, ref: 'User', required
- `healthStatus`: String, required

### Product
- `name`: String, required
- `category`: String, required
- `price`: Number, required
- `description`: String, required
- `imageUrl`: String, required
- `animalType`: String, required

### Message
- `senderId`: ObjectId, ref: 'User', required
- `receiverId`: ObjectId, ref: 'User', required
- `content`: String, required
- `timestamp`: Date, default: now

---

## 3. CRUD Support
- **Full CRUD** is supported for **Animals** (Sale/Adoption).
- **Read and Create** are supported for **Users**, **Products**, and **Messages**.
- **Update** is supported for **User Profiles** and **Animals** (by owner).

---

## 4. Auth & Authorization
- **JWT**: Enforced via `authMiddleware.ts` using Bearer tokens in the `Authorization` header.
- **Session Persistence**: JWT is stored securely on the device using `flutter_secure_storage`.
- **Ownership Verification**: Protected routes (like Update/Delete Animal) verify that the `ownerId` of the entity matches the authenticated user's ID.

---

## 5. Validation & Error Handling
- **Backend**: Request validation is handled within controllers; errors return clear JSON messages with appropriate HTTP status codes (400, 401, 404, 500).
- **Frontend**: Repository layer handles API exceptions; BLoCs emit specific `Error` states which are displayed via `ErrorStateWidget`.

---

## 6. Chat Implementation
- **Current State**: Request-based. Uses standard REST GET/POST for retrieving and sending messages.
- **Scalability**: The structure is "real-time ready," meaning Socket.io can be easily integrated into the existing `ChatBloc` and backend `chatController`.

---

## 7. Limitations & Edge Cases
- **Assets**: Currently uses a local mock asset (`assets/image/image.png`). A real production environment would integrate an AWS S3 or Firebase Storage service for image uploads.
- **Maps**: Requires a valid Google Maps API Key in `AndroidManifest.xml` to function on devices.
- **Cart**: Shop implementation currently includes UI and product fetching; full cart/checkout state (persistent across sessions) would be the next step.
- **Search**: Search is currently text-based (RegEx on backend); a production app might use an indexed search engine like ElasticSearch for better performance.
