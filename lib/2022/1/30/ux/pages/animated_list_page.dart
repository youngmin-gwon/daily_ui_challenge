import 'package:daily_ui/2022/1/30/models/phrase_model.dart';
import 'package:daily_ui/2022/1/30/states/phrases_provider.dart';
import 'package:daily_ui/2022/1/30/ux/widgets/liked_phrases_widget.dart';
import 'package:daily_ui/2022/1/30/ux/widgets/menu_popup_button.dart';
import 'package:daily_ui/2022/1/30/ux/widgets/menu_transition_example.dart';
import 'package:daily_ui/2022/1/30/ux/widgets/phase_list_item.dart';
import 'package:daily_ui/2022/1/30/ux/widgets/rotate_scale_transition.dart';
import 'package:flutter/material.dart';

class AnimatedListPage extends StatefulWidget {
  const AnimatedListPage({
    Key? key,
    required this.onThemeModeChanged,
  }) : super(key: key);

  final void Function(bool) onThemeModeChanged;

  @override
  _AnimatedListPageState createState() => _AnimatedListPageState();
}

class _AnimatedListPageState extends State<AnimatedListPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _menuAnimation;

  late ScrollController _scrollController;

  final _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _menuAnimation = CurvedAnimation(parent: _controller, curve: Curves.ease);

    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onMenuPressed() {
    if (_controller.status == AnimationStatus.dismissed) {
      _controller.forward();
    } else if (_controller.status == AnimationStatus.completed) {
      _controller.reverse();
    } else if (_controller.status == AnimationStatus.forward) {
      _controller.reverse();
    } else if (_controller.status == AnimationStatus.reverse) {
      _controller.forward();
    }
  }

  void _addRandomItemToList() {
    setState(() {
      PhrasesProvider.of(context).addRandomItemToList();
      _listKey.currentState!.insertItem(PhrasesProvider.of(context).length - 1);
      _scrollListToBottom();
    });
  }

  void _addItemToList(PhraseModel phrase, int index) {
    setState(() {
      PhrasesProvider.of(context).addItemToList(phrase, index);
      _listKey.currentState!.insertItem(index);
    });
  }

  void _removeItemFromList(int index) {
    setState(() {
      PhrasesProvider.of(context).removeItemFromList(index);
      _listKey.currentState!
          .removeItem(index, (_, animation) => const SizedBox());
    });
  }

  void _scrollListToBottom() {
    Future.delayed(
      const Duration(milliseconds: 300),
      () {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200), curve: Curves.ease);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Phrase Generator"),
        leading: IconButton(
          onPressed: _onMenuPressed,
          icon: AnimatedIcon(
            progress: _menuAnimation,
            icon: AnimatedIcons.menu_close,
          ),
        ),
        actions: [MenuPopupButton(onThemeChanged: widget.onThemeModeChanged)],
      ),
      floatingActionButton: RotateScaleTransition(
        animation: _menuAnimation,
        child: FloatingActionButton(
          onPressed: _addRandomItemToList,
          child: const Icon(Icons.add),
        ),
      ),
      body: Stack(
        children: [
          AnimatedList(
            controller: _scrollController,
            key: _listKey,
            initialItemCount: PhrasesProvider.of(context).length,
            itemBuilder: (_, index, animation) {
              return ScaleTransition(
                scale: animation.drive(
                  CurveTween(curve: Curves.easeOut),
                ),
                child: PhraseListItem(
                  phraseModel: PhrasesProvider.of(context).phrases[index],
                  undoPressed: _addItemToList,
                  index: index,
                  onDismissed: (direction, index) {
                    _removeItemFromList(index);
                  },
                ),
              );
            },
          ),
          MenuTransitionExample(
            animation: _controller.view,
            child: const LikedPhrasesWidget(),
          ),
        ],
      ),
    );
  }
}
