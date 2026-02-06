import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../auth/presentation/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final theme = ShadTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Coach'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authProvider.notifier).signOut(),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User greeting
              Text('Welcome back,', style: theme.textTheme.muted),
              Text(authState.user?.name ?? 'User', style: theme.textTheme.h2),
              const SizedBox(height: 32),

              // Quick actions
              Text('Quick Actions', style: theme.textTheme.h4),
              const SizedBox(height: 16),

              ShadButton(
                width: double.infinity,
                onPressed: () {
                  // TODO: Start coaching session
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.mic),
                    SizedBox(width: 8),
                    Text('Start Coaching Session'),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              ShadButton.outline(
                width: double.infinity,
                onPressed: () {
                  // TODO: View history
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history),
                    SizedBox(width: 8),
                    Text('View Session History'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
