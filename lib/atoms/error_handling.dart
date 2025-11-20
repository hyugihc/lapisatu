import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreErrorHandler {
  FirestoreErrorHandler._();
  static void showErrorSnackBar(BuildContext context, Object error) {
    String errorMessage = _getFriendlyErrorMessage(error);
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final snackBar = SnackBar(
      content: Text(
        errorMessage,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: Colors.red[700],
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 4),
      action: SnackBarAction(
        label: 'OK',
        textColor: Colors.white,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static String _getFriendlyErrorMessage(Object error) {
    if (error is FirebaseException) {
      switch (error.code) {
        case 'permission-denied':
          return 'Akses ditolak. Anda tidak memiliki izin untuk operasi ini.';
        case 'not-found':
          return 'Data yang Anda tuju tidak ditemukan.';
        case 'unavailable':
          return 'Koneksi ke server gagal. Cek koneksi internet Anda.';
        case 'already-exists':
          return 'Gagal, karena data ini sudah ada.';
        case 'failed-precondition':
          return 'Error kueri';
        case 'invalid-argument':
          return 'Data yang Anda kirim tidak valid.';

        default:
          // print('[ERROR] : ${error.message ?? error.code}');
          return 'Terjadi Kesalahan Pada DataBase';
      }
    } else {
      // print(error);
      return 'Terjadi Kesalahan Pada DataBase';
    }
  }
}
