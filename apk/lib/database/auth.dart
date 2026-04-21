import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  /// ===============================
  /// SIGNUP + EMAIL CONFIRM
  /// ===============================
  Future<AuthResponse> signUp(
    String email,
    String password,
  ) async {
    return await supabase.auth.signUp(
      email: email,
      password: password,
      emailRedirectTo: 'io.supabase.flutter://login-callback',
    );
  }

  /// ===============================
  /// LOGIN
  /// ===============================
  Future<AuthResponse> signIn(
    String email,
    String password,
  ) async {
    return await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// ===============================
  /// INSERT USER ADMIN
  /// ===============================
  Future<void> insertUser({
    required String id,
    required String email,
  }) async {
    await supabase.from('user_admin').insert({
      'id': id,
      'email': email,
      'name': null,
      'nomor_induk': null,
      'role': 'admin',
    });
  }

  /// ===============================
  /// GET PROFIL
  /// ===============================
  Future<Map<String, dynamic>?> getProfile() async {
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) return null;

    final data = await supabase
        .from('user_admin')
        .select()
        .eq('id', userId)
        .single();

    return data;
  }

  /// ===============================
  /// UPDATE PROFIL
  /// ===============================
  Future<void> updateProfile({
    required String name,
    required String nomorInduk,
  }) async {
    final userId = supabase.auth.currentUser?.id;

    await supabase.from('user_admin').update({
      'name': name,
      'nomor_induk': nomorInduk,
    }).eq('id', userId!);
  }

  /// ===============================
  /// LOGOUT
  /// ===============================
  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  /// ===============================
/// VERIFY OTP
/// ===============================
Future<AuthResponse> verifyOtp(
  String email,
  String otp,
) async {
  return await supabase.auth.verifyOTP(
    email: email,
    token: otp,
    type: OtpType.signup,
  );
}

/// ===============================
/// DELETE USER PUBLIC
/// ===============================
Future<void> deleteUserPublic(String email) async {
  await supabase
      .from('user_admin')
      .delete()
      .eq('email', email);
}

  Session? get session => supabase.auth.currentSession;
  User? get currentUser => supabase.auth.currentUser;
  String? get userId => supabase.auth.currentUser?.id;
}