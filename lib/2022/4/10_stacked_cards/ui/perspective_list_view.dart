import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:daily_ui/2022/4/10_stacked_cards/models/contact.dart';

class PerspectiveListView extends StatefulWidget {
  const PerspectiveListView({
    Key? key,
    required this.children,
    required this.itemExtent,
    required this.visualizedItems,
    this.initialIndex = 0,
    this.padding = const EdgeInsets.all(0.0),
    this.onTapFrontItem,
    this.onChangeItem,
    this.backItemsShadowColor = Colors.transparent,
  }) : super(key: key);

  final List<Widget> children;
  final double itemExtent;
  final int visualizedItems;
  final int initialIndex;
  final EdgeInsetsGeometry padding;
  final ValueChanged<int>? onTapFrontItem;
  final ValueChanged<int>? onChangeItem;
  final Color backItemsShadowColor;

  @override
  State<PerspectiveListView> createState() => _PerspectiveListViewState();
}

class _PerspectiveListViewState extends State<PerspectiveListView> {
  late PageController _pageController;
  late double _pagePercent;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: widget.initialIndex,
      viewportFraction: 1 / widget.visualizedItems,
    );

    _currentIndex = widget.initialIndex;
    _pagePercent = 0.0;
    _pageController.addListener(_pageListener);
  }

  @override
  void dispose() {
    _pageController.removeListener(_pageListener);
    _pageController.dispose();
    super.dispose();
  }

  void _pageListener() {
    _currentIndex = _pageController.page!.floor();
    _pagePercent = (_pageController.page! - _currentIndex).abs();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
        },
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        final height = constraints.maxHeight;
        return Stack(
          children: [
            // Perspective Items
            Padding(
              padding: widget.padding,
              child: _PerspectiveItems(
                heightItem: widget.itemExtent,
                currentIndex: _currentIndex,
                children: widget.children,
                generateItems: widget.visualizedItems - 1,
                pagePercent: _pagePercent,
              ),
            ),
            // Pack Item Shade
            Positioned.fill(
                child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    widget.backItemsShadowColor.withOpacity(.8),
                    widget.backItemsShadowColor.withOpacity(.0),
                  ],
                ),
              ),
            )),
            // Void Page view
            PageView.builder(
              scrollDirection: Axis.vertical,
              controller: _pageController,
              physics: const BouncingScrollPhysics(),
              onPageChanged: (value) {
                if (widget.onChangeItem != null) {
                  widget.onChangeItem!.call(value);
                }
              },
              itemBuilder: (context, index) {
                return const SizedBox();
              },
              itemCount: Contact.contacts.length,
            ),
            // On tap item area
            Positioned.fill(
              top: height - widget.itemExtent,
              child: GestureDetector(
                onHorizontalDragCancel: () {
                  if (widget.onTapFrontItem != null) {
                    widget.onTapFrontItem!.call(_currentIndex);
                  }
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _PerspectiveItems extends StatelessWidget {
  const _PerspectiveItems({
    Key? key,
    required this.generateItems,
    required this.currentIndex,
    required this.heightItem,
    required this.pagePercent,
    required this.children,
  }) : super(key: key);

  final int generateItems;
  final int currentIndex;
  final double heightItem;
  final double pagePercent;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        return Stack(
          fit: StackFit.expand,
          children: List.generate(generateItems, (index) {
            final invertedIndex = (generateItems - 2) - index;
            final indexPlus = index + 1;
            final positionPercent = indexPlus / generateItems;
            final endPositionPercent = index / generateItems;
            return (currentIndex > invertedIndex)
                ? _TransformedItem(
                    child: children[currentIndex - (invertedIndex + 1)],
                    heightItem: heightItem,
                    factorChange: pagePercent,
                    scale: lerpDouble(.5, 1.0, positionPercent)!,
                    endScale: lerpDouble(.5, 1.0, endPositionPercent)!,
                    translateY: (height - heightItem) * positionPercent,
                    endTranslateY: (height - heightItem) * endPositionPercent,
                  )
                : const SizedBox();
          })
            // Hide Bottom Item
            ..add((currentIndex < (children.length - 1)
                ? _TransformedItem(
                    child: children[currentIndex + 1],
                    heightItem: heightItem,
                    factorChange: pagePercent,
                    translateY: height + 20,
                    endTranslateY: (height - heightItem),
                  )
                : const SizedBox()))
            // Static Last Item
            ..insert(
                0,
                (currentIndex > (generateItems - 1)
                    ? _TransformedItem(
                        child: children[currentIndex - generateItems],
                        heightItem: heightItem,
                        factorChange: 1.0,
                        endScale: .5,
                      )
                    : const SizedBox())),
        );
      },
    );
  }
}

class _TransformedItem extends StatelessWidget {
  const _TransformedItem({
    Key? key,
    required this.child,
    required this.heightItem,
    required this.factorChange,
    this.scale = 1.0,
    this.endScale = 1.0,
    this.translateY = 0.0,
    this.endTranslateY = 0.0,
  }) : super(key: key);

  final Widget child;

  final double heightItem;
  final double factorChange;
  final double scale;
  final double endScale;
  final double translateY;
  final double endTranslateY;

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..scale(lerpDouble(scale, endScale, factorChange))
        ..translate(0.0, lerpDouble(translateY, endTranslateY, factorChange)!),
      alignment: Alignment.topCenter,
      child: Align(
        alignment: Alignment.topCenter,
        child:
            SizedBox(height: heightItem, width: double.infinity, child: child),
      ),
    );
  }
}
