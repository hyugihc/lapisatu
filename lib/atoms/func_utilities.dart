import 'package:flutter/material.dart';
import 'package:lapis_satu/atoms/enum_var.dart';
import 'package:lapis_satu/atoms/const_var.dart';

String? getNameSC({required int subCatIdx, required Category category}) {
  try {
    List<String> subCatFiltered = AppVar.subCategory[category]!;
    String nameSC = subCatFiltered[subCatIdx];

    return nameSC;
  } catch (e) {
    // print(e);
    return null;
  }
}

Category id2Cat({required int catIdx}) {
  Category cat = Category.values.elementAt(catIdx);
  return cat;
}

void sortListMaps({
  required List<Map<String, dynamic>> data,
  required String colName,
  required bool ascending,
}) {
  data.sort((a, b) {
    final valA = a[colName];
    final valB = b[colName];

    final int comparison = _compareDynamic(valA, valB);
    return ascending ? comparison : -comparison;
  });
}

int _compareDynamic(dynamic valA, dynamic valB) {
  if (valA == null && valB == null) return 0;
  if (valA == null) return 1;
  if (valB == null) return -1;

  if (valA is Comparable) {
    try {
      return valA.compareTo(valB);
    } catch (e) {
      // print(e);
    }
  }
  return valA.toString().compareTo(valB.toString());
}

AppBar generateAppBar({
  required String title,
  required VoidCallback onBack,
  List<Widget>? actions,
}) {
  return AppBar(
    automaticallyImplyLeading: false,
    flexibleSpace: Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('lib/assets/backgroundd.jpg', fit: BoxFit.cover),
        Container(color: Colors.black.withValues(alpha: 0.3)),
      ],
    ),
    title: Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    leading: IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.white),
      onPressed: onBack,
    ),
    actions: actions,
  );
}

Widget generateInputField({
  required String label,
  required TextEditingController varText,
  int maxLine = 1,
  String? Function(String?)? validator,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8.0),
        TextFormField(
          controller: varText,
          maxLines: maxLine,
          decoration: InputDecoration(
            hintText: 'Jawaban anda',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 10.0,
            ),
            isDense: true,
          ),
          validator: validator,
        ),
      ],
    ),
  );
}

class ValidatorInput {
  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor HP tidak boleh kosong.';
    }
    String cleanedValue = value.replaceAll(RegExp(r'[^\d\+]'), '');
    if (cleanedValue.isEmpty) {
      return 'Nomor HP harus berupa angka.';
    }
    if (cleanedValue.length < 9 || cleanedValue.length > 15) {
      return 'Nomor HP tidak valid (panjang antara 9-15 digit).';
    }
    RegExp regex = RegExp(r'^(\+62|0)(8\d{8,13})$');

    if (!regex.hasMatch(cleanedValue)) {
      String normalizedValue = cleanedValue;
      if (normalizedValue.startsWith('+62')) {
        normalizedValue = '0${normalizedValue.substring(3)}';
      }

      if (!normalizedValue.startsWith('08')) {
        return 'Nomor HP harus dimulai dengan 08 atau +62.';
      }
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Alamat email tidak boleh kosong.';
    }

    const String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final RegExp regex = RegExp(pattern);

    if (!regex.hasMatch(value)) {
      return 'Masukkan format email yang valid (contoh: user@domain.com).';
    }

    return null;
  }

  static String? defaultRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'Wajib diisi';
    }
    return null;
  }
}
