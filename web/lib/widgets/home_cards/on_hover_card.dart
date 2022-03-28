import 'package:flutter/cupertino.dart';

/**
 * Used to make animation when hovering a card
 */
class OnHoverCard extends StatefulWidget {
  final Widget child;

  const OnHoverCard({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<OnHoverCard> createState() => _OnHoverCard();
}

class _OnHoverCard extends State<OnHoverCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final hoveredTransform = Matrix4.identity()..scale(1.05);
    final transform = isHovered ? hoveredTransform : Matrix4.identity()
      ..scale(1);
    return MouseRegion(
      onEnter: (event) => onEntered(true),
      onExit: (event) => onEntered(false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: transform,
        child: widget.child,
      ),
    );
  }

  onEntered(bool isHovered) => setState(() {
        this.isHovered = isHovered;
      });
}
