import 'dart:ui';

import 'package:flutter/material.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({
    Key? key,
    required this.verticalPosition,
  }) : super(key: key);

  final double verticalPosition;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFDFDCFD),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                const Center(
                  child: _ProfileHeader(),
                ),
                AnimatedOpacity(
                  opacity: lerpDouble(0, 1,
                      verticalPosition / MediaQuery.of(context).size.height)!,
                  duration: const Duration(milliseconds: 300),
                  child: verticalPosition > 250
                      ? Center(
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const SizedBox(height: 650),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(60),
                                            color: Colors.white,
                                          ),
                                          child: const Icon(
                                            Icons.search,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        const Text(
                                          'Search',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 24),
                                    const _UserAvatar(
                                        image: 'assets/images/user1.png',
                                        name: 'Alexa'),
                                    const SizedBox(width: 24),
                                    const _UserAvatar(
                                        image: 'assets/images/user2.png',
                                        name: 'Aldo'),
                                    const SizedBox(width: 24),
                                    const _UserAvatar(
                                        image: 'assets/images/user3.png',
                                        name: 'John'),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                Container(
                                  height: 150,
                                  padding: const EdgeInsets.all(30),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: const Color(0xFFa5c8fd),
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox.square(
                                        dimension: 90,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 30),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 20,
                                              vertical: 9,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              color:
                                                  Colors.white.withOpacity(.5),
                                            ),
                                            child: Text(
                                              'Holiday Goal',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black
                                                        .withOpacity(.5),
                                                  ),
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          RichText(
                                            text: TextSpan(
                                              text: '\$1000',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontSize: 20,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: '  \$200',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black
                                                        .withOpacity(.5),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        leading: Icon(
                                          Icons.credit_card,
                                          color: Colors.black87,
                                          size: 30,
                                        ),
                                        title: Text(
                                          "Pay for services",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      ListTile(
                                        leading: Icon(
                                          Icons.money_rounded,
                                          color: Colors.black87,
                                          size: 30,
                                        ),
                                        title: Text(
                                          "Take a loan",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        trailing: Chip(label: Text("4%")),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(24),
                                        child: Icon(
                                          Icons.more_horiz,
                                          size: 30,
                                          color: Colors.black54,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 5,
          width: 50,
          margin: const EdgeInsets.symmetric(
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade800,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            text: 'Hello',
            style: Theme.of(context).textTheme.headline5,
            children: [
              TextSpan(
                text: ' Madrigal',
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 75,
          height: 50,
          child: Stack(
            children: const [
              Align(
                alignment: Alignment.centerLeft,
                child: CircleAvatar(
                  radius: 25,
                  foregroundImage: AssetImage(
                    'assets/images/profile.jpeg',
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: CircleAvatar(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.credit_card_outlined),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar({
    Key? key,
    required this.image,
    required this.name,
  }) : super(key: key);

  final String image;
  final String name;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          foregroundImage: AssetImage(
            image,
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Text(
          name,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
