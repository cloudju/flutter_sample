import 'package:flutter/material.dart';

class DrawPointWidget extends StatefulWidget {
  DrawPointWidget({
    this.onPointsUpdate,
    this.points,
    this.drawOnly = true,
  });
  final void Function(List<Offset>)? onPointsUpdate;
  final List<Offset>? points;
  final bool drawOnly;

  @override
  State<StatefulWidget> createState() {
    return _DrawPointState(
      drawOnly: drawOnly,
      points: points ?? [],
    );
  }
}

class _DrawPointState extends State<DrawPointWidget> {
  _DrawPointState({
    required this.drawOnly,
    required this.points,
  });
  List<Offset> points = [];
  final bool drawOnly;

  @override
  Widget build(BuildContext context) => Container(
        color: null,
        child: Stack(
          children: [
            CustomPaint(
              painter: OpenPainter(points: points),
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
  OpenPainter({required this.points});
  final List<Offset> points;
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Color(0xff63aa65)
      ..style = PaintingStyle.fill;
    points.forEach(
      (pt) {
        canvas.drawCircle(pt, 5, paint);
      },
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
