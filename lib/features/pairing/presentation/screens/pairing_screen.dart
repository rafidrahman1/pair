import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pair/core/errors/failure.dart';
import 'package:pair/core/theme/app_theme.dart';
import 'package:pair/core/utils/date_formatter.dart';
import 'package:pair/core/widgets/loading_overlay.dart';
import 'package:pair/features/pairing/presentation/providers/pairing_providers.dart';
import 'package:pair/router/route_paths.dart';

class PairingScreen extends ConsumerStatefulWidget {
  const PairingScreen({super.key});

  @override
  ConsumerState<PairingScreen> createState() => _PairingScreenState();
}

class _PairingScreenState extends ConsumerState<PairingScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _codeController = TextEditingController();
  bool _isJoining = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _joinWithCode() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) return;

    setState(() => _isJoining = true);
    final pair = await ref
        .read(pairingControllerProvider.notifier)
        .joinWithCode(code);
    setState(() => _isJoining = false);

    if (!mounted) return;

    if (pair != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully paired!')),
      );
      context.go(RoutePaths.home);
    } else {
      final error = ref.read(pairingControllerProvider).error;
      final message = error is Failure ? error.message : error?.toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message ?? 'Pairing failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final pairingState = ref.watch(pairingControllerProvider);
    final generatedCode = pairingState.valueOrNull;
    final isGenerating = pairingState.isLoading && !_isJoining;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pair with Spouse'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Generate Code'),
            Tab(text: 'Enter Code'),
          ],
        ),
      ),
      body: Stack(
        children: [
          TabBarView(
            controller: _tabController,
            children: [
              _GenerateCodeTab(
                code: generatedCode?.code,
                expiresAt: generatedCode?.expiresAt,
                onGenerate: () => ref
                    .read(pairingControllerProvider.notifier)
                    .generateCode(),
              ),
              _EnterCodeTab(
                controller: _codeController,
                onJoin: _joinWithCode,
              ),
            ],
          ),
          if (isGenerating || _isJoining)
            LoadingOverlay(
              message: isGenerating ? 'Generating code...' : 'Joining pair...',
            ),
        ],
      ),
    );
  }
}

class _GenerateCodeTab extends StatelessWidget {
  const _GenerateCodeTab({
    required this.onGenerate,
    this.code,
    this.expiresAt,
  });

  final VoidCallback onGenerate;
  final String? code;
  final DateTime? expiresAt;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Share this code with your spouse',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'The code expires in 10 minutes and can only be used once.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const Spacer(),
          if (code != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    code!,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                          color: AppColors.primary,
                        ),
                  ),
                  if (expiresAt != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Expires ${DateFormatter.time(expiresAt!)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: code!));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Code copied')),
                );
              },
              icon: const Icon(Icons.copy),
              label: const Text('Copy Code'),
            ),
          ] else
            Icon(
              Icons.qr_code_2,
              size: 80,
              color: AppColors.primary.withValues(alpha: 0.4),
            ),
          const Spacer(),
          FilledButton(
            onPressed: onGenerate,
            child: Text(code == null ? 'Generate Code' : 'Generate New Code'),
          ),
        ],
      ),
    );
  }
}

class _EnterCodeTab extends StatelessWidget {
  const _EnterCodeTab({
    required this.controller,
    required this.onJoin,
  });

  final TextEditingController controller;
  final VoidCallback onJoin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Enter your spouse\'s code',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Format: ABCD-1234',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: controller,
            textAlign: TextAlign.center,
            textCapitalization: TextCapitalization.characters,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  letterSpacing: 4,
                ),
            decoration: const InputDecoration(
              hintText: 'ABCD-1234',
            ),
          ),
          const Spacer(),
          FilledButton(
            onPressed: onJoin,
            child: const Text('Join Pair'),
          ),
        ],
      ),
    );
  }
}
