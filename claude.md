# Dart/Flutter Code Guidelines

## Naming Conventions

| Type | Style | Example |
|------|-------|---------|
| Classes, Enums, Typedefs | `UpperCamelCase` | `HttpRequest`, `UserProfile` |
| Files, Packages, Directories | `lowercase_with_underscores` | `user_profile.dart` |
| Variables, Functions, Parameters | `lowerCamelCase` | `userName`, `fetchData()` |
| Constants | `lowerCamelCase` | `const defaultTimeout = 1000` |
| Private members | `_leadingUnderscore` | `_privateMethod()` |

## Import Order

```dart
// 1. Dart SDK
import 'dart:async';
import 'dart:convert';

// 2. Flutter/Package imports
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

// 3. Relative imports
import '../models/user.dart';
import 'widgets/button.dart';
```

## Widget Best Practices

```dart
// GOOD: Small, focused widgets with const constructors
class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, required this.url});
  final String url;
  
  @override
  Widget build(BuildContext context) => CircleAvatar(backgroundImage: NetworkImage(url));
}

// BAD: Helper functions instead of widgets
Widget buildAvatar(String url) => CircleAvatar(...); // Can't use const, no optimization
```

**Key rules:**
- Use `const` constructors wherever possible
- Keep `build()` methods lightweight - no expensive computation
- Split large widgets into smaller, focused ones
- Localize `setState()` calls to minimize rebuilds

## State Management (Riverpod)

```dart
// Provider definition
final userProvider = StateNotifierProvider<UserNotifier, User>((ref) => UserNotifier());

// Usage in widget
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return Text(user.name);
  }
}
```

## Null Safety

```dart
// Use required for non-null parameters
void greet({required String name}) => print('Hello $name');

// Use late only when certain of initialization
late final Database db;

// Prefer null-aware operators
final name = user?.name ?? 'Guest';
```

## Async Patterns

```dart
// Use async/await over .then()
Future<User> fetchUser() async {
  final response = await http.get(Uri.parse('/user'));
  return User.fromJson(jsonDecode(response.body));
}

// Handle errors with try-catch
try {
  final user = await fetchUser();
} catch (e) {
  // Handle error
}
```

## Performance

- Use `ListView.builder` for long lists (lazy loading)
- Avoid `Opacity` widget when possible - use `AnimatedOpacity` or color opacity
- Cache expensive computations outside `build()`
- Use `const` widgets to prevent unnecessary rebuilds
- Prefer `StatelessWidget` over `StatefulWidget` when no state needed

## Project Structure

```
lib/
  core/           # App-wide utilities, constants, themes
  features/       # Feature modules
    auth/
      data/       # Repositories, data sources
      domain/     # Models, entities
      presentation/ # Screens, widgets, providers
  shared/         # Shared widgets, utilities
  main.dart
```

## Formatting

- Run `dart format .` before committing
- Max 80 characters per line
- Always use curly braces for control flow (except single-line if without else)

```dart
// OK: Single line if without else
if (isValid) return result;

// Required: Braces for everything else
if (isValid) {
  doSomething();
} else {
  doOther();
}
```
