import 'dart:typed_data';

import '../controllers/log_controller.dart';

class BufferUtil {
  static List<String> toHexList(List<int> data) {
    List<String> hexList = [];
    for (var i = 0; i < data.length; i++) {
      var hex = data[i].toRadixString(16);
      if (hex.length == 1) {
        hex = "0$hex";
      }
      hexList.add(hex);
    }
    LogController.splittedLog("RAW TO HEX LIST (List<String>): $hexList");
    return hexList;
  }

  static List<String> mergedHexList(List<String> hexList) {
    List<String> mergedHexList = [];
    for (int i = 0; i < hexList.length; i += 2) {
      mergedHexList.add(hexList[i] + hexList[i + 1]);
    }
    LogController.splittedLog("MERGED HEX LIST (List<String>): $mergedHexList");
    return mergedHexList;
  }

  static List<int> hexListToBytes(List<String> hexList) {
    List<int> bytes = [];
    for (var i = 0; i < hexList.length; i++) {
      bytes.add(int.parse(hexList[i], radix: 16).toSigned(16));
    }
    LogController.splittedLog("PARSED DATA (List<int>): $bytes");
    return bytes;
  }

  static List<int> pcmToInt16(List<int> data, int sampleRate) {
    return hexListToBytes(mergedHexList(toHexList(data)));
  }

  static Future<Uint8List> pcmToUint8List(
      List<int> data, int sampleRate) async {
    LogController.splittedLog("RAW DATA (List<int>): $data");
    List<int> parsedData = hexListToBytes(mergedHexList(toHexList(data)));

    var channels = 1;

    int byteRate = ((16 * sampleRate * channels) / 8).round();

    var size = parsedData.length;
    var fileSize = size + 36;

    Uint8List header = Uint8List.fromList([
      // "RIFF"
      82, 73, 70, 70,
      fileSize & 0xff,
      (fileSize >> 8) & 0xff,
      (fileSize >> 16) & 0xff,
      (fileSize >> 24) & 0xff,
      // WAVE
      87, 65, 86, 69,
      // fmt
      102, 109, 116, 32,
      // fmt chunk size 16
      16, 0, 0, 0,
      // Type of format
      1, 0,
      // One channel
      channels, 0,
      // Sample rate
      sampleRate & 0xff,
      (sampleRate >> 8) & 0xff,
      (sampleRate >> 16) & 0xff,
      (sampleRate >> 24) & 0xff,
      // Byte rate
      byteRate & 0xff,
      (byteRate >> 8) & 0xff,
      (byteRate >> 16) & 0xff,
      (byteRate >> 24) & 0xff,
      // Uhm
      ((16 * channels) / 8).round(), 0,
      // bitsize
      16, 0,
      // "data"
      100, 97, 116, 97,
      size & 0xff,
      (size >> 8) & 0xff,
      (size >> 16) & 0xff,
      (size >> 24) & 0xff,
      // incoming data
      ...parsedData
    ]);
    return header;
  }
}
