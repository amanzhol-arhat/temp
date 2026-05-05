import 'dart:io';
import 'package:xml/xml.dart';

void main() {
  final dir = Directory('assets/svg');
  final files = dir.listSync().whereType<File>().where((f) => f.path.endsWith('.svg'));

  for (final file in files) {
    try {
      final content = file.readAsStringSync();
      XmlDocument.parse(content);
    } catch (e) {
      print('Error parsing ${file.path}: $e');
    }
  }
}
