import 'package:daily_ui/2022/1/25/child1_page.dart';
import 'package:daily_ui/2022/1/25/child2_page.dart';
import 'package:daily_ui/2022/1/25/parent_provider.dart';
import 'package:flutter/material.dart';

class ParentPage extends StatefulWidget {
  const ParentPage({Key? key}) : super(key: key);

  @override
  _ParentPageState createState() => _ParentPageState();
}

class _ParentPageState extends State<ParentPage>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  String myTitle = "My Parent Title";
  String child1title = "Child 1";
  String child2title = "Child 2";

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void updateChild1Title() {
    setState(() {
      child1title = "Update from Parent";
    });
  }

  void updateChild2Title(String text) {
    setState(() {
      child2title = text;
    });
  }

  void _updateMyTitle(String text) {
    setState(() {
      myTitle = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: const Color(0xFF4F4747),
      body: ParentProvider(
        childTitle1: child1title,
        childTitle2: child2title,
        tabController: _controller,
        child: Column(
          children: [
            ListTile(
              title: Text(
                myTitle,
                textAlign: TextAlign.center,
              ),
            ),
            ElevatedButton(
              onPressed: updateChild1Title,
              child: const Text("Action 1"),
            ),
            TabBar(
              controller: _controller,
              tabs: const [
                Tab(
                  text: "First",
                  icon: Icon(Icons.check_circle),
                ),
                Tab(
                  text: "Second",
                  icon: Icon(Icons.crop_square),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _controller,
                children: [
                  Child1Page(
                    parentAction: _updateMyTitle,
                    child2Action: updateChild2Title,
                  ),
                  const Child2Page(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
