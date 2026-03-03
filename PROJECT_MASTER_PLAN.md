# 🐾 PROJECT MASTER PLAN: Find-My-Pet Platform
*Community Lost & Found Pet Platform (Malaysia context)*

## 🎯 Mission
Help local communities find missing pets faster using:
- **Structured search tools**: Digital maps and search coordination.
- **Real-time alerts**: Instant notifications for nearby sightings.
- **Community volunteers**: Mobilizing local helpers.
- **Vet & council integration**: Official partnership ecosystem.
- **AI assistance**: Vision-based pet matching and movement prediction.

---

## 🏗 SYSTEM ARCHITECTURE (Startup-Grade)

The platform is designed for scalability and performance, following modern startup standards:

- **Mobile Application**: **Flutter** (Android/iOS).
- **Backend Infrastructure**: **NestJS** (Node.js + TypeScript).
- **Database**: **PostgreSQL** + **PostGIS** (Geo-spatial queries).
- **Map Provider**: **OpenStreetMap (OSM)** with custom tile caching (Cost-effective).
- **Real-time**: **WebSockets** (Socket.io).
- **Storage**: **Cloudflare R2** (S3-compatible, no egress fees).
- **Push**: **Firebase Cloud Messaging (FCM)** (Free).
- **AI Service**: **Self-hosted Python FastAPI** (Cost efficient at scale).
- **Authentication**: **Firebase Auth** (Subsidized SMS/Email OTP).

---

## 💰 COST & SUSTAINABILITY STRATEGY

To ensure the platform remains free and sustainable for the community, we prioritize a "Low-Burn" stack:
- **Map Strategy**: Use OSM to avoid Google Maps' high per-load costs.
- **AI Strategy**: Transition from Cloud APIs to self-hosted models early to eliminate per-call billing.
- **Storage Strategy**: Utilize Cloudflare R2 to eliminate egress costs for high-volume photos.
- **Hosting Strategy**: Start with a high-performance VPS before moving to managed cloud services.

---

---

## �️ DATA ARCHITECTURE (Conceptual Schema)

### 1. User & Role Management
- **Users**: Unique ID, Email/Phone, Hash, Role (Owner, Volunteer, Vet, Admin), display name, avatar, verification status.
- **Privacy**: Settings for location sharing, profile visibility, and anonymous chat toggles.

### 2. Pet & Post System
- **Pets**: breed, color, size, unique markings, photos_urls, owner_id.
- **Posts**: type (Lost/Found), timestamp, last_seen_location (Point/Geometry), urgency_level, reward_amount, is_active.

### 3. Search & Location Intelligence
- **Sighting Events**: location (Point), timestamp, confidence level, photon_url, notes.
- **Search Sessions**: user_id, route_path (LineString), start/end time, distance covered, zones covered.
- **Zone Definitions**: polygon_geometry, label (A1, A2...), assigned_user_id, completion_status.

---

## 🛠 DETAILED MODULE BREAKDOWN

### 1️⃣ USER & ROLE SYSTEM
- **Multi-Role Support**: Different UI dashboards for Pet Owners vs. Vet Clinics vs. Volunteers.
- **Verification Logic**: Badge system for vets and shelters to build community trust.
- **Malaysia-first Auth**: WhatsApp/SMS OTP integration for phone-based login.

### 2️⃣ LOST & FOUND PET SYSTEM
- **Smart Entry**: Dropdowns for common Malaysian pet breeds and sizes.
- **Rich Media**: Multi-photo uploads with automatic compression and storage tagging.
- **Urgency Levels**: High/Low priority tags that determine notification radius.

### 3️⃣ MAP & LOCATION INTELLIGENCE
- **Interactive Layers**: Toggle between "Lost", "Found", and "Recently Seen" pins.
- **Search Path Recording**: Start Search → Record GPS → Draw Path on Map → Save Session.
- **Offline Search Mode**: Map caching and low connectivity support for searching in weak signal areas.
- **Background Location Logic**: Battery-optimized background tracking with auto-stop conditions.
- **Coverage Heatmap**: Visual feedback showing which areas have been searched vs. missed.

