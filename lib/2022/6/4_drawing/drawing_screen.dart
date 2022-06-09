import 'dart:ui' as ui;
import 'dart:async';
import 'dart:developer';

import 'package:daily_ui/2022/6/4_drawing/drawn_line.dart';
import 'package:daily_ui/2022/6/4_drawing/hand_drawing_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DrawingScreen extends StatefulWidget {
  const DrawingScreen({Key? key}) : super(key: key);

  @override
  _DrawingScreenState createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  final GlobalKey _globalKey = GlobalKey();
  List<DrawnLine?> lines = <DrawnLine?>[];
  DrawnLine? line;
  Color selectedColor = Colors.black;
  double selectedWidth = 5.0;

  StreamController<List<DrawnLine?>> linesStreamController =
      StreamController<List<DrawnLine?>>.broadcast();
  StreamController<DrawnLine?> currentLineStreamController =
      StreamController<DrawnLine?>.broadcast();

  @override
  void dispose() {
    linesStreamController.close();
    currentLineStreamController.close();
    super.dispose();
  }

  Future<void> save() async {
    try {
      final boundary = _globalKey.currentContext!.findRenderObject()
          as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();
      print("saved");
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> clear() async {
    log("clear");
    lines = [];
    line = null;
    linesStreamController.add([]);
    currentLineStreamController.add(null);
  }

  void _onPanStart(DragStartDetails details) {
    final box = context.findRenderObject() as RenderBox;
    final point = box.globalToLocal(details.globalPosition);
    line = DrawnLine([point], selectedColor, selectedWidth);
    currentLineStreamController.add(line);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final box = context.findRenderObject() as RenderBox;
    final point = box.globalToLocal(details.globalPosition);
    final path = List<Offset?>.from(line!.path)..add(point);
    line = DrawnLine(path, selectedColor, selectedWidth);

    currentLineStreamController.add(line);
  }

  void _onPanEnd(DragEndDetails details) {
    lines = List.from(lines)..add(line);

    linesStreamController.add(lines);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[50],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: Stack(
        children: [
          _buildAllPaths(),
          _buildCurrentPath(),
          _buildColorToolbar(),
          _buildStrokeToolbar(),
        ],
      ),
    );
  }

  Widget _buildAllPaths() {
    return RepaintBoundary(
      key: _globalKey,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: StreamBuilder<List<DrawnLine?>>(
          stream: linesStreamController.stream,
          builder: (context, snapshot) {
            return CustomPaint(
              painter: HandDrawingPainter(
                lines: lines,
              ),
              size: Size.infinite,
            );
          },
        ),
      ),
    );
  }

  Widget _buildCurrentPath() {
    return GestureDetector(
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      child: RepaintBoundary(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: StreamBuilder<DrawnLine?>(
            stream: currentLineStreamController.stream,
            builder: (context, snapshot) {
              return CustomPaint(
                painter: HandDrawingPainter(
                  lines: [line],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildColorToolbar() {
    return Positioned(
      top: 40,
      right: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          buildClearButton(),
          const Divider(height: 10),
          buildSaveButton(),
          const Divider(height: 20),
          _buildColorButton(Colors.red),
          _buildColorButton(Colors.blueAccent),
          _buildColorButton(Colors.deepOrange),
          _buildColorButton(Colors.green),
          _buildColorButton(Colors.lightBlue),
          _buildColorButton(Colors.black),
          _buildColorButton(Colors.white),
        ],
      ),
    );
  }

  Widget _buildStrokeToolbar() {
    return Positioned(
      bottom: 20,
      right: 10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildStrokeButton(5.0),
          _buildStrokeButton(10.0),
          _buildStrokeButton(15.0),
        ],
      ),
    );
  }

  Widget _buildStrokeButton(double strokeWidth) {
    return GestureDetector(
      onTap: () {
        selectedWidth = strokeWidth;
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          width: strokeWidth * 2,
          height: strokeWidth * 2,
          decoration: BoxDecoration(
              color: selectedColor, borderRadius: BorderRadius.circular(20.0)),
        ),
      ),
    );
  }

  Widget _buildColorButton(Color color) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: FloatingActionButton(
        heroTag: color.value.toString(),
        mini: true,
        backgroundColor: color,
        child: Container(),
        onPressed: () {
          setState(() {
            selectedColor = color;
          });
        },
      ),
    );
  }

  Widget buildSaveButton() {
    return GestureDetector(
      onTap: save,
      child: const CircleAvatar(
        child: Icon(
          Icons.save,
          size: 20.0,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget buildClearButton() {
    return GestureDetector(
      onTap: clear,
      child: const CircleAvatar(
        child: Icon(
          Icons.create,
          size: 20.0,
          color: Colors.white,
        ),
      ),
    );
  }
}
