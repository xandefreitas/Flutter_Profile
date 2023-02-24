import 'package:flutter/material.dart';

class CustomMagnifier extends StatefulWidget {
  final Widget child;
  const CustomMagnifier({super.key, required this.child});

  @override
  State<CustomMagnifier> createState() => _CustomMagnifierState();
}

class _CustomMagnifierState extends State<CustomMagnifier> {
  Offset dragGesturePosition = Offset.zero;
  bool _showMagnifier = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onPanDown: _addMagnifier,
          onPanUpdate: _updateMagnifier,
          onPanEnd: _removeMagnifier,
          onPanCancel: _cancelMagnifier,
          child: widget.child,
        ),
        if (_showMagnifier)
          Positioned(
            left: dragGesturePosition.dx - 52,
            top: dragGesturePosition.dy - 64,
            child: const RawMagnifier(
              size: Size(104, 64),
              magnificationScale: 1.2,
              decoration: MagnifierDecoration(shape: CircleBorder()),
            ),
          ),
      ],
    );
  }

  _addMagnifier(DragDownDetails details) => setState(
        () {
          dragGesturePosition = details.localPosition;
          _showMagnifier = true;
        },
      );
  _updateMagnifier(DragUpdateDetails details) => setState(
        () {
          dragGesturePosition = details.localPosition;
        },
      );
  _removeMagnifier(DragEndDetails details) => setState(
        () {
          _showMagnifier = false;
        },
      );
  _cancelMagnifier() => setState(
        () {
          _showMagnifier = false;
        },
      );
}
