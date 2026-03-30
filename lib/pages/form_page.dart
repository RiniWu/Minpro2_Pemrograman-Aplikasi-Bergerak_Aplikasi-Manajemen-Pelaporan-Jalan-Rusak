import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/laporan_service.dart';

class FormPage extends StatefulWidget {
  final Map<String, dynamic>? laporan;

  const FormPage({super.key, this.laporan});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();

  final namaController = TextEditingController();
  final lokasiController = TextEditingController();
  final deskripsiController = TextEditingController();
  final tanggalController = TextEditingController();

  String selectedJenis = "Lubang";

  @override
  void initState() {
    super.initState();

    if (widget.laporan != null) {
      namaController.text = widget.laporan!['nama_pelapor'] ?? "";
      lokasiController.text = widget.laporan!['lokasi'] ?? "";
      deskripsiController.text = widget.laporan!['deskripsi'] ?? "";
      tanggalController.text = widget.laporan!['tanggal'] ?? "";
      selectedJenis = widget.laporan!['jenis_kerusakan'] ?? "Lubang";
    }
  }

  Future<void> pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      locale: const Locale("id", "ID"),
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),

      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1565C0),
              onPrimary: Colors.white,
              onSurface: Colors.black87,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat(
        "d MMMM yyyy",
        "id_ID",
      ).format(pickedDate);

      setState(() {
        tanggalController.text = formattedDate;
      });
    }
  }

  Future simpan() async {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      "nama_pelapor": namaController.text,
      "lokasi": lokasiController.text,
      "jenis_kerusakan": selectedJenis,
      "deskripsi": deskripsiController.text,
      "tanggal": tanggalController.text,
      "status": widget.laporan?['status'] ?? "Baru",
    };

    if (widget.laporan == null) {
      await LaporanService.insertLaporan(data);
    } else {
      await LaporanService.updateLaporan(
        widget.laporan!['id'].toString(),
        data,
      );
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.laporan == null ? "Tambah Laporan" : "Edit Laporan"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,

          child: ListView(
            children: [
              TextFormField(
                controller: namaController,
                decoration: const InputDecoration(labelText: "Nama Pelapor"),
                validator: (value) =>
                    value!.isEmpty ? "Tidak boleh kosong" : null,
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: lokasiController,
                decoration: const InputDecoration(labelText: "Lokasi"),
                validator: (value) =>
                    value!.isEmpty ? "Tidak boleh kosong" : null,
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField(
                value: selectedJenis,
                decoration: const InputDecoration(labelText: "Jenis Kerusakan"),
                items: ["Lubang", "Retak", "Amblas"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => selectedJenis = v!),
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: deskripsiController,
                decoration: const InputDecoration(labelText: "Deskripsi"),
                validator: (value) =>
                    value!.isEmpty ? "Tidak boleh kosong" : null,
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: tanggalController,
                readOnly: true,
                onTap: pickDate,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Tanggal tidak boleh kosong";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Tanggal",
                  suffixIcon: Icon(Icons.calendar_today),
                ),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark
                      ? const Color(0xFF4F8EF7)
                      : const Color(0xFF1565C0),

                  foregroundColor: Colors.white,

                  padding: const EdgeInsets.symmetric(vertical: 16),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),

                onPressed: simpan,
                child: const Text("Simpan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
