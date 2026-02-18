import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;
  
  Future<AuthResponse> signIn(String email, String password) {
    return supabase.auth.signInWithPassword (email: email, password: password);
  }

  Session? getSession() => supabase.auth.currentSession;

  Stream<AuthState> get authChanges => supabase.auth.onAuthStateChange;
}