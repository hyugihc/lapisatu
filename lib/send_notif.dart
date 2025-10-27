import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

const String _projectId = 'lapissatu-bps-madiun-kab';
const String _keyFilePath =
    'lib/assets/credential/messagge_sender_credential.json';

Future<void> sendNotificationV1({
  required String title,
  required String body,
}) async {
  print("Attempting to send notification...");
  String? targetToken;
  final DocumentSnapshot snapshot = await FirebaseFirestore.instance
      .collection('acc-admin')
      .doc('creddentials_notification')
      .get();

  if (snapshot.exists) {
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
        print('Token FCM berhasil didapat: $targetToken');
      } else {
        print(
          'Error: Dokumen untuk petugas dengan ID "$linkToken" tidak ditemukan.',
        );
      }
    } catch (e) {
      print('Error: Field untuk hari "$hariIni" tidak ditemukan di dokumen.');
    }
  } else {
    print("Document does not exist");
    return;
  }

  if (targetToken == null) {
    return;
  }
  // 1. Dapatkan Kredensial Otentikasi OAuth 2.0
  final String keyFile = await rootBundle.loadString(_keyFilePath);
  final credentials = ServiceAccountCredentials.fromJson(jsonDecode(keyFile));
  const scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

  // Dapatkan http client yang sudah terotentikasi secara otomatis
  final AuthClient authClient = await clientViaServiceAccount(
    credentials,
    scopes,
  );

  // 2. Buat Body (Payload) Pesan
  final Map<String, dynamic> messagePayload = {
    'message': {
      'token': targetToken, // Token FCM perangkat tujuan
      'notification': {'title': title, 'body': body},
      // (Opsional) Anda bisa menambahkan data di sini
      'data': {'story_id': '12345'},
    },
  };

  // 3. Kirim HTTP POST Request ke Endpoint API V1
  final String endpoint =
      'https://fcm.googleapis.com/v1/projects/$_projectId/messages:send';

  try {
    final http.Response response = await authClient.post(
      Uri.parse(endpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(messagePayload),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully!');
      print('Response: ${response.body}');
    } else {
      print('Failed to send notification. Status: ${response.statusCode}');
      print('Error Response: ${response.body}');
    }
  } catch (e) {
    print('An error occurred while sending notification: $e');
  } finally {
    // Selalu tutup client setelah selesai
    authClient.close();
  }
}
