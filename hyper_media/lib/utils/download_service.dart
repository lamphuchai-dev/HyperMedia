import 'dart:typed_data';

import 'package:dio_client/index.dart';
import 'package:flutter/services.dart';
import 'package:hyper_media/utils/file_service.dart';
import 'package:super_clipboard/super_clipboard.dart';

class DownloadService {
  const DownloadService({required DioClient dioClient})
      : _dioClient = dioClient;
  final DioClient _dioClient;

  Future<Uint8List?> downloadImageByUrl(String url,
      {Map<String, String>? headers}) async {
    try {
      final res = await _dioClient.get(url,
          options: Options(headers: headers, responseType: ResponseType.bytes));
      if (res is! Uint8List) return null;
      return Uint8List.fromList(res);
    } catch (err) {
      return null;
    }
  }

  Future<bool> saveImage(String url, {Map<String, String>? headers}) async {
    try {
      final bytes = await downloadImageByUrl(url, headers: headers);
      if (bytes == null) return false;
      final isSave = await FileService.saveImage(bytes);
      return isSave;
    } catch (err) {
      return false;
    }
  }

  Future<bool> clipboardImage(String url,
      {Map<String, String>? headers}) async {
    try {
      final bytes = await downloadImageByUrl(url, headers: headers);
      if (bytes == null) return false;
      final item = DataWriterItem();
      item.add(Formats.png(bytes));
      await ClipboardWriter.instance.write([item]);
      return true;
    } catch (err) {
      return false;
    }
  }
}
