import 'package:daily_ui/2022/4/10_stacked_cards/models/contact.dart';
import 'package:daily_ui/2022/4/10_stacked_cards/ui/contact_card.dart';
import 'package:daily_ui/2022/4/10_stacked_cards/ui/perspective_list_view.dart';
import 'package:flutter/material.dart';

class StackedCardScreen extends StatelessWidget {
  const StackedCardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xff23202a),
        appBarTheme: AppBarTheme(
          color: Colors.deepPurple[400],
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.white70,
          ),
        ),
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.grey[800]),
        ),
        iconTheme: const IconThemeData(color: Colors.grey),
      ),
      child: Scaffold(
        backgroundColor: Colors.black38,
        appBar: AppBar(
          title: const Text("TEMPLATE GALLERY"),
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back),
            )
          ],
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20.0),
          )),
        ),
        body: PerspectiveListView(
          visualizedItems: 8,
          itemExtent: MediaQuery.of(context).size.height * .33,
          initialIndex: 7,
          backItemsShadowColor: Theme.of(context).scaffoldBackgroundColor,
          padding: const EdgeInsets.all(10),
          children: List.generate(Contact.contacts.length, (index) {
            final borderColor = Colors.accents[index % Colors.accents.length];
            final contact = Contact.contacts[index];
            return ContactCard(
              borderColor: borderColor,
              contact: contact,
            );
          }),
        ),
      ),
    );
  }
}
