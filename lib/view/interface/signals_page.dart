// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trade_with_shaw/controller/services/api/api_provider.dart';
import 'dart:ui';

class SignalsPage extends StatefulWidget {
  const SignalsPage({super.key});

  @override
  State<SignalsPage> createState() => _SignalsPageState();
}

class _SignalsPageState extends State<SignalsPage>
    with SingleTickerProviderStateMixin {
  int _selectedChannel = 0; // 0: Free, 1: Premium

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ApiProvider>(context, listen: false).fetchSignals();
    });
  }

  @override
  Widget build(BuildContext context) {
    final channelNames = ['Free Signals', 'Premium Signals'];
    return Consumer<ApiProvider>(
      builder: (context, api, _) {
        final freeSignals = api.signals.where((s) => s.type == 'free').toList();
        final premiumSignals =
            api.signals.where((s) => s.type == 'premium').toList();
        final signals = _selectedChannel == 0 ? freeSignals : premiumSignals;
        final isLocked = _selectedChannel == 1 && !api.isPremium;
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.surface,
                Theme.of(context).colorScheme.surface.withOpacity(0.85),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      2,
                      (i) => _buildChannelTab(context, channelNames[i], i),
                    ),
                  ),
                ),
                if (_selectedChannel == 0 && !api.isPremium)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: _UpgradeBanner(),
                  ),
                if (api.loading)
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  ),
                if (api.error != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          api.error ?? 'Unknown error',
                          style: const TextStyle(color: Colors.red),
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () => api.refreshSignals(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                if (!api.loading)
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () => api.refreshSignals(),
                      child: Stack(
                        children: [
                          ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            itemCount: signals.length,
                            itemBuilder: (context, index) {
                              final signal = signals[index];
                              return _SignalBubble(
                                title: signal.title,
                                message: signal.description,
                                time:
                                    signal.createdAt?.toLocal().toString() ??
                                    '',
                                isPremium: signal.type == 'premium',
                              );
                            },
                          ),
                          if (isLocked)
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 12,
                                    sigmaY: 12,
                                  ),
                                  child: Container(
                                    color: Colors.black.withOpacity(0.55),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.lock_rounded,
                                            size: 54,
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.primary,
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            'Upgrade to access Premium Signals',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.titleMedium?.copyWith(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                              foregroundColor: Colors.black,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                            ),
                                            onPressed:
                                                () => api.upgradeToPremium(),
                                            child: const Text('Upgrade Now'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChannelTab(BuildContext context, String label, int index) {
    final isSelected = _selectedChannel == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedChannel = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.18)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.white10,
            width: 1.2,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color:
                isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _SignalBubble extends StatelessWidget {
  final String title;
  final String message;
  final String time;
  final bool isPremium;

  const _SignalBubble({
    required this.title,
    required this.message,
    required this.time,
    required this.isPremium,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color:
                    isPremium
                        ? Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.13)
                        : Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color:
                      isPremium
                          ? Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.35)
                          : Colors.white10,
                  width: 1.1,
                ),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: const Icon(Icons.person, color: Colors.black),
                ),
                title: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                    ),
                    Text(
                      time,
                      style: Theme.of(
                        context,
                      ).textTheme.labelMedium?.copyWith(color: Colors.white54),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _UpgradeBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final api = Provider.of<ApiProvider>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.13),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.25),
              width: 1.1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Unlock premium signals and maximize your trading potential!',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => api.upgradeToPremium(),
                child: const Text('Upgrade'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
