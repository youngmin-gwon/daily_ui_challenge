import 'package:flutter/material.dart';

class NotBoringListViewScreen extends StatefulWidget {
  const NotBoringListViewScreen({Key? key}) : super(key: key);

  @override
  State<NotBoringListViewScreen> createState() =>
      _NotBoringListViewScreenState();
}

class _NotBoringListViewScreenState extends State<NotBoringListViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: 21,
          vertical: 20,
        ),
        itemCount: 100,
        itemBuilder: (context, index) {
          return const NotBoringListItem();
        },
      ),
    );
  }
}

class NotBoringListItem extends StatefulWidget {
  const NotBoringListItem({Key? key}) : super(key: key);

  @override
  State<NotBoringListItem> createState() => _NotBoringListItemState();
}

class _NotBoringListItemState extends State<NotBoringListItem>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _controller;
  static final Tween<double> _scaleTween = Tween<double>(begin: 0.5, end: 1);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleTween
          .chain(CurveTween(curve: Curves.easeInOut))
          .animate(_controller),
      child: Container(
        height: 60,
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: const Color(0xFFBFDFFC),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
