import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:apk/database/db_pesan_private.dart';
import 'package:intl/intl.dart';

class ChatPrivate extends StatefulWidget {
  final String receiverId;
  final String receiverType; // 'guru' or 'murid'
  final String receiverName;

  const ChatPrivate({
    super.key,
    required this.receiverId,
    required this.receiverType,
    required this.receiverName,
  });

  @override
  State<ChatPrivate> createState() => _ChatPrivateState();
}

class _ChatPrivateState extends State<ChatPrivate> {
  final TextEditingController _messageController = TextEditingController();
  final DbPesanPrivate _dbPesan = DbPesanPrivate();
  
  bool _isLoading = true;
  String? _errorMessage;
  String? _idAdmin;
  String? _currentUserId;
  
  Stream<List<Map<String, dynamic>>>? _chatStream;

  @override
  void initState() {
    super.initState();
    _initChat();
  }

  Future<void> _initChat() async {
    try {
      _currentUserId = DbPesanPrivate.userId;
      _idAdmin = await _dbPesan.getAdminId();

      if (_idAdmin != null) {
        if (widget.receiverType == 'guru') {
          _chatStream = _dbPesan.getChatWithGuruStream(_idAdmin!, widget.receiverId);
        } else if (widget.receiverType == 'murid') {
          _chatStream = _dbPesan.getChatWithMuridStream(_idAdmin!, widget.receiverId);
        }
      } else {
        _errorMessage = 'Gagal memuat profil Admin. Pastikan Anda login sebagai Admin.';
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _idAdmin == null) return;

    _messageController.clear();

    try {
      if (widget.receiverType == 'guru') {
        await _dbPesan.sendMessageToGuru(
          text: text,
          idAdmin: _idAdmin!,
          idGuru: widget.receiverId,
        );
      } else if (widget.receiverType == 'murid') {
        await _dbPesan.sendMessageToMurid(
          text: text,
          idAdmin: _idAdmin!,
          idMurid: widget.receiverId,
        );
      }
      
      // Reload stream dari database setelah mengirim pesan
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
        await _initChat();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  String _formatTime(String isoString) {
    try {
      final date = DateTime.parse(isoString).toLocal();
      return DateFormat('HH:mm').format(date);
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat: ${widget.receiverName}'),
        backgroundColor: const Color(0xFF2563EB),
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Padding(padding: const EdgeInsets.all(16), child: Text(_errorMessage!, style: const TextStyle(color: Colors.red))))
              : Column(
                  children: [
                    Expanded(
                      child: _chatStream == null
                          ? const Center(child: Text('Gagal memuat ruang obrolan'))
                          : StreamBuilder<List<Map<String, dynamic>>>(
                              stream: _chatStream,
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Center(child: Text('Error: ${snapshot.error}'));
                                }
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                }

                                final messages = snapshot.data ?? [];

                                if (messages.isEmpty) {
                                  return const Center(child: Text('Belum ada pesan'));
                                }

                                return ListView.builder(
                                  reverse: true,
                                  padding: const EdgeInsets.all(16),
                                  itemCount: messages.length,
                                  itemBuilder: (context, index) {
                                    final msg = messages[messages.length - 1 - index];
                                    final isMe = msg['pengirim_admin'] == _idAdmin;

                                    return Align(
                                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(vertical: 4),
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: isMe ? const Color(0xFF2563EB) : Colors.grey[200],
                                          borderRadius: BorderRadius.only(
                                            topLeft: const Radius.circular(16),
                                            topRight: const Radius.circular(16),
                                            bottomLeft: isMe ? const Radius.circular(16) : const Radius.circular(0),
                                            bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(16),
                                          ),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              msg['text'] ?? '',
                                              style: TextStyle(
                                                color: isMe ? Colors.white : Colors.black87,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              _formatTime(msg['created_at']),
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: isMe ? Colors.white70 : Colors.black54,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            offset: const Offset(0, -2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _messageController,
                              decoration: InputDecoration(
                                hintText: 'Tulis pesan...',
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                filled: true,
                                fillColor: Colors.grey[100],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          CircleAvatar(
                            backgroundColor: const Color(0xFF2563EB),
                            child: IconButton(
                              icon: const Icon(Icons.send, color: Colors.white, size: 20),
                              onPressed: _sendMessage,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
