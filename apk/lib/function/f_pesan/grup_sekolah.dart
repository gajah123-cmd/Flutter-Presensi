import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:apk/database/db_grup_sekolah.dart';
import 'package:apk/function/f_pesan/member_sekolah.dart';

class GrupSekolah extends StatefulWidget {
  const GrupSekolah({super.key});

  @override
  State<GrupSekolah> createState() => _GrupSekolahState();
}

class _GrupSekolahState extends State<GrupSekolah> {
  final TextEditingController _messageController = TextEditingController();
  
  bool _isLoading = true;
  String? _errorMessage;
  
  String? _currentUserId;
  String? _currentUserRole; // 'admin', 'guru', or 'murid'
  
  Stream<List<Map<String, dynamic>>>? _chatStream;
  Map<String, String> _userNames = {}; // mapping ID ke Nama

  @override
  void initState() {
    super.initState();
    _initChat();
  }

  Future<void> _initChat() async {
    try {
      // Fetch mapping nama semua user
      _userNames = await DbGrupSekolah.fetchAllNames();

      // Fetch current user info
      final currentUserInfo = await DbGrupSekolah.getCurrentUserRoleAndId();
      
      if (currentUserInfo != null) {
        _currentUserId = currentUserInfo['id'];
        _currentUserRole = currentUserInfo['role'];
        _chatStream = DbGrupSekolah().getGrupSekolahStream();
      } else {
        _errorMessage = 'Gagal memuat profil. Pastikan Anda telah login dengan benar.';
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
    if (text.isEmpty || _currentUserId == null || _currentUserRole == null) return;

    _messageController.clear();

    try {
      await DbGrupSekolah().sendMessage(
        text: text,
        senderId: _currentUserId!,
        role: _currentUserRole!,
      );
      
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

  String _getSenderId(Map<String, dynamic> msg) {
    if (msg['pengirim_admin'] != null) return msg['pengirim_admin'].toString();
    if (msg['pengirim_guru'] != null) return msg['pengirim_guru'].toString();
    if (msg['pengirim_murid'] != null) return msg['pengirim_murid'].toString();
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grup Sekolah'),
        backgroundColor: const Color(0xFF2563EB),
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.people),
            tooltip: 'Anggota Grup',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MemberSekolah()),
              );
            },
          )
        ],
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
                                  return const Center(child: Text('Belum ada pesan. Mulai obrolan!'));
                                }

                                return ListView.builder(
                                  reverse: true,
                                  padding: const EdgeInsets.all(16),
                                  itemCount: messages.length,
                                  itemBuilder: (context, index) {
                                    final msg = messages[messages.length - 1 - index];
                                    bool isMe = false;
                                    if (_currentUserRole == 'admin') {
                                      isMe = msg['pengirim_admin']?.toString() == _currentUserId;
                                    } else if (_currentUserRole == 'guru') {
                                      isMe = msg['pengirim_guru']?.toString() == _currentUserId;
                                    } else if (_currentUserRole == 'murid') {
                                      isMe = msg['pengirim_murid']?.toString() == _currentUserId;
                                    }
                                    final senderId = _getSenderId(msg);
                                    final senderName = _userNames[senderId] ?? 'Pengguna';

                                    return Align(
                                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(vertical: 6),
                                        child: Column(
                                          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                          children: [
                                            if (!isMe)
                                              Padding(
                                                padding: const EdgeInsets.only(left: 4, bottom: 2),
                                                child: Text(
                                                  senderName,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.black54,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            Container(
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
