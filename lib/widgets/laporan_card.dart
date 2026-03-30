import 'package:flutter/material.dart';

class LaporanCard extends StatelessWidget {
  final Map<String, dynamic> laporan;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const LaporanCard({
    super.key,
    required this.laporan,
    required this.onDelete,
    required this.onTap,
  });

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

  @override
  Widget build(BuildContext context) {
    final status = laporan['status'] ?? "Baru";

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        onTap: onTap,

        leading: CircleAvatar(
          radius: 22,
          backgroundColor: getStatusColor(status).withOpacity(.15),
          child: Icon(
            Icons.warning_rounded,
            color: getStatusColor(status),
            size: 24,
          ),
        ),

        title: Text(
          laporan['lokasi'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Pelapor : ${laporan['nama_pelapor']}"),
            Text("${laporan['jenis_kerusakan']} • ${laporan['tanggal']}"),
          ],
        ),

        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
