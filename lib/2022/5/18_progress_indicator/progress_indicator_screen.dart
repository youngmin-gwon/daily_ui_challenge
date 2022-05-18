import 'package:flutter/material.dart';

class ProgressIndicatorScreen extends StatelessWidget {
  const ProgressIndicatorScreen({Key? key}) : super(key: key);

  void showLoadingIndicator(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: const AlertDialog(
            content: LoadingIndicator(),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        );
      },
    );
  }

  Future<void> _onPressed(BuildContext context) async {
    showLoadingIndicator(context);
    await Future.delayed(const Duration(milliseconds: 2000), () {});
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: const Center(
        child: Text("Hello"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _onPressed(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.black.withOpacity(0.8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _getLoadingIndicator(),
          _getHeading(),
          _getText("Loading...")
        ],
      ),
    );
  }

  Widget _getLoadingIndicator() {
    return const SizedBox(
      child: CircularProgressIndicator(strokeWidth: 3),
      width: 32,
      height: 32,
    );
  }

  Widget _getHeading() {
    return const Text(
      'Please wait …',
      style: TextStyle(color: Colors.white, fontSize: 16),
      textAlign: TextAlign.center,
    );
  }

  Text _getText(String displayedText) {
    return Text(
      displayedText,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      textAlign: TextAlign.center,
    );
  }
}
