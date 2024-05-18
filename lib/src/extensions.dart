import 'package:pdf/pdf.dart';

PdfPageFormat kPageFormat = PdfPageFormat.a4;

extension SizeExtension on num {
  double get px => this * PdfPageFormat.point;
  double get vw => kPageFormat.width * this * 0.01;
  double get vh => kPageFormat.height * this * 0.01;
}
