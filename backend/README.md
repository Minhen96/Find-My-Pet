# 🐾 Find-My-Pet Backend

This is the NestJS backend for the **Find-My-Pet** platform—a community-driven initiative to help lost pets find their way home.

## 🚀 Core Features (Implemented)

### 1. Robust Authentication
- **JWT + Passport**: Industry-standard secure login.
- **Refresh Token Pattern**: Support for long-lived sessions with server-side revocation (hashing tokens in DB).
- **Auto-Login**: Automatic JWT generation upon successful registration.

### 2. Advanced Security
- **Bcrypt Hashing**: All passwords and refresh tokens are salted and hashed.
- **Rate Limiting (Brute Force Protection)**: 
  - Global limit: 60 requests/min.
  - Auth limits: **5 attempts/min** for Login and Register.
  - *Future scalability*: Redis-ready configuration included (commented in `AppModule`).
- **Data Privacy**: Automatic stripping of sensitive fields (`passwordHash`, `hashedRefreshToken`) from all API responses.

### 3. Database Layer
- **PostgreSQL + PostGIS**: Geolocation-ready database for future pet mapping features.
- **TypeORM**: Modern ORM with asynchronous configuration and global environment validation.

## 🛠️ Getting Started

### 1. Prerequisites
- Docker & Docker Compose
- Node.js (v18+)

### 2. Setup Environment
Copy the `.env.example` (if available) to `.env` in the project root and fill in the secrets.

### 3. Start Database
```bash
docker-compose up -d
```

### 4. Run Backend
```bash
cd backend
npm install
npm run start:dev
```

The API will be available at `http://localhost:3000/api`.
Swagger docs: `http://localhost:3000/docs`.

## 📈 Scalability Note
To scale this backend to multiple instances, swap the `ThrottlerModule` storage to **Redis** as documented in `src/app.module.ts`. This ensures rate limits are synchronized across all server nodes.
