import 'dart:async';
import 'package:apk/load_screen/login_screen.dart';
import 'package:flutter/material.dart';
import '/database/auth.dart';

class SignupAdmin extends StatefulWidget {
  const SignupAdmin({super.key});

  @override
  State<SignupAdmin> createState() => _SignupAdminState();
}

class _SignupAdminState extends State<SignupAdmin> {
  final _auth = AuthService();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final otpController = TextEditingController();

  bool isHidden = true;
  bool isLoading = false;
  bool isOtpSent = false;

  Timer? timer;
  int secondsLeft = 300; // 5 menit

  /// ===============================
  /// KIRIM OTP
  /// ===============================
  Future<void> sendOtp() async {
    setState(() => isLoading = true);

    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      await _auth.signUp(email, password);

      startTimer();

      setState(() {
        isOtpSent = true;
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP dikirim ke email")),
      );
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  /// ===============================
  /// TIMER 5 MENIT
  /// ===============================
  void startTimer() {
    timer?.cancel();
    secondsLeft = 300;

    timer = Timer.periodic(const Duration(seconds: 1), (t) async {
      if (secondsLeft == 0) {
        t.cancel();

        /// hapus user public (jika ada)
        await _auth.deleteUserPublic(emailController.text.trim());

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Waktu habis, silakan daftar ulang")),
        );

        setState(() {
          isOtpSent = false;
          otpController.clear();
        });

      } else {
        setState(() => secondsLeft--);
      }
    });
  }

  /// ===============================
  /// VERIFY OTP
  /// ===============================
  Future<void> verifyOtp() async {
    setState(() => isLoading = true);

    try {
      final email = emailController.text.trim();
      final otp = otpController.text.trim();

      final res = await _auth.verifyOtp(email, otp);
      final user = res.user;

      if (user != null) {
        /// STOP TIMER
        timer?.cancel();

        /// INSERT SETELAH OTP VALID
        await _auth.insertUser(
          id: user.id,
          email: email,
        );

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Verifikasi berhasil")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const LoginAdmin(),
          ),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP salah")),
      );
    }
  }

  String formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        children: [
          const SizedBox(height: 70),

          const Text(
            "Daftar Admin",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 40),

          /// EMAIL
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              hintText: "Email",
              filled: true,
              fillColor: const Color(0xFFF1F5F9),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// PASSWORD
          TextField(
            controller: passwordController,
            obscureText: isHidden,
            decoration: InputDecoration(
              hintText: "Password",
              filled: true,
              fillColor: const Color(0xFFF1F5F9),
              suffixIcon: IconButton(
                icon: Icon(isHidden
                    ? Icons.visibility
                    : Icons.visibility_off),
                onPressed: () {
                  setState(() => isHidden = !isHidden);
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),

          /// OTP FIELD
          if (isOtpSent) ...[
            const SizedBox(height: 20),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Masukkan OTP",
                filled: true,
                fillColor: const Color(0xFFF1F5F9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Waktu: ${formatTime(secondsLeft)}",
              style: const TextStyle(color: Colors.red),
            ),
          ],

          const SizedBox(height: 40),

          /// BUTTON
          SizedBox(
            height: 55,
            child: ElevatedButton(
              onPressed: isLoading
                  ? null
                  : isOtpSent
                      ? verifyOtp
                      : sendOtp,
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(isOtpSent ? "Verifikasi" : "Daftar"),
            ),
          ),

                    const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Sudah punya akun? ",
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 15,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LoginAdmin(),
                    ),
                  );
                },
                child: const Text(
                  "Masuk",
                  style: TextStyle(
                    color: Color(0xFF2563EB),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 70),
        ],
      ),
    );
  }
}