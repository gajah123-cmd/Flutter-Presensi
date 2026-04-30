import 'package:flutter/material.dart';
import 'package:apk/database/auth.dart';
import 'package:apk/database/storage/image_profile.dart';
import 'package:apk/load_screen/page1.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  final AuthService _authService = AuthService();
  final ImageProfileStorage _storageService = ImageProfileStorage();
  
  final nameController = TextEditingController();
  final nomorIndukController = TextEditingController();
  final emailController = TextEditingController();
  final roleController = TextEditingController();

  bool isLoading = true;
  bool isSaving = false;
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final data = await _authService.getProfile();
    final userId = Supabase.instance.client.auth.currentUser?.id;
    String? loadedAvatarUrl;
    if (userId != null) {
      loadedAvatarUrl = await _storageService.getProfileImageUrl(userId);
    }
    
    if (mounted) {
      setState(() {
        if (data != null) {
          nameController.text = data['name'] ?? '';
          nomorIndukController.text = data['nomor_induk'] ?? '';
          emailController.text = data['email'] ?? '';
          roleController.text = data['role'] ?? '';
        }
        
        if (loadedAvatarUrl != null) {
          _avatarUrl = loadedAvatarUrl;
        }
        
        isLoading = false;
      });
    }
  }

  Future<void> _updateProfile() async {
    setState(() => isSaving = true);
    try {
      await _authService.updateProfile(
        name: nameController.text,
        nomorInduk: nomorIndukController.text,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil berhasil diperbarui')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
  }

  Future<void> _uploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;

    setState(() => isLoading = true);
    try {
      final bytes = await pickedFile.readAsBytes();
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) throw 'User belum login';
      
      final newUrl = await _storageService.uploadProfileImage(userId, bytes);
      
      setState(() {
        _avatarUrl = newUrl;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto profil berhasil diperbarui')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengupload foto: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _deleteImage() async {
    setState(() => isLoading = true);
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) throw 'User belum login';
      
      await _storageService.deleteProfileImage(userId);
          
      setState(() {
        _avatarUrl = null;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto profil berhasil dihapus')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus foto: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void _showEditProfileSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: Color(0xFF2563EB)),
                title: const Text('Upload foto dari galeri'),
                onTap: () {
                  Navigator.pop(context);
                  _uploadImage();
                },
              ),
              if (_avatarUrl != null)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('Hapus foto profil', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.pop(context);
                    _deleteImage();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _logout() async {
    await _authService.signOut();
    if (mounted) {
      // Arahkan ke halaman page1 dan hapus tumpukan navigasi sebelumnya
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Home()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Admin'),
        backgroundColor: const Color(0xFF2563EB),
        elevation: 0,
        titleTextStyle: const TextStyle(
          fontFamily: "Inter",
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: const Color(0xFF2563EB),
                        backgroundImage: _avatarUrl != null ? NetworkImage(_avatarUrl!) : null,
                        onBackgroundImageError: _avatarUrl != null
                            ? (exception, stackTrace) {
                                if (mounted) {
                                  setState(() {
                                    _avatarUrl = null;
                                  });
                                }
                              }
                            : null,
                        child: _avatarUrl == null ? const Icon(Icons.person, size: 50, color: Colors.white) : null,
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: _showEditProfileSheet,
                        icon: const Icon(Icons.edit, size: 16, color: Color(0xFF2563EB)),
                        label: const Text(
                          'Edit Profil',
                          style: TextStyle(
                            color: Color(0xFF2563EB),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Text('Email (Read Only)'),
                const SizedBox(height: 6),
                TextField(
                  controller: emailController,
                  readOnly: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[300],
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Peran (Role)'),
                const SizedBox(height: 6),
                TextField(
                  controller: roleController,
                  readOnly: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[300],
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Nama Lengkap'),
                const SizedBox(height: 6),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text('Nomor Induk'),
                const SizedBox(height: 6),
                TextField(
                  controller: nomorIndukController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: isSaving ? null : _updateProfile,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: const Color(0xFF2563EB),
                  ),
                  child: isSaving
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text("Update Profil", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: _logout,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Colors.red, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Logout", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
    );
  }
}
