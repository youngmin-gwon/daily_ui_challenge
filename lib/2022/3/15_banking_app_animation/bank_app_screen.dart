import 'package:daily_ui/2022/3/15_banking_app_animation/add_card.dart';
import 'package:daily_ui/2022/3/15_banking_app_animation/profile_section.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class BankAppScreen extends StatefulWidget {
  const BankAppScreen({Key? key}) : super(key: key);

  @override
  State<BankAppScreen> createState() => _BankAppScreenState();
}

class _BankAppScreenState extends State<BankAppScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;

  double _page = 1;
  double _pageClamp = 1;

  late Size size;

  Duration defaultDuration = const Duration(milliseconds: 300);

  double verPos = 0.0;

  void _pageListener() {
    setState(() {
      _page = _pageController.page!;
      _pageClamp = _page.clamp(0, 1);
    });
  }

  void _onVerticalDrag(DragUpdateDetails details) {
    setState(() {
      verPos += details.primaryDelta!;
      verPos = verPos.clamp(0, double.infinity);
    });
  }

  void _onVerticalDragEnds(DragEndDetails details) {
    setState(() {
      if (details.primaryVelocity! > 500 || verPos > size.height / 2) {
        verPos = size.height - 40;
      }

      if (details.primaryVelocity! < -500 || verPos < size.height / 2) {
        verPos = 0;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.8,
      initialPage: 1,
    )..addListener(_pageListener);
  }

  @override
  void dispose() {
    _pageController.removeListener(_pageListener);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          // Add Card background
          Positioned(
            top: _pageClamp * size.height * .275 + verPos,
            bottom: _pageClamp * size.height * .225 - verPos,
            left: _pageClamp * size.width * .1,
            right: _pageClamp * size.width * .2,
            child: Transform.translate(
              offset: Offset(
                _page < 1 ? 0 : (-1 * _page * size.width + size.width),
                0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(_pageClamp * 18),
                ),
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: defaultDuration,
            child: _page < 0.3
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: AddCard(),
                  )
                : null,
          ),
          // Card List
          Positioned(
            top: _page == 0 ? 0 : (size.height * .25) + verPos,
            bottom: _page == 0 ? 0 : size.height * .2 - verPos,
            left: 0,
            right: 0,
            child: ScrollConfiguration(
              behavior: AppScrollBehavior(),
              child: PageView.builder(
                controller: _pageController,
                itemCount: 4,
                itemBuilder: (context, index) {
                  if (_dummyCard[index] == null) {
                    return const SizedBox.shrink();
                  } else {
                    return Transform.translate(
                      offset: Offset(
                        _page < 1 ? (1 - _pageClamp) * 50 : 0,
                        0,
                      ),
                      child: ReceiptCard(
                        background: _dummyCard[index]!.background,
                        logo: _dummyCard[index]!.logo,
                        numbering: _dummyCard[index]!.numbering,
                        price: _dummyCard[index]!.price,
                        textColor: _dummyCard[index]!.textColor,
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          // Profile Card
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            top: MediaQuery.of(context).padding.top - verPos,
            left: (size.width * .1 - verPos).clamp(0, double.infinity),
            right: (size.width * .1 - verPos).clamp(0, double.infinity),
            bottom: size.height * .75 - verPos,
            child: AnimatedSwitcher(
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              duration: const Duration(milliseconds: 150),
              child: _pageClamp < .9
                  ? const SizedBox.shrink()
                  : GestureDetector(
                      onVerticalDragUpdate: _onVerticalDrag,
                      onVerticalDragEnd: _onVerticalDragEnds,
                      child: ProfileSection(
                        verticalPosition: verPos,
                      ),
                    ),
            ),
          ),

          // Expanses Card
          Positioned(
            top: size.height * .85 + verPos,
            left: size.width * .1,
            right: size.width * .1,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 100),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: _pageClamp < .9
                  ? const SizedBox.shrink()
                  : TweenAnimationBuilder<double>(
                      key: Key(_dummyCard[_page.round()]!.expenses.first.title),
                      tween: Tween<double>(begin: 25, end: 0),
                      duration: const Duration(milliseconds: 200),
                      builder: (context, value, _) {
                        return Transform.translate(
                          offset: Offset(0, value),
                          child: ListTile(
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: AssetImage(
                                      _dummyCard[_page.round()]!
                                          .expenses
                                          .first
                                          .image,
                                    ),
                                    filterQuality: FilterQuality.medium,
                                    fit: BoxFit.fill,
                                  )),
                            ),
                            title: Text(_dummyCard[_page.round()]!
                                .expenses
                                .first
                                .title),
                            subtitle: Text(_dummyCard[_page.round()]!
                                .expenses
                                .first
                                .description),
                            trailing: Text(
                              '\$${_dummyCard[_page.round()]!.expenses.first.amount.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.headline6,
                            ),
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

/// Bank Card
class ReceiptCard extends StatelessWidget {
  const ReceiptCard({
    Key? key,
    required this.background,
    required this.logo,
    required this.numbering,
    required this.price,
    this.textColor,
  }) : super(key: key);

  final String background;
  final String logo;
  final String numbering;
  final double price;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        image: DecorationImage(
          image: AssetImage(
            background,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                logo,
                height: 25,
                fit: BoxFit.cover,
                isAntiAlias: true,
                filterQuality: FilterQuality.medium,
              ),
              Text(
                numbering,
                style: Theme.of(context).textTheme.headline4?.copyWith(
                      color: textColor,
                    ),
              )
            ],
          ),
          Text(
            '\$$price'.replaceAllMapped(
              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
              (Match m) => '${m[1]},',
            ),
            style: Theme.of(context).textTheme.headline4?.copyWith(
                  color: textColor,
                ),
          )
        ],
      ),
    );
  }
}

const _dummyCard = <_CardModel?>[
  null,
  _CardModel(
    background: 'assets/images/wallpaper1.jpg',
    logo: 'assets/images/citi_logo.png',
    numbering: '7405',
    price: 2032.80,
    textColor: Color(0xFF004380),
    expenses: [
      _ExpanseModel(
        image: 'assets/images/netflix_logo.jpg',
        title: 'Netflix',
        description: 'Subscription',
        amount: 186,
      ),
    ],
  ),
  _CardModel(
      background: 'assets/images/wallpaper2.jpg',
      logo: 'assets/images/toss_logo.jpg',
      numbering: '3077',
      price: 800.11,
      textColor: Color(0xFF0044f7),
      expenses: [
        _ExpanseModel(
          image: 'assets/images/spotify_logo.png',
          title: 'Spotify',
          description: 'Subscription',
          amount: 123.99,
        ),
      ]),
  _CardModel(
      background: 'assets/images/wallpaper3.jpg',
      logo: 'assets/images/kakao_logo.png',
      numbering: '0923',
      price: 1032.23,
      textColor: Colors.white,
      expenses: [
        _ExpanseModel(
          image: 'assets/images/starbucks_logo.jpg',
          title: 'Starbucks',
          description: 'Ice Americano',
          amount: 98.99,
        ),
      ]),
];

class _CardModel {
  final String background;
  final String logo;
  final String numbering;
  final double price;
  final Color? textColor;
  final List<_ExpanseModel> expenses;

  const _CardModel({
    required this.background,
    required this.logo,
    required this.numbering,
    required this.price,
    this.textColor,
    this.expenses = const [],
  });
}

class _ExpanseModel {
  final String image;
  final String title;
  final String description;
  final double amount;

  const _ExpanseModel({
    required this.image,
    required this.title,
    required this.description,
    required this.amount,
  });
}

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
