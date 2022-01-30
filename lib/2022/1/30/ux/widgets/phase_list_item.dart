import 'package:daily_ui/2022/1/30/models/phrase_model.dart';
import 'package:daily_ui/2022/1/30/states/phrases_provider.dart';
import 'package:daily_ui/2022/1/30/ux/styles/styles.dart';
import 'package:flutter/material.dart';

class PhraseListItem extends StatefulWidget {
  const PhraseListItem({
    Key? key,
    required this.phraseModel,
    required this.index,
    required this.onDismissed,
    required this.undoPressed,
  }) : super(key: key);

  final PhraseModel phraseModel;
  final int index;
  final Function(DismissDirection, int) onDismissed;
  final Function(PhraseModel, int) undoPressed;

  @override
  _PhraseListItemState createState() => _PhraseListItemState();
}

class _PhraseListItemState extends State<PhraseListItem> {
  ValueKey firstIconKey = const ValueKey<String>("like");
  ValueKey secondIconKey = const ValueKey<String>("unlike");

  void _onLikePressed() {
    setState(() {
      PhrasesProvider.of(context).likeItem(widget.index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.phraseModel.phrase),
      onDismissed: (direction) {
        widget.onDismissed.call(direction, widget.index);
        final snackBar = SnackBar(
          content: const Text("Phrase removed"),
          action: SnackBarAction(
            label: "Undo",
            textColor: Theme.of(context).colorScheme.secondary,
            onPressed: () {
              widget.undoPressed.call(widget.phraseModel, widget.index);
            },
          ),
        );
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      background: backgroundGradient(salmon, Colors.transparent),
      secondaryBackground: backgroundGradient(Colors.transparent, mustard),
      child: ListTile(
        title: Text(widget.phraseModel.phrase),
        subtitle: Text("Number: ${widget.index}"),
        trailing: GestureDetector(
          onTap: _onLikePressed,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.ease,
            switchOutCurve: Curves.easeOut,
            child: widget.phraseModel.isLiked
                ? Icon(
                    Icons.favorite,
                    key: firstIconKey,
                    color: salmon,
                  )
                : Icon(
                    Icons.favorite_border_outlined,
                    key: secondIconKey,
                  ),
          ),
        ),
      ),
    );
  }
}
