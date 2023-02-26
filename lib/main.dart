import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _sliderValue = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sierpinski Triangle (${_sliderValue.toInt() + 4} Points)'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Slider.adaptive(
              value: _sliderValue,
              onChanged: (newVal) {
                setState(() {
                  _sliderValue = newVal;
                });
              },
              max: 24996, // +4 starting points
              min: 0,
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(10),
              color: Colors.black,
              child: LayoutBuilder(
                builder: (context, c) {
                  return CustomPaint(
                    size: Size(c.maxWidth, c.maxHeight),
                    painter: SierpinskiTriangle(
                      numOfPoints: _sliderValue.toInt(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SierpinskiTriangle extends CustomPainter {
  final int numOfPoints;

  SierpinskiTriangle({required this.numOfPoints});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..strokeWidth = 3;

    final outerTrianglePoints = [
      Offset(size.width / 2, 0), // top middle
      Offset(0, size.height), // bottom left
      Offset(size.width, size.height), // bottom right
    ];

    final points = <Offset>[
      ...outerTrianglePoints,
      Offset(size.width / 2, size.height / 2) // starting point in the middle
    ];

    for (int i = 0; i < numOfPoints; i++) {
      final lastDrawnPoint = points.last;
      final randomOuterpoint = outerTrianglePoints[Random().nextInt(3)];

      final x = (lastDrawnPoint.dx + randomOuterpoint.dx) / 2;
      final y = (lastDrawnPoint.dy + randomOuterpoint.dy) / 2;
      points.add(Offset(x, y));
    }
    canvas.drawPoints(PointMode.points, points, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
