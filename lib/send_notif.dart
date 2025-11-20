import 'package:cloud_functions/cloud_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

// Ganti fungsi ini agar hanya mengambil token dan memanggil Cloud Function
Future<void> sendNotificationV1({
  required String title,
  required String body,
}) async {
  // 1. Ambil targetToken (logika ini BISA tetap di Flutter, atau pindah ke CF)
  String? targetToken;
  // ... (Logika untuk mendapatkan targetToken Anda yang ada saat ini)
  final DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection('acc-admin')
      .doc('creddentials_notification')
      .get();

  if (!snapshot.exists) {
    // print("Document does not exist");
    return;
  }

  // Lanjutkan logika pengambilan targetToken Anda
  await initializeDateFormatting('id_ID', null);
  final String hariIni = DateFormat(
    'EEEE',
    'id_ID',
  ).format(DateTime.now()).toLowerCase();

  try {
    String linkToken = (snapshot.get(hariIni) as String).trim();
    final DocumentSnapshot tokenDoc = await FirebaseFirestore.instance
        .collection('/acc-admin/creddentials_notification/fcms_list/')
        .doc(linkToken)
        .get();

    if (tokenDoc.exists) {
      targetToken = tokenDoc.get('token') as String;
      // print('Token FCM berhasil didapat: $targetToken');
    } else {
      // print(
      //   'Error: Dokumen untuk petugas dengan ID "$linkToken" tidak ditemukan.',
      // );
    }
  } catch (e) {
    // print('Error: Field untuk hari "$hariIni" tidak ditemukan di dokumen.');
  }

  if (targetToken == null) {
    // print('Gagal mendapatkan target token.');
    return;
  }

  // 2. Panggil Cloud Function
  try {
    final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
      'sendFCMNotification',
    );

    final result = await callable.call(<String, dynamic>{
      // 'token': targetToken,
      'title': title,
      'body': body,
    });

    print('Cloud Function response: ${result.data}');
  } on FirebaseFunctionsException catch (e) {
    // print('Firebase Function Call Failed:');
    print('Code: ${e.code}');
    // print('Message: ${e.message}');
    // print('Details: ${e.details}');
  } catch (e) {
    // print('An error occurred while calling the function: $e');
  }
}
