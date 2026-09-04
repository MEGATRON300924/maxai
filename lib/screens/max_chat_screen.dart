import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/chat_provider.dart';
import '../providers/profile_provider.dart';
import '../widgets/max_message_bubble.dart';
import '../widgets/max_chat_input.dart';
import '../widgets/max_typing_indicator.dart';
import '../widgets/max_orb.dart';
import '../widgets/liquid_glass_container.dart';
import '../widgets/max_svg_icon.dart';
import '../services/claude_voice_service.dart';
import '../core/app_colors.dart';

class MaxChatScreen extends StatefulWidget {
  const MaxChatScreen({super.key});

  @override
  State<MaxChatScreen> createState() => _MaxChatScreenState();
}

class _MaxChatScreenState extends State<MaxChatScreen> {
  final ScrollController controller = ScrollController();
  bool voiceActive = false;
  bool listening = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chat = context.watch<ChatProvider>();
    final profile = context.watch<ProfileProvider>();

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _header(profile.displayName),
                Expanded(
                  child: chat.messages.isEmpty
                      ? _welcome(profile.displayName)
                      : ListView.builder(
                          controller: controller,
                          padding: const EdgeInsets.only(top: 10, bottom: 20),
                          itemCount: chat.messages.length + (chat.isTyping ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (chat.isTyping && index == chat.messages.length) {
                              return const Padding(
                                padding: EdgeInsets.all(16),
                                child: MaxTypingIndicator(),
                              );
                            }
                            return MaxMessageBubble(message: chat.messages[index]);
                          },
                        ),
                ),
                MaxChatInput(
                  onSend: (message) {
                    chat.sendMessage(message: message);
                    _scrollDown();
                  },
                  onUpload: _upload,
                  onVoice: _startVoice,
                ),
              ],
            ),
            if (voiceActive) _voiceOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _header(String name) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const MaxOrb(size: 48),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'MAX AI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Ready to help $name',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: .55),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const MaxSvgIcon(asset: 'search', size: 34),
          const SizedBox(width: 8),
          const MaxSvgIcon(asset: 'config', size: 34),
        ],
      ),
    );
  }

  Widget _welcome(String name) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const MaxOrb(size: 150),
          const SizedBox(height: 30),
          Text(
            'Hello $name',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'What can MAX help you with today?',
            style: TextStyle(color: Colors.white.withValues(alpha: .6)),
          ),
        ],
      ),
    );
  }

  Widget _voiceOverlay() {
    return Container(
      color: Colors.black.withValues(alpha: .55),
      child: Center(
        child: LiquidGlassContainer(
          radius: 40,
          child: SizedBox(
            height: 300,
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaxOrb(size: 160, listening: listening),
                const SizedBox(height: 25),
                Text(
                  listening ? 'Listening...' : 'MAX Voice',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _startVoice() async {
    setState(() {
      voiceActive = true;
      listening = true;
    });
    await ClaudeVoiceService.instance.startSession();
  }

  void _upload() {
    // File upload handler: images, documents, and links.
  }

  void _scrollDown() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (controller.hasClients) {
        controller.animateTo(
          controller.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
