import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:gcloud/storage.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:mime/mime.dart';

class CloudApi {
  final auth.ServiceAccountCredentials credentials;
  auth.AutoRefreshingAuthClient? client;

  CloudApi._(this.credentials);

  static CloudApi? _instance;

  static Future<CloudApi> getInstance() async {
    if (_instance == null) {
      String json = await rootBundle.loadString('assets/gcloud_credentials.json');
      _instance = CloudApi._(auth.ServiceAccountCredentials.fromJson(json));
      _instance!.client = await auth.clientViaServiceAccount(_instance!.credentials, Storage.SCOPES);
    }
    return _instance!;
  }

  Future<ObjectInfo> save(String name, Uint8List fileBytes) async {
    client ??= await auth.clientViaServiceAccount(credentials, Storage.SCOPES);

    var storage = Storage(client!, 'chambeape-cloud');
    var bucket = storage.bucket('chambeape-cloud-storage');
    final type = lookupMimeType(name);
    return await bucket.writeBytes(name, fileBytes, metadata: ObjectMetadata(contentType: type));
  }
}
