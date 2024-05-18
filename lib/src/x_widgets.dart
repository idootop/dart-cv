import 'dart:io';
import 'package:dart_cv/src/extensions.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class XEmpty extends StatelessWidget {
  XEmpty();

  @override
  Widget build(Context context) {
    return SizedBox.square(dimension: 0);
  }
}

class XSplit extends StatelessWidget {
  XSplit(this.text, {this.padding});
  final String text;
  final double? padding;

  @override
  Widget build(Context context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: padding ?? 4.px),
      child: XText(text, size: 10.px),
    );
  }
}

class XText extends StatelessWidget {
  XText(this.text, {this.size, this.bold = false});

  final String text;
  final double? size;
  final bool bold;

  @override
  Widget build(Context context) {
    return Text(
      text,
      style: Theme.of(context).defaultTextStyle.copyWith(
            fontSize: size ?? 10.px,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
    );
  }
}

class XIcon extends StatelessWidget {
  XIcon(this.path, {this.size});

  final String path;
  final double? size;

  @override
  Widget build(Context context) {
    return Image(
      MemoryImage(
        File('assets/icons/$path').readAsBytesSync(),
      ),
      width: size ?? 24.px,
      height: size ?? 24.px,
      fit: BoxFit.contain,
    );
  }
}

class XImage extends StatelessWidget {
  XImage(
    this.path, {
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  final String path;
  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(Context context) {
    return path.endsWith('.svg')
        ? SvgImage(
            svg: File('assets/images/$path').readAsStringSync(),
            width: width,
            height: height,
            fit: fit,
          )
        : Image(
            MemoryImage(
              File('assets/images/$path').readAsBytesSync(),
            ),
            width: width,
            height: height,
            fit: fit,
          );
  }
}

class XDivider extends StatelessWidget {
  XDivider({this.thickness, this.color});
  final double? thickness;
  final PdfColor? color;

  @override
  Widget build(Context context) {
    return Container(
      height: thickness ?? 1.px,
      margin: EdgeInsets.symmetric(vertical: 4.px),
      color: color ?? PdfColors.grey,
      child: Row(children: [XEmpty()]),
    );
  }
}

class XLink extends StatelessWidget {
  XLink(this.url, {this.text});
  final String url;
  final String? text;

  @override
  Widget build(Context context) {
    return UrlLink(
      destination: url,
      child: Text(
        text ?? url,
        style: TextStyle(
          fontSize: 10.px,
          color: PdfColors.blue,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}

class XIconText extends StatelessWidget {
  XIconText({
    required this.icon,
    required this.text,
    this.url,
  });
  final String icon;
  final String text;
  final String? url;

  @override
  Widget build(Context context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        XIcon(icon),
        SizedBox(width: 4.px),
        url == null ? XText(text) : XLink(url!, text: text)
      ],
    );
  }
}

class XSection extends StatelessWidget {
  XSection(this.title, {this.padding});
  final String title;
  final double? padding;

  @override
  Widget build(Context context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.px, top: padding ?? 12.px),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          XText(title, size: 12.px, bold: true),
          XDivider(thickness: 1.px, color: PdfColor.fromHex('#cccccc')),
        ],
      ),
    );
  }
}

class XIf extends StatelessWidget {
  XIf(this.isTrue, {required this.builder});
  final bool isTrue;
  final Widget Function(Context) builder;

  @override
  Widget build(Context context) {
    return isTrue ? builder(context) : XEmpty();
  }
}

List<Widget> xif(
  bool isTrue, {
  required List<Widget> Function() builder,
}) {
  return isTrue ? builder() : [];
}

class XProject extends StatelessWidget {
  XProject({
    required this.title,
    required this.time,
    this.link,
    this.description,
    this.singleLineDescriptions,
    this.bullets,
    this.gap,
  });
  final String title;
  final String? link;
  final String time;
  final String? description;
  final List<String>? singleLineDescriptions;
  final List<StatelessWidget>? bullets;
  final double? gap;

  @override
  Widget build(Context context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            XText(title, size: 10.px, bold: true),
            XIf(link != null, builder: (_) => XLink(link!)),
            XText(time, size: 10.px),
          ],
        ),
        XIf(
          description != null,
          builder: (_) => Padding(
            padding: EdgeInsets.only(top: 4.px),
            child: XText(description!, size: 10.px),
          ),
        ),
        XIf(
          singleLineDescriptions != null,
          builder: (_) => Padding(
            padding: EdgeInsets.only(top: 4.px),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: singleLineDescriptions!
                  .map((e) => XText(e, size: 10.px))
                  .toList(),
            ),
          ),
        ),
        ...xif(
          bullets != null,
          builder: () => bullets!
              .map(
                (e) => Padding(
                  padding: EdgeInsets.only(top: gap ?? 4.px),
                  child: e,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class XBulletBase extends StatelessWidget {
  XBulletBase({required this.children});
  final List<Widget> children;

  @override
  Widget build(Context context) {
    return Row(
      children: [
        Container(
          width: 6.px,
          height: 6.px,
          margin: EdgeInsets.symmetric(horizontal: 8.px),
          decoration:
              BoxDecoration(color: PdfColors.black, shape: BoxShape.circle),
        ),
        ...children,
      ],
    );
  }
}

class XBullet extends StatelessWidget {
  XBullet(this.text);
  final String text;

  @override
  Widget build(Context context) {
    return XBulletBase(
      children: [XText(text, size: 10.px)],
    );
  }
}

class XHeader extends StatelessWidget {
  XHeader({
    required this.name,
    required this.descriptions,
    this.qrcode,
    this.gap,
  });

  final String name;
  final String? qrcode;
  final double? gap;
  final List<Widget> descriptions;

  @override
  Widget build(Context context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        XIf(
          qrcode != null,
          builder: (_) => SizedBox(width: 64.px),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            XText(name, size: 18.px, bold: true),
            SizedBox(height: 4.px),
            Row(
              children: descriptions
                  .map(
                    (e) => Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: (gap ?? 8.px) / 2),
                      child: e,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
        XIf(
          qrcode != null,
          builder: (_) => XImage(qrcode!, width: 64.px, height: 64.px),
        ),
      ],
    );
  }
}
