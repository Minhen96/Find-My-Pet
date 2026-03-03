---
name: high-standard-coding
description: Coding standards for Find-My-Pet to ensure maximum maintainability, scalability, and professional quality.
---

# 🚀 Coding Standards for Find-My-Pet

This skill mandates strict adherence to professional-grade coding standards. **Never prioritize speed over quality.** All code must be built for the long term.

## 🏗 General Architectural Principles

- **SOLID Principles**: Every class and function must have a single responsibility.
- **Clean Architecture**: Strictly separate Business Logic (Services) from Framework concerns (Controllers/Drivers).
- **KISS & DRY**: Keep it simple and don't repeat yourself. If logic is used twice, extract it.
- **Type Safety**: Use strict typing. Avoid `any` in TypeScript and `dynamic` in Dart unless absolutely necessary.

---

## 🟢 Backend: NestJS (TypeScript)

### 1. Structure
- Use **Modular Architecture**. Each features (e.g., `Users`, `Posts`) must have its own module.
- Follow the flow: `Controller` → `Service` → `Repository` → `Entity`.

### 2. Naming Conventions
- **Classes/Interfaces**: `PascalCase` (e.g., `UserService`, `CreateUserDto`).
- **Variables/Functions**: `camelCase` (e.g., `findPetById`).
- **Files**: `kebab-case` with type suffix (e.g., `user.service.ts`, `auth.controller.ts`).

### 3. Documentation & Standards
- Every public API endpoint must have **Swagger (OpenAPI)** decorators.
- Use **DTOs** for all input validation (via `class-validator`).
- Implement a global **Exception Filter** for consistent error responses.

---

## 🔵 Mobile: Flutter (Dart)

### 1. State Management
- Use **Riverpod** or **Provider** for predictable state management.
- Keep the UI (Widgets) "dumb"—logic belongs in `ChangeNotifier`, `StateNotifier`, or `ViewModel`.

### 2. Naming Conventions
- **Classes**: `PascalCase`.
- **Variables/Functions**: `camelCase`.
- **Private members**: Prefix with underscore `_` (e.g., `_isSearching`).
- **Files**: `snake_case` (e.g., `pet_card_widget.dart`).

### 3. Widget Standards
- Break large widgets into smaller, **StatelessFunctionalWidgets** or small `StatelessWidget` classes.
- Use `const` constructors wherever possible for performance.
- Follow the **Standard Flutter Linting** (e.g., `flutter_lints`).

---

## 🛡 Quality & Testing

- **Error Handling**: Use `try/catch` and appropriate logging. Never swallow errors silently.
- **Testing**:
    - **Unit Tests**: Mandatory for complex business logic in Services/ViewModels.
    - **Integration Tests**: Required for critical paths (Auth, Post Creation).
- **Documentation**: Use JSDoc (TS) or DartDoc for all complex algorithms or non-obvious logic.

---

## 🛠 Workflow & Collaboration

### 1. Verification & Confirmation (CRITICAL)
- **Wait for Confirmation**: Do NOT start modifying or implementing code until the USER has explicitly confirmed the proposed plan or code change.
- **Propose First**: If a task requires implementation, first propose the detailed plan (via `implementation_plan.md`) or a code snippet for review.
- **No Autopilot**: Never assume "silent approval." Always ask: "Shall I proceed with this implementation?"

---

## ⚠️ Integrity Rule
**Do NOT** provide "vague" or "placeholder" implementations. If a feature is requested, build the full, robust version with validation, error handling, and proper typing. No shortcuts.
