import 'dart:async';
import 'package:flutter/material.dart';
import 'package:apk/database/db_device.dart';
import 'package:apk/function/custom_button.dart';

class FormAlatPage extends StatefulWidget {
  const FormAlatPage({super.key});

  @override
  State<FormAlatPage> createState() => _FormAlatPageState();
}

class _FormAlatPageState extends State<FormAlatPage> {
  final _idAlatController = TextEditingController();
  bool _isLoading = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Re-build periodically to update waiting times
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _idAlatController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _tambahAlat() async {
    final input = _idAlatController.text.trim();
    if (input.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan ID Alat terlebih dahulu!')),
      );
      return;
    }

    final idAlat = num.tryParse(input);
    if (idAlat == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID Alat harus berupa angka!')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await DeviceService.requestDevice(idAlat);
      if (mounted) {
        _idAlatController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permintaan alat berhasil dikirim. Menunggu konfirmasi IoT...')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal: ${e.toString().replaceAll("Exception: ", "")}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text('Daftar Alat IoT', style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FORM INPUT
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Tambahkan Alat Baru",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "ID Alat *",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _idAlatController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontFamily: 'Inter'),
                          decoration: InputDecoration(
                            hintText: "Contoh: 1001",
                            hintStyle: const TextStyle(color: Color(0xFFC4C4C4), fontFamily: 'Inter'),
                            filled: true,
                            fillColor: const Color(0xFFF1F5F9),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _tambahAlat,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: _isLoading 
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Text("Tambah", style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            
            const Text(
              "Alat Anda",
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 12),

            // LIST ALAT
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: DeviceService.getDevicesStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(fontFamily: 'Inter')));
                  }

                  final devices = snapshot.data ?? [];

                  if (devices.isEmpty) {
                    return const Center(
                      child: Text(
                        "Belum ada alat yang ditambahkan.",
                        style: TextStyle(fontFamily: 'Inter', color: Color(0xFF64748B)),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: devices.length,
                    itemBuilder: (context, index) {
                      final device = devices[index];
                      final idTabel = device['id_tabel'];
                      final idAlat = device['id_alat'];
                      final dataMasuk = device['data_masuk'];
                      final statusWaktuStr = device['status'];

                      bool isWaiting = dataMasuk != '11';
                      bool isTimeout = false;
                      int minutesWaited = 0;

                      if (isWaiting && statusWaktuStr != null) {
                        final statusTime = DateTime.parse(statusWaktuStr).toLocal();
                        minutesWaited = DateTime.now().difference(statusTime).inMinutes;
                        if (minutesWaited >= 5) {
                          isTimeout = true;
                          // Trigger cleanup if timeout
                          DeviceService.cancelOrRemoveDevice(idTabel);
                        }
                      }

                      if (isTimeout) {
                        return const SizedBox.shrink(); // Don't show if timeout (it will be deleted soon)
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: isWaiting 
                                    ? Colors.orange.withOpacity(0.1) 
                                    : const Color(0xFF10B981).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                isWaiting ? Icons.hourglass_empty : Icons.router,
                                color: isWaiting ? Colors.orange : const Color(0xFF10B981),
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "ID Alat: $idAlat",
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    isWaiting 
                                        ? "Menunggu konfirmasi IoT... ($minutesWaited/5 mnt)" 
                                        : "Terkoneksi (Aktif)",
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: isWaiting ? Colors.orange : const Color(0xFF10B981),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                isWaiting ? Icons.close : Icons.delete_outline, 
                                color: Colors.red
                              ),
                              tooltip: isWaiting ? "Batal Request" : "Hapus Alat",
                              onPressed: () {
                                DeviceService.cancelOrRemoveDevice(idTabel);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
