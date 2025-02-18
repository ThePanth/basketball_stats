import 'dart:async';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class FloatingButtonData {
  String text;
  VoidCallback action;

  FloatingButtonData({required this.text, required this.action});
}

class FloatingButton extends StatefulWidget {
  FloatingButton({Key? key}) : super(key: key);
  void addFloadButton() {}
  @override
  FloatingButtonState createState() => FloatingButtonState();
}

class FloatingButtonState extends State<FloatingButton> {
  final Map<String, FloatingButtonData> _floatingButtons = {};
  final Uuid _uuid = Uuid();

  void _tempButtonClick(String buttonId) {
    _floatingButtons[buttonId]!.action();
    setState(() {
      _floatingButtons.removeWhere((id, _) => id == buttonId);
    });
  }

  void addTemporaryButton(FloatingButtonData data) {
    String buttonId = _uuid.v4();
    setState(() {
      _floatingButtons[buttonId] = data;
    });
    Timer(Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _floatingButtons.removeWhere((id, _) => id == buttonId);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final test = Align(
      alignment: Alignment.bottomRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children:
            _floatingButtons.keys
                .map(
                  (id) => Container(
                    margin: EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                      onPressed: () => _tempButtonClick(id),
                      child: Text(_floatingButtons[id]!.text),
                    ),
                  ),
                )
                .toList(),
      ),
    );

    return test;
  }
}
