import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:apk/load_screen/page1.dart';
import '/dashboard/class.dart';
import '/dashboard/announcement.dart';
import 'package:apk/dashboard/add_person.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/load_screen/main_screen.dart';
import '/load_screen/login_screen.dart';
import '/load_screen/signup_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: "lib/.env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  final prefs = await SharedPreferences.getInstance();
  final String? userEmail = prefs.getString('user_email');

  runApp(MyApp(isLoggedIn: userEmail != null));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
      return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Home(),
      
      routes: {
        '/load_screen/login_screen': (context) => const LoginAdmin(),
        '/load_screen/signup_screen': (context) => const SignupAdmin(),
        '/page1': (context) => const Home(),
        '/load_screen': (context) => const MainScreen(),
        '/dashboard/class': (context) => const DaftarKelas(),
        '/dashboard/announcement': (context) => const Pengumuman(),
        '/dashboard/add_person': (context) => const TambahPengguna(),
       },
      
    );
  }
}