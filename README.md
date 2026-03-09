# 🐾 Find-My-Pet

A community-driven lost and found pet platform designed for efficiency, speed, and reliability.

## 🏗️ Tech Stack
- **Backend**: NestJS, PostgreSQL + PostGIS (Dockerized), Prisma ORM, Passport & JWT.
- **Frontend**: Flutter (Mobile & Web), Riverpod (State Management), GoRouter (Navigation), Dio (Networking).

## 🚀 Phase 1 Progress: Foundations & Authentication
- [x] Backend Global Standards (Exceptions, Middleware, Interceptors)
- [x] Secure JWT Authentication with Refresh Tokens
- [x] Password Hashing (bcrypt)
- [x] Geolocation-ready Database Setup (PostGIS)
- [x] Flutter App Setup & Navigation (GoRouter)
- [x] Authentication State Management (Riverpod)
- [x] Native Secure Token Storage (flutter_secure_storage)
- [x] Automatic JWT Injection (Dio Interceptors)
- [x] UI/UX Implementation matching Stitch reference designs (Mint/Teal Palette, Light Mode)

## 🛠️ Quick Start

### Backend Environment Requirements
- Docker and Docker Compose
- Node.js (v18+)

1. Start the database:
```bash
docker-compose up -d
```
2. Install dependencies & run the backend:
```bash
cd backend
npm install
npm run start:dev
```

### Frontend Environment Requirements
- Flutter SDK (v3.19+)
- Chrome (for web testing) or an Android/iOS Emulator

3. Install dependencies & run the mobile app (in a new terminal):
```bash
cd mobile
flutter pub get
flutter run -d chrome  # For web testing
```

---
*Helping pets find their way home, one community at a time.*
