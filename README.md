# AI Coach App

AI-powered productivity coaching app with real-time voice/video communication.

## Tech Stack

- **Framework:** Flutter 3.38+
- **State Management:** Riverpod + Hooks
- **Navigation:** GoRouter
- **UI Components:** shadcn_ui
- **Voice/Video:** LiveKit
- **HTTP Client:** Dio
- **Storage:** flutter_secure_storage

## Getting Started

### Prerequisites

- Flutter SDK 3.10+
- Android Studio / VS Code
- Android SDK (for Android development)

### Installation

```bash
# Clone the repo
git clone https://github.com/vaibhav135/ai-coach-app.git
cd ai-coach-app

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Environment Setup

Copy `.env.example` to `.env` and fill in your values:

```bash
cp .env.example .env
```

## Project Structure

```
lib/
  core/           # App-wide utilities, constants, themes
  features/       # Feature modules
    auth/
    coaching/
    settings/
  shared/         # Shared widgets, utilities
  main.dart
```

## Development

### Pre-commit Hooks

This project uses husky for pre-commit hooks:
- `dart format --fix` - Auto-format code
- `dart analyze` - Static analysis

### Code Style

See [claude.md](./claude.md) for Dart/Flutter coding guidelines.

## License

MIT
