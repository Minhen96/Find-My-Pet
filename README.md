# 🐾 Find-My-Pet

A high-performance, community-driven lost and found pet platform designed for efficiency, speed, and reliability.

## 🏗️ Tech Stack
- **Backend**: NestJS, PostgreSQL + PostGIS, **TypeORM**, **Redis**, **BullMQ**, **Socket.io**.
- **Frontend**: Flutter (Mobile & Web), Riverpod (State Management), GoRouter (Navigation), Dio (Networking), `socket_io_client`.
- **Infrastructure**: Dockerized (PostgreSQL, PostGIS, Redis).

## ✅ Phase 1: Foundations & Authentication
- [x] Secure JWT Authentication with Refresh Tokens
- [x] Geolocation-ready Database Setup (PostGIS)
- [x] UI/UX matching Stitch reference designs (Mint/Teal Palette)

## ✅ Phase 2: Community & High-Performance Interactions
- [x] **Expanded Community**: Support for "Social Moments" alongside Lost & Found posts.
- [x] **Precision Location**: Interactive Map Picker (OpenStreetMap) for exact coordinates.
- [x] **Media Uploads**: Multi-photo support with R2 storage integration.
- [x] **Redis Caching**: Sub-millisecond social interaction (Like/Comment) responses.
- [x] **BullMQ Background Jobs**: Reliable, asynchronous database synchronization.
- [x] **Real-Time WebSockets**: Instant Like/Comment updates across all connected devices.
- [x] **Robust Networking**: Global Dio Interceptor safely extracting NestJS `{data: ...}` payloads across all routes.
- [x] **Secure Storage Resilience**: Defensive parsing added to `flutter_secure_storage` to handle corrupted Web cache keys without crashing (`TypeError: Null`).

## 🛠️ Quick Start

### Backend Environment Requirements
- Docker Desktop
- Node.js (v18+)

1. Start the core services (PostGis + Redis):
```bash
docker compose up -d
```
2. Install dependencies & run the backend:
```bash
cd backend
npm install
npm run start:dev
```

### Frontend Environment Requirements
- Flutter SDK (v3.19+)

3. Install dependencies & run the mobile app:
```bash
cd mobile
flutter pub get
flutter run -d chrome  # For web testing
```

### 🧹 Resetting the Database
If you ever need to completely wipe your local database during testing, run:
```bash
docker compose down -v
docker compose up -d
```
*Note: Do not rely on TypeORM `synchronize: true` or `dropSchema: true` in `datasource.config.ts` unless necessary, as it can cause unexpected schema destruction.*

---
*Building the world's most responsive community for our furry friends.*
