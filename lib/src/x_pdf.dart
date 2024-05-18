import 'dart:io';
import 'dart:typed_data' show Uint8List;
import 'package:dart_cv/src/extensions.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class XPDF {
  static Future<Font> loadFontTTF(String path) async {
    Uint8List fontData = await File(path).readAsBytes();
    return Font.ttf(fontData.buffer.asByteData());
  }

  static Future<bool> render(
    String savePath, {
    List<Widget> Function(Context)? body,
    Widget Function(Context)? header,
    Widget Function(Context)? footer,
    ThemeData? theme,
    EdgeInsets? margin,
    PdfPageFormat? pageFormat,
  }) async {
    try {
      kPageFormat = pageFormat ?? PdfPageFormat.a4;
      final doc = Document(
        theme: theme ??
            ThemeData.withFont(
              base: await loadFontTTF('assets/fonts/MiSans-Regular.ttf'),
              bold: await loadFontTTF('assets/fonts/MiSans-Semibold.ttf'),
            ),
      );
      doc.addPage(
        MultiPage(
          theme: theme,
          margin: margin,
          pageFormat: kPageFormat,
          crossAxisAlignment: CrossAxisAlignment.start,
          header: header,
          footer: footer,
          build: body ?? (_) => [],
        ),
      );
      final docData = await doc.save();
      await File(savePath).writeAsBytes(docData, flush: true);
      return true;
    } catch (e) {
      print(e);
      print((e as dynamic).stackTrace);
      return false;
    }
  }
}
