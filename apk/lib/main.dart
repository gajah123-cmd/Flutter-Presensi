import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:apk/load_screen/page1.dart';
import '/dashboard/class.dart';
import '/dashboard/announcement.dart';
import 'package:apk/dashboard/add_person.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '/load_screen/main_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: "lib/.env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

      return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Home(),
      
      routes: {
        '/page1': (context) => const Home(),
        '/load_screen': (context) => const MainScreen(),
        '/dashboard/class': (context) => const DaftarKelas(),
        '/dashboard/announcement': (context) => const Pengumuman(),
        '/dashboard/add_person': (context) => const TambahPengguna(),
       },
      
    );
  }
}