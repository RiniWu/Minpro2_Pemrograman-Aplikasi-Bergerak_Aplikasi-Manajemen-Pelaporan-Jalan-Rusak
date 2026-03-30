import 'package:flutter/material.dart';
import '../services/laporan_service.dart';
import 'form_page.dart';

class DetailPage extends StatefulWidget {
  final Map<String, dynamic> laporan;

  const DetailPage({super.key, required this.laporan});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Map<String, dynamic> laporan;

  @override
  void initState() {
    super.initState();
    laporan = widget.laporan;
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "Baru":
        return Colors.red;
      case "Diproses":
        return Colors.orange;
      case "Selesai":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData getStatusIcon(String status) {
    switch (status) {
      case "Baru":
        return Icons.new_releases;
      case "Diproses":
        return Icons.build;
      case "Selesai":
        return Icons.check_circle;
      default:
        return Icons.info;
    }
  }

  Future<void> updateStatus(String status) async {
    if (laporan['status'] == status) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Status sudah dipilih")));
      return;
    }

    final confirm = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Ubah Status"),
          content: Text(
            "Apakah Anda yakin ingin mengubah status menjadi '$status'?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF4F8EF7),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Ya"),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    await LaporanService.updateLaporan(laporan['id'].toString(), {
      "status": status,
    });

    setState(() {
      laporan['status'] = status;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Status berhasil diperbarui")));

    Navigator.pop(context, true);
  }

  Widget statusButton(String status) {
    final current = laporan['status'];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: current == status
              ? getStatusColor(status)
              : (isDark ? const Color(0xFF2A2A2A) : Colors.grey.shade300),

          foregroundColor: current == status
              ? Colors.white
              : (isDark ? Colors.white : Colors.black87),

          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 14),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () => updateStatus(status),
        child: Text(status),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final status = laporan['status'] ?? "Baru";

    return Scaffold(
      appBar: AppBar(title: const Text("Detail Laporan")),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    laporan['lokasi'],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Icon(Icons.person_outline, size: 18),
                      const SizedBox(width: 6),
                      Text("Pelapor: ${laporan['nama_pelapor']}"),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      const Icon(Icons.build_outlined, size: 18),
                      const SizedBox(width: 6),
                      Text("Jenis: ${laporan['jenis_kerusakan']}"),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 18),
                      const SizedBox(width: 6),
                      Text("Tanggal: ${laporan['tanggal']}"),
                    ],
                  ),

                  const SizedBox(height: 14),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),

                    decoration: BoxDecoration(
                      color: getStatusColor(status),
                      borderRadius: BorderRadius.circular(30),
                    ),

                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          getStatusIcon(status),
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          status,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Ubah Status",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                statusButton("Baru"),
                const SizedBox(width: 8),
                statusButton("Diproses"),
                const SizedBox(width: 8),
                statusButton("Selesai"),
              ],
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text("Edit Laporan"),

                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F8EF7),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),

                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FormPage(laporan: laporan),
                    ),
                  );

                  if (result == true) {
                    Navigator.pop(context, true);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
