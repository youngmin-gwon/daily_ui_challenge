import 'package:flutter/material.dart';

class FludListScrollScreen extends StatelessWidget {
  const FludListScrollScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: const _ScrollList(),
    );
  }
}

class _ScrollList extends StatefulWidget {
  const _ScrollList({Key? key}) : super(key: key);

  @override
  State<_ScrollList> createState() => __ScrollListState();
}

class __ScrollListState extends State<_ScrollList> {
  late ScrollController _scrollController;
  var rate = 1.0;
  var old = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollNotification) {
        var current = scrollNotification.metrics.pixels;

        print(current);

        setState(() {
          if (current > 10) {
            rate = (current - old).abs();
            old = current;
          }

          if (scrollNotification.metrics.pixels >=
              scrollNotification.metrics.maxScrollExtent - 50) {
            rate = 0.0;
            print("max");
          }

          if (scrollNotification.metrics.pixels <=
              scrollNotification.metrics.minScrollExtent + 50) {
            rate = 0.0;
            print("min");
          }
        });

        return true;
      },
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        controller: _scrollController,
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return AnimatedPadding(
                  padding: EdgeInsets.only(
                    left: 10.0,
                    right: 10.0,
                    top: ((rate + 10).abs() > 50) ? 50 : (rate + 10).abs(),
                  ),
                  duration: const Duration(milliseconds: 375),
                  curve: Curves.easeOut,
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                );
              },
              childCount: 20,
            ),
          ),
        ],
      ),
    );
  }
}
