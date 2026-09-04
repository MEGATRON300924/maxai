import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../services/max_memory_service.dart';
import '../services/voice_engine.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final MaxMemoryService _memory = MaxMemoryService.instance;
  final VoiceEngine _voice = VoiceEngine.instance;

  bool _voiceEnabled = true;
  bool _wakeWordEnabled = false;
  bool _memoryEnabled = true;
  bool _hapticFeedback = true;
  bool _autoSpeak = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await _memory.initialize();
    await _voice.initialize();

    if (!mounted) return;

    setState(() {
      _wakeWordEnabled = _voice.isWakeEngineEnabled;
    });
  }

  Future<void> _toggleWakeWord(bool value) async {
    setState(() {
      _wakeWordEnabled = value;
    });

    await _voice.toggleWakeEngine(value);

    if (!_voice.isWakeEngineEnabled && value && mounted) {
      setState(() {
        _wakeWordEnabled = false;
      });
    }
  }

  Future<void> _clearConversationMemory() async {
    final confirmed = await _confirm(
      title: 'Clear conversation memory?',
      message:
          'This removes memories created from conversations. Important memories and preferences will remain.',
      action: 'Clear',
    );

    if (!confirmed) return;

    await _memory.clearConversationMemories();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Conversation memory cleared'),
      ),
    );

    setState(() {});
  }

  Future<void> _clearVoiceMemory() async {
    final confirmed = await _confirm(
      title: 'Clear voice memory?',
      message:
          'This removes memories saved from voice conversations.',
      action: 'Clear',
    );

    if (!confirmed) return;

    await _memory.clearVoiceMemories();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Voice memory cleared'),
      ),
    );

    setState(() {});
  }

  Future<void> _clearAllMemory() async {
    final confirmed = await _confirm(
      title: 'Clear all memory?',
      message:
          'All MAX memories will be permanently removed except important memories.',
      action: 'Clear',
    );

    if (!confirmed) return;

    await _memory.clear(keepImportant: true);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Memory cleared'),
      ),
    );

    setState(() {});
  }

  Future<bool> _confirm({
    required String title,
    required String message,
    required String action,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(action),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  void _showMemoryManager() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _MemoryManagerSheet(
          memories: _memory.memories,
          onDelete: (id) async {
            await _memory.delete(id);

            if (context.mounted) {
              Navigator.of(context).pop();
            }

            if (mounted) {
              setState(() {});
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final memories = _memory.memories;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          _Section(
            title: 'Voice',
            children: [
              _SwitchTile(
                icon: Icons.mic_rounded,
                title: 'Voice',
                subtitle: 'Use voice conversations with MAX',
                value: _voiceEnabled,
                onChanged: (value) {
                  setState(() {
                    _voiceEnabled = value;
                  });

                  if (!value) {
                    _voice.stopListening();
                    _voice.stopSpeaking();
                  }
                },
              ),
              _SwitchTile(
                icon: Icons.graphic_eq_rounded,
                title: 'Hey MAX',
                subtitle: 'Listen for the MAX wake phrase',
                value: _wakeWordEnabled,
                enabled: _voiceEnabled,
                onChanged: _toggleWakeWord,
              ),
              _SwitchTile(
                icon: Icons.volume_up_rounded,
                title: 'Automatic voice responses',
                subtitle: 'Let MAX speak responses automatically',
                value: _autoSpeak,
                enabled: _voiceEnabled,
                onChanged: (value) {
                  setState(() {
                    _autoSpeak = value;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          _Section(
            title: 'Memory',
            children: [
              _SwitchTile(
                icon: Icons.psychology_rounded,
                title: 'MAX Memory',
                subtitle: 'Allow MAX to remember useful information',
                value: _memoryEnabled,
                onChanged: (value) {
                  setState(() {
                    _memoryEnabled = value;
                  });
                },
              ),
              _ActionTile(
                icon: Icons.memory_rounded,
                title: 'Manage memory',
                subtitle:
                    '${memories.length} saved ${memories.length == 1 ? 'memory' : 'memories'}',
                onTap: _showMemoryManager,
              ),
              _ActionTile(
                icon: Icons.chat_bubble_outline_rounded,
                title: 'Clear conversation memory',
                subtitle: 'Remove memories from conversations',
                onTap: _clearConversationMemory,
              ),
              _ActionTile(
                icon: Icons.mic_none_rounded,
                title: 'Clear voice memory',
                subtitle: 'Remove memories saved from voice',
                onTap: _clearVoiceMemory,
              ),
              _ActionTile(
                icon: Icons.delete_sweep_outlined,
                title: 'Clear memory',
                subtitle: 'Remove non-important memories',
                destructive: true,
                onTap: _clearAllMemory,
              ),
            ],
          ),
          const SizedBox(height: 20),
          _Section(
            title: 'Experience',
            children: [
              _SwitchTile(
                icon: Icons.vibration_rounded,
                title: 'Haptic feedback',
                subtitle: 'Use subtle vibration throughout MAX',
                value: _hapticFeedback,
                onChanged: (value) {
                  setState(() {
                    _hapticFeedback = value;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          _Section(
            title: 'MAX',
            children: [
              _ActionTile(
                icon: Icons.auto_awesome_rounded,
                title: 'About MAX',
                subtitle: 'The MAX AI Ecosystem',
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'MAX AI',
                    applicationVersion: '2.0',
                    applicationLegalese:
                        '© The Tron Forge Limited',
                    children: const [
                      SizedBox(height: 12),
                      Text(
                        'MAX is the intelligent assistant at the heart of The MAX AI Ecosystem.',
                      ),
                    ],
                  );
                },
              ),
              _ActionTile(
                icon: Icons.shield_outlined,
                title: 'Privacy',
                subtitle: 'Control your data and privacy',
                onTap: () {},
              ),
              _ActionTile(
                icon: Icons.help_outline_rounded,
                title: 'Help & feedback',
                subtitle: 'Get help or send feedback',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _Section({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 4,
            bottom: 10,
          ),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.35),
            ),
          ),
          child: Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                children[i],
                if (i < children.length - 1)
                  Divider(
                    height: 1,
                    indent: 68,
                    endIndent: 16,
                    color: Theme.of(context).dividerColor.withOpacity(0.35),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = enabled
        ? Theme.of(context).colorScheme.onSurface
        : AppColors.textHint;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),
      leading: Icon(
        icon,
        color: enabled
            ? Theme.of(context).colorScheme.primary
            : AppColors.textHint,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 13,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: enabled ? onChanged : null,
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool destructive;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.destructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = destructive
        ? AppColors.error
        : Theme.of(context).colorScheme.onSurface;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),
      leading: Icon(
        icon,
        color: destructive
            ? AppColors.error
            : Theme.of(context).colorScheme.primary,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 13,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right_rounded,
        color: AppColors.textHint,
      ),
      onTap: onTap,
    );
  }
}

class _MemoryManagerSheet extends StatelessWidget {
  final List<MaxMemory> memories;
  final Future<void> Function(String id) onDelete;

  const _MemoryManagerSheet({
    required this.memories,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.sizeOf(context).height * 0.82,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textHint.withOpacity(0.4),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'MAX Memory',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Text(
                    '${memories.length}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: memories.isEmpty
                  ? const Center(
                      child: Text(
                        'MAX has no saved memories yet.',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        8,
                        20,
                        24,
                      ),
                      itemCount: memories.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final memory = memories[index];

                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest
                                .withOpacity(0.45),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      memory.content,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        height: 1.4,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      memory.category,
                                      style: const TextStyle(
                                        color:
                                            AppColors.textSecondary,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () => onDelete(memory.id),
                                icon: const Icon(
                                  Icons.delete_outline_rounded,
                                  color: AppColors.error,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}