import 'package:flutter/material.dart';

class AnimateInstructText extends StatefulWidget {
  const AnimateInstructText({
    super.key,
    required this.text,
    this.style,
    required this.index,
  });

  final String text;
  final TextStyle? style;
  final int index;

  @override
  State<AnimateInstructText> createState() => _AnimateInstructTextState();
}

class _AnimateInstructTextState extends State<AnimateInstructText> {
  var isStart = false;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((timeStamp) {
      isStart = true;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: Offset(isStart ? 0 : 1, 0),
      duration: Duration(milliseconds: (widget.index + 1) * 200),
      curve: Curves.easeInOut,
      child: AnimatedOpacity(
        opacity: isStart ? 1 : 0,
        curve: Curves.easeInOut,
        duration: Duration(milliseconds: (widget.index + 1) * 200),
        child: Text(
          widget.text,
          style: widget.style ??
              const TextStyle(color: Colors.black, fontSize: 14),
        ),
      ),
    );
  }
}