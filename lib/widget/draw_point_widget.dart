import 'package:flutter/material.dart';

class DrawPointWidget extends StatefulWidget {
  DrawPointWidget({
    required this.size,
    this.onPointsUpdate,
    this.points,
    this.color = Colors.black,
    this.radius = 5,
    this.drawOnly = true,
  });
  final void Function(List<Offset>)? onPointsUpdate;
  final List<Offset>? points;
  final bool drawOnly;
  final Size size;
  final double radius;

  final Color color;

  @override
  State<StatefulWidget> createState() {
    return _DrawPointState(
      size: size,
      color: color,
      drawOnly: drawOnly,
      points: points ?? [],
      radius: radius,
    );
  }
}

class _DrawPointState extends State<DrawPointWidget> {
  _DrawPointState({
    required this.size,
    required this.drawOnly,
    required this.points,
    required this.color,
    required this.radius,
  });
  List<Offset> points = [];
  final bool drawOnly;
  final Size size;
  final Color color;
  final double radius;

  @override
  Widget build(BuildContext context) => Container(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            CustomPaint(
              size: size,
              painter: OpenPainter(
                points: points,
                color: color,
                radius: radius,
              ),
            ),
            if (!drawOnly)
              InkWell(
                onTap: () => null,
                onTapDown: (details) {
                  setState(
                    () {
                      points.add(details.localPosition);
                      if (widget.onPointsUpdate != null) {
                        widget.onPointsUpdate!(points);
                      }
                    },
                  );
                },
              ),
          ],
        ),
      );
}

class OpenPainter extends CustomPainter {
  OpenPainter({
    required this.points,
    required this.color,
    required this.radius,
  });
  final List<Offset> points;
  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    points.forEach(
      (pt) {
        canvas.drawCircle(pt, radius, paint);
      },
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
