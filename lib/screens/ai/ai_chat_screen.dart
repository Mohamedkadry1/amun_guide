// 📁 lib/screens/ai/ai_chat_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_assets.dart';
import '../../core/widgets/amun_app_bar.dart';
import '../../providers/conversation_provider.dart';
import '../../data/models/conversation_model.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  int? _activeConversationId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initChat();
    });
  }

  Future<void> _initChat() async {
    final prov = context.read<ConversationProvider>();
    await prov.loadConversations();
    if (prov.conversations.isNotEmpty) {
      _activeConversationId = prov.conversations.first.id;
      await prov.loadMessages(_activeConversationId!);
    } else {
      final conv = await prov.startNewConversation();
      if (conv != null) {
        _activeConversationId = conv.id;
        await prov.loadMessages(_activeConversationId!);
      }
    }
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  final _quickReplies = [
    '3-day Cairo plan 🔺',
    'Best time to visit Luxor',
    'Hidden gems in Aswan',
    'Budget trip tips 💰',
  ];

  void _sendMessage(String text) async {
    if (text.trim().isEmpty || _activeConversationId == null) return;
    
    final prov = context.read<ConversationProvider>();
    final msgText = text.trim();
    _controller.clear();
    
    await prov.sendMessage(_activeConversationId!, msgText);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<ConversationProvider>();
    final messages = prov.messages;

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AmunAppBar(
        title: 'Amun AI',
        actions: [
          IconButton(
            onPressed: () => _initChat(),
            icon: const Icon(Icons.refresh, color: Colors.white54, size: 20),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              width: 34, height: 34,
              decoration: BoxDecoration(
                color: AppColors.goldDim,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
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

      body: Column(children: [
        // ─── Messages ───────────────────────────
        Expanded(
          child: prov.isLoading && messages.isEmpty
            ? const Center(child: CircularProgressIndicator(color: AppColors.gold))
            : ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                itemCount: messages.length,
                itemBuilder: (_, i) => _buildMessage(messages[i], context),
              ),
        ),

        // ─── Quick Replies ───────────────────────
        if (messages.length <= 1)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _quickReplies.map((q) => GestureDetector(
                  onTap: () => _sendMessage(q),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.bgCard,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
                    ),
                    child: Text(q,
                        style: const TextStyle(
                            color: AppColors.gold, fontSize: 12)),
                  ),
                )).toList(),
              ),
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
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  onSubmitted: _sendMessage,
                  decoration: const InputDecoration(
                    hintText: 'Ask Amun anything...',
                    hintStyle: TextStyle(color: Colors.white38, fontSize: 14),
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
                width: 44, height: 44,
                decoration: const BoxDecoration(
                    color: AppColors.gold, shape: BoxShape.circle),
                child: const Icon(Icons.send_rounded,
                    color: Colors.black, size: 20),
              ),
            ),
          ]),
        ),
      ]),
    );
  }

  Widget _buildMessage(MessageModel msg, BuildContext context) {
    final isUser = msg.sender == 'user';
    final hasPlan = msg.message.toLowerCase().contains('plan') || 
                   msg.message.toLowerCase().contains('itinerary');

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
              width: 32, height: 32,
              margin: const EdgeInsets.only(right: 8, top: 4),
              decoration: BoxDecoration(
                color: AppColors.goldDim,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
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
                  child: Text(msg.message,
                      style: TextStyle(
                          color: isUser ? Colors.black : Colors.white,
                          fontSize: 14,
                          height: 1.5)),
                ),

                // Plan card CTA
                if (hasPlan) ...[
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(
                        context, '/ai-plan-details'),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.goldDim,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: AppColors.gold.withValues(alpha: 0.4)),
                      ),
                      child: const Row(children: [
                        Icon(Icons.map_outlined,
                            color: AppColors.gold, size: 20),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text('View Full Itinerary Plan',
                              style: TextStyle(
                                  color: AppColors.gold,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13)),
                        ),
                        Icon(Icons.arrow_forward_ios,
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
