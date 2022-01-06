import 'package:daily_ui/2022/1/6/constants.dart';
import 'package:flutter/material.dart';

class CardsStack extends StatelessWidget {
  const CardsStack({
    Key? key,
    required this.pageNumber,
    required this.lightCardChild,
    required this.darkCardChild,
  }) : super(key: key);

  final int pageNumber;
  final Widget lightCardChild;
  final Widget darkCardChild;

  bool get isOddPageNumber => pageNumber % 2 == 1;

  @override
  Widget build(BuildContext context) {
    final darkCardWidth = MediaQuery.of(context).size.width - 2 * kPaddingL;
    final darkCardHeight = MediaQuery.of(context).size.height / 3;

    return Padding(
      padding: EdgeInsets.only(
        top: isOddPageNumber ? 25 : 50,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: AlignmentDirectional.center,
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            color: kDarkBlue,
            child: Container(
              width: darkCardWidth,
              height: darkCardHeight,
              padding: EdgeInsets.only(
                top: isOddPageNumber ? 0 : 100,
                bottom: isOddPageNumber ? 100 : 0,
              ),
              child: Center(
                child: darkCardChild,
              ),
            ),
          ),
          Positioned(
            top: isOddPageNumber ? -25 : null,
            bottom: isOddPageNumber ? null : -25,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: kLightBlue,
              child: Container(
                width: darkCardWidth * 0.8,
                height: darkCardHeight * 0.5,
                padding: const EdgeInsets.symmetric(horizontal: kPaddingM),
                child: Center(
                  child: lightCardChild,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
