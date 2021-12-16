import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey _key = GlobalKey();
  double? _x, _y;

  // this function is trigger when the user presses the floating button
  void _getOffset(GlobalKey key) {
    RenderBox box = key.currentContext!.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero);
    setState(() {
      _x = position.dx;
      _y = position.dy;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kindacode.com'),
      ),
      body: Center(
        child: Stack(children: [
          Positioned(
            top: 150,
            left: 45,
            child: Container(
              key: _key,
              width: 360,
              height: 200,
              padding: EdgeInsets.all(30),
              color: Colors.amber,
              child: Text(
                _x != null
                    ? "X: $_x, \nY: $_y"
                    : 'Press the button to calculate',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _getOffset(_key), child: Icon(Icons.calculate)),
    );
  }
}