### 4️⃣ SEARCH COORDINATION SYSTEM
- **Private Search Groups**: Invite-only rooms where members share a live map and chat.
- **Zone Planner**: Admins can draw grid squares on the map and assign members to specific blocks.
- **Advanced Search Analytics**: Search effectiveness dashboard and AI-based optimization for suggested next zones.
- **Live Sync**: WebSockets ensure that if one person marks a zone "Done", everyone sees it instantly.

### 5️⃣ ALERT & NOTIFICATION SYSTEM
- **Radius-Based Alerts**: Auto-trigger push notifications to users within 2km-5km of a new post.
- **Emergency Activation**: Push highest-priority alerts to all local users.

### 6️⃣ RECENTLY SEEN SYSTEM
- **Smart Sightings**: Similarity checks to avoid duplicate reports.
- **Duplicate Detection System**: Automated detection of same sightings or alert spam.
- **Reward Escrow System**: Secure reward verification workflow (Future Phase).

### 7️⃣ VET & COUNCIL INTEGRATION
- **Vet Directory**: Searchable list of nearby clinics with contact integration.
- **Vet Dashboard**: Secure login for vets to scan microchips (manual ID entry) and mark pets as "Safe at Clinic".

### 8️⃣ CHAT SYSTEM (Owner ↔ Finder)
- **Security**: Chat without revealing personal phone numbers.
- **Attachments**: Share live locations or additional photos within the chat.

### 9️⃣ VOLUNTEER NETWORK
- **Ready-to-Help**: A toggle that puts volunteers on the map for owners to recruit.
- **Gamification**: Community contribution points and rankings.

### 🔟 AI FEATURES
- **Image Comparison**: AI calculates similarity between "Lost" pet photos and "Found" pet photos.
- **Risk Analysis**: Predict likely movement patterns based on local terrain and time elapsed.

### 1️⃣1️⃣ AUTO POSTER GENERATOR
- **PDF Export**: Generate high-res A4 poster with pet details or QR code.
- **QR Code Deep Linking System**:
  - Direct link to pet profile page in-app.
  - **Universal Deep Linking**: Web fallback version for non-app users.
  - Dynamic QR for growth and tracking.

### 1️⃣2️⃣ SOCIAL MEDIA AUTO-POSTING (Direct API)
- **Direct Integration**: Auto-post via official APIs (Facebook, Xiaohongshu, etc.) for broader reach.
- **Automatic Formatting**: Tailored text and image layout per platform.
- **One-Click Blast**: Boost post visibility across all platforms instantly.

---

## �️ SAFETY & PROTECTION
### 1️⃣3️⃣ ABUSE PREVENTION SYSTEM
- **Rate Limiting & Spam Detection**: Prevent fake reports and flood alerts.
- **Moderation**: Image auto-moderation and fake location prevention logic.
- **Trust Scoring**: Reliable community members gain higher trust status for faster alert triggering.

### 1️⃣4️⃣ MULTI-LANGUAGE SUPPORT (Malaysia Context)
- **Local Adoption**: Support for English, Bahasa Malaysia, and Chinese.
- **Language Switcher**: Easy in-app toggle for all UI elements and post metadata.

---

## �🗺 DEVELOPMENT ROADMAP

### Phase 1: Core MVP (Foundations)
- [ ] Backend Initial Setup (NestJS + PostgreSQL + PostGIS).
- [ ] Mobile Initial Setup (Flutter + Provider/Riverpod).
- [ ] User Auth (Email/Phone) & Basic Roles.
- [ ] Lost/Found Posting with Image Uploads.
- [ ] Basic Map View with Markers.
- [ ] Social Media Sharing Deep Links.

### Phase 2: Community & Communication
- [ ] Real-time Chat System.
- [ ] Recently Seen sighting logs.
- [ ] Volunteer Mode toggle.
- [ ] Vet Directory listing.
- [ ] PDF Poster Generation.

### Phase 3: Advanced Coordination
- [ ] Private Search Groups.
- [ ] GPS Path Recording (Search Sessions).
- [ ] Zone Planning UI (Drawing on Map).
- [ ] Calendar view for search history.

### Phase 4: Intelligence & Growth
- [ ] AI Photo Matching.
- [ ] Heatmaps and Search Optimization analytics.
- [ ] Movement Prediction algorithms.
- [ ] Official Council/MAVMA API Integrations.
