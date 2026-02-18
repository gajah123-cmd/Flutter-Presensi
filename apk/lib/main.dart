import 'package:apk/dashboard/add_person.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'page1.dart';
import '/dashboard/class.dart';
import '/dashboard/announcement.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://iiucrouixgueeyhyqujs.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlpdWNyb3VpeGd1ZWV5aHlxdWpzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg3MjAwMTYsImV4cCI6MjA4NDI5NjAxNn0.JoquYZ2qxsYk3RE4Ih_KJxoHPjYp53SPgbF71CX8nKc',
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
        '/dashboard/class': (context) => const DaftarKelas(),
        '/dashboard/announcement': (context) => const Pengumuman(),
        '/dashboard/add_person': (context) => const TambahPengguna(),
       },
      
    );
  }
}