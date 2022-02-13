import 'package:flutter/material.dart';
import 'package:flutter_samples/utils/k_means_albe.dart';

class DrawWidget extends StatefulWidget {
  const DrawWidget({
    Key? key,
    required this.origin,
    required this.points,
    required this.size,
    // required this.zoom,
    this.color = Colors.black,
    this.radius = 5,
  }) : super(key: key);

  final Offset origin;
  final List<DrawPointerable> points;
  final Size size;
  // final double zoom;

  final double radius;

  final Color color;

  @override
  State<StatefulWidget> createState() => _DrawPointState(
      // size: size,
      // color: color,
      // drawOnly: true,
      // points: points,
      // radius: radius,
      );

  // @override
  // void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  //   super.debugFillProperties(properties);
  //   properties.add(DiagnosticsProperty<Offset>('center', center));
  // }
}

class _DrawPointState extends State<DrawWidget> {
  _DrawPointState();

  @override
  Widget build(BuildContext context) => SizedBox(
        width: widget.size.width,
        height: widget.size.height,
        child: Stack(
          children: [
            CustomPaint(
              size: widget.size,
              painter: OpenPainter(
                origin: widget.origin,
                points: widget.points,
                color: widget.color,
                radius: widget.radius,
              ),
            ),
          ],
        ),
      );
}

class OpenPainter extends CustomPainter {
  OpenPainter({
    required this.points,
    required this.origin,
    required this.color,
    required this.radius,
  });
  final List<DrawPointerable> points;
  final Offset origin;
  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    for (var pt in points) {
      var paint = Paint()
        ..color = pt.color ?? color
        ..style = PaintingStyle.fill;

      final center = Offset(pt.dx, pt.dy) + origin;
      switch (pt.sharp) {
        case Sharp.circle:
          canvas.drawCircle(center, radius, paint);
          break;
        case Sharp.rect:
          canvas.drawRect(
              Rect.fromCircle(center: center, radius: radius * 2), paint);
          break;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
