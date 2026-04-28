// 📁 lib/screens/ai/ai_chat_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_assets.dart';
import '../../core/widgets/amun_app_bar.dart';
import '../../features/places/providers/conversation_provider.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  bool _isInitialized = false;

  final _quickReplies = [
    '3-day Cairo plan 🔺',
    'Best time to visit Luxor',
    'Hidden gems in Aswan',
    'Budget trip tips 💰',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeChat();
    });
  }

  Future<void> _initializeChat() async {
    try {
      final provider = Provider.of<ConversationProvider>(context, listen: false);
      
      // Create or load conversation for general AI chat
      if (provider.currentConversation == null) {
        await provider.createConversation(context: 'general');
      }
      
      setState(() => _isInitialized = true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to initialize chat: ${e.toString()}')),
        );
      }
    }
  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty || !_isInitialized) return;

    final provider = Provider.of<ConversationProvider>(context, listen: false);
    if (provider.currentConversation == null) return;

    _controller.clear();

    try {
      // Send message to API
      await provider.sendMessage(message: text);

      // Scroll to bottom
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send message: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AmunAppBar(
        title: 'Amun AI',
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              width: 34, height: 34,
              decoration: BoxDecoration(
                color: AppColors.goldDim,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.gold.withOpacity(0.4)),
              ),
              child: ClipOval(
                child: Image.asset(AppAssets.amunAvatar,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                        Icons.auto_awesome,
                        color: AppColors.gold, size: 18)),
              ),
            ),
          ),
        ],
      ),

      body: Consumer<ConversationProvider>(
        builder: (_, provider, __) {
          if (!_isInitialized || provider.currentConversation == null) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.gold),
            );
          }

          final messages = provider.messages;

          return Column(children: [

            // ─── Messages ───────────────────────────
            Expanded(
              child: messages.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.auto_awesome,
                              color: AppColors.gold.withOpacity(0.5),
                              size: 48),
                          const SizedBox(height: 16),
                          Text(
                            'Hello! I\'m Amun',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Your personal Egypt travel assistant',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                      itemCount: messages.length,
                      itemBuilder: (_, i) =>
                          _buildMessage(messages[i], context),
                    ),
            ),

            // ─── Quick Replies ───────────────────────
            if (messages.isEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _quickReplies
                        .map((q) => GestureDetector(
                              onTap: () => _sendMessage(q),
                              child: Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppColors.bgCard,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color:
                                          AppColors.gold.withOpacity(0.3)),
                                ),
                                child: Text(q,
                                    style: const TextStyle(
                                        color: AppColors.gold, fontSize: 12)),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),

            // ─── Loading indicator when sending ─────
            if (provider.isSendingMessage)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: AppColors.goldDim,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppColors.gold.withOpacity(0.4)),
                      ),
                      child: const Icon(Icons.auto_awesome,
                          color: AppColors.gold, size: 16),
                    ),
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: AppColors.gold,
                        strokeWidth: 2,
                      ),
                    ),
                  ],
                ),
              ),

            // ─── Input ──────────────────────────────
            Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
              decoration: const BoxDecoration(
                color: Color(0xFF1E1A16),
                border: Border(top: BorderSide(color: Colors.white10)),
              ),
              child: Row(children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.bgInput,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 14),
                      onSubmitted: _sendMessage,
                      enabled: !provider.isSendingMessage,
                      decoration: const InputDecoration(
                        hintText: 'Ask Amun anything...',
                        hintStyle: TextStyle(
                            color: Colors.white38, fontSize: 14),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => _sendMessage(_controller.text),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                        color: AppColors.gold, shape: BoxShape.circle),
                    child: provider.isSendingMessage
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.black),
                            ),
                          )
                        : const Icon(Icons.send_rounded,
                            color: Colors.black, size: 20),
                  ),
                ),
              ]),
            ),
          ]);
        },
      ),
    );
  }

  Widget _buildMessage(dynamic message, BuildContext context) {
    // Handle Message object from provider
    final isUser = message.sender == 'user';
    final text = message.message;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          // AI avatar
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(right: 8, top: 4),
              decoration: BoxDecoration(
                color: AppColors.goldDim,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.gold.withOpacity(0.4)),
              ),
              child: const Icon(Icons.auto_awesome,
                  color: AppColors.gold, size: 16),
            ),
          ],

          // Bubble
          Flexible(
            child: Column(
              crossAxisAlignment: isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isUser ? AppColors.gold : AppColors.bgCard,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isUser ? 16 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 16),
                    ),
                    border: isUser
                        ? null
                        : Border.all(color: Colors.white10),
                  ),
                  child: Text(text,
                      style: TextStyle(
                          color: isUser ? Colors.black : Colors.white,
                          fontSize: 14,
                          height: 1.5)),
                ),

                // Plan card CTA - show if response mentions "plan" or "itinerary"
                if (!isUser &&
                    (text.toLowerCase().contains('plan') ||
                        text.toLowerCase().contains('itinerary')))
                  ...[
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, '/ai-plan-details'),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.goldDim,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                              color: AppColors.gold.withOpacity(0.4)),
                        ),
                        child: Row(children: [
                          const Icon(Icons.map_outlined,
                              color: AppColors.gold, size: 20),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text('View Full Itinerary Plan',
                                style: TextStyle(
                                    color: AppColors.gold,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13)),
                          ),
                          const Icon(Icons.arrow_forward_ios,
                              color: AppColors.gold, size: 14),
                        ]),
                      ),
                    ),
                  ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}