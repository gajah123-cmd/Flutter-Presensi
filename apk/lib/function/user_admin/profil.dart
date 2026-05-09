import 'package:flutter/material.dart';
import 'package:apk/database/auth.dart';
import 'package:apk/database/storage/image_profile.dart';
import 'package:apk/function/custom_button.dart';
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

  bool edit = false;
  bool isLoading = true;
  bool isSaving = false;
  String? _avatarUrl;
  String _savedName = "";
  String _savedNomorInduk = "";

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
          _savedName = nameController.text;
          _savedNomorInduk = nomorIndukController.text;
        }

        _avatarUrl = loadedAvatarUrl;
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
        setState(() {
          _savedName = nameController.text;
          _savedNomorInduk = nomorIndukController.text;
          edit = false;
        });

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

      if (mounted) {
        setState(() => _avatarUrl = newUrl);
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

      if (mounted) {
        setState(() => _avatarUrl = null);
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
                leading: const Icon(
                  Icons.photo_library,
                  color: Color(0xFF2563EB),
                ),
                title: const Text('Upload foto dari galeri'),
                onTap: () {
                  Navigator.pop(context);
                  _uploadImage();
                },
              ),
              if (_avatarUrl != null)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text(
                    'Hapus foto profil',
                    style: TextStyle(color: Colors.red),
                  ),
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
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Home()),
        (route) => false,
      );
    }
  }

  void _cancelEdit() {
    setState(() {
      edit = false;
      nameController.text = _savedName;
      nomorIndukController.text = _savedNomorInduk;
    });
  }

  IconData _iconForLabel(String label) {
    switch (label) {
      case "Email":
        return Icons.email_outlined;
      case "Peran":
        return Icons.verified_user_outlined;
      case "Nama Lengkap":
        return Icons.person_outline;
      case "Nomor Induk":
        return Icons.badge_outlined;
      default:
        return Icons.info_outline;
    }
  }

  String _displayValue(String value) {
    return value.isEmpty ? "Belum diisi" : value;
  }

  String get _nama =>
      nameController.text.isEmpty ? "Belum diisi" : nameController.text;
  String get _nomorInduk => nomorIndukController.text.isEmpty
      ? "Belum diisi"
      : nomorIndukController.text;
  String get _role =>
      roleController.text.isEmpty ? "Admin" : roleController.text;

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String value,
    bool isEmpty = false,
  }) {
    return CustomCard(
      title: title,
      subtitle: value,
      icon: icon,
      iconPosition: IconPosition.left,
      iconColor: const Color(0xFF2563EB),
      iconSize: 24,
      iconContainerSize: 46,
      iconDecoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(9),
      ),
      backgroundColor: Colors.white,
      borderColor: Colors.transparent,
      borderWidth: 0,
      borderRadius: 0,
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      boxShadow: const [],
      titleStyle: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFF8FA0BA),
      ),
      subtitleStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        fontWeight: FontWeight.w700,
        fontStyle: isEmpty ? FontStyle.italic : FontStyle.normal,
        color: isEmpty ? const Color(0xFFC8D2E0) : const Color(0xFF172033),
      ),
      showIcon: true,
    );
  }

  Widget field(
    String label,
    TextEditingController controller, {
    bool readOnly = false,
    TextInputType? keyboardType,
  }) {
    if (!edit) {
      return _infoCard(
        icon: _iconForLabel(label),
        title: label,
        value: _displayValue(controller.text),
        isEmpty: controller.text.isEmpty,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          readOnly: readOnly,
          keyboardType: keyboardType,
          style: const TextStyle(fontFamily: 'Inter'),
          decoration: InputDecoration(
            hintText: "Masukkan $label",
            hintStyle: const TextStyle(color: Color(0xFFC4C4C4), fontFamily: 'Inter'),
            filled: true,
            fillColor: readOnly ? const Color(0xFFE8EEF6) : const Color(0xFFF1F5F9),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _sectionCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE8EEF6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            for (int i = 0; i < children.length; i++) ...[
              children[i],
              if (i != children.length - 1)
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFF0F4FA),
                  indent: 82,
                  endIndent: 20,
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 15,
          fontWeight: FontWeight.w800,
          color: Color(0xFF64748B),
        ),
      ),
    );
  }

  Widget _profileHeader() {
    return SizedBox(
      height: 128,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomCard(
            title: "",
            showIcon: false,
            height: 126,
            backgroundColor: Colors.white,
            borderColor: const Color(0xFFE8EEF6),
            borderWidth: 1,
            borderRadius: 18,
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.13),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          Row(
            children: [
              const SizedBox(width: 20),
              CircleAvatar(
                radius: 36,
                backgroundColor: const Color(0xFF2563EB),
                backgroundImage:
                    _avatarUrl != null ? NetworkImage(_avatarUrl!) : null,
                onBackgroundImageError: _avatarUrl != null
                    ? (exception, stackTrace) {
                        if (mounted) {
                          setState(() => _avatarUrl = null);
                        }
                      }
                    : null,
                child: _avatarUrl == null
                    ? const Icon(Icons.person, size: 36, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _nama,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF172033),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.badge_outlined,
                          size: 18,
                          color: Color(0xFF8FA0BA),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "No. Induk: $_nomorInduk",
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.admin_panel_settings_outlined,
                            size: 18,
                            color: Color(0xFF2563EB),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _role,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2563EB),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget _avatarEditor() {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: const Color(0xFF2563EB),
          backgroundImage:
              _avatarUrl != null ? NetworkImage(_avatarUrl!) : null,
          onBackgroundImageError: _avatarUrl != null
              ? (exception, stackTrace) {
                  if (mounted) {
                    setState(() => _avatarUrl = null);
                  }
                }
              : null,
          child: _avatarUrl == null
              ? const Icon(Icons.person, size: 50, color: Colors.white)
              : null,
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: isSaving ? null : _showEditProfileSheet,
          icon: const Icon(Icons.edit, size: 16, color: Color(0xFF2563EB)),
          label: const Text(
            'Edit Foto',
            style: TextStyle(
              color: Color(0xFF2563EB),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _actionButton({
    required String label,
    required Color color,
    required VoidCallback? onPressed,
    bool loading = false,
  }) {
    final bool isWhite = color == Colors.white;
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: isWhite ? const Color(0xFF64748B) : Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: isWhite ? const BorderSide(color: Color(0xFF94A3B8)) : BorderSide.none,
          ),
        ),
        child: loading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: isWhite ? const Color(0xFF64748B) : Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }

  Widget _editBody() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                _avatarEditor(),
                const SizedBox(height: 24),
                
                Row(
                  children: const [
                    Icon(Icons.person, color: Color(0xFF1E293B), size: 24),
                    SizedBox(width: 8),
                    Text(
                      "Akun",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      field("Email", emailController, readOnly: true),
                      field("Peran", roleController, readOnly: true),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                Row(
                  children: const [
                    Icon(Icons.person, color: Color(0xFF1E293B), size: 24),
                    SizedBox(width: 8),
                    Text(
                      "Profil",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      field("Nama Lengkap", nameController),
                      field(
                        "Nomor Induk",
                        nomorIndukController,
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _actionButton(
                label: "Simpan",
                color: const Color(0xFF2563EB),
                onPressed: isSaving ? null : _updateProfile,
                loading: isSaving,
              ),
              const SizedBox(width: 10),
              _actionButton(
                label: "Batal",
                color: Colors.white,
                onPressed: isSaving ? null : _cancelEdit,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    nomorIndukController.dispose();
    emailController.dispose();
    roleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: const Text('Profil Admin'),
      backgroundColor: const Color(0xFF2563EB),
      elevation: 0,
      titleTextStyle: const TextStyle(
        fontFamily: "Inter",
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    );

    if (isLoading) {
      return Scaffold(
        appBar: appBar,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (edit) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Edit Profil", style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600)),
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1E293B),
          elevation: 0,
        ),
        body: _editBody(),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: appBar,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 18, 24, 28),
        children: [
          _profileHeader(),
          const SizedBox(height: 20),
          _sectionTitle("Akun"),
          _sectionCard([
            field("Email", emailController),
            field("Peran", roleController),
          ]),
          const SizedBox(height: 18),
          _sectionTitle("Identitas"),
          _sectionCard([
            field("Nama Lengkap", nameController),
            field("Nomor Induk", nomorIndukController),
          ]),
          const SizedBox(height: 24),
          Row(
            children: [
              _actionButton(
                label: "Edit",
                color: const Color(0xFF2563EB),
                onPressed: () => setState(() => edit = true),
              ),
              const SizedBox(width: 10),
              _actionButton(
                label: "Logout",
                color: Colors.red,
                onPressed: _logout,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
