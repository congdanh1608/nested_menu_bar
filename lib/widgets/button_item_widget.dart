part of '../nested_menu_bar.dart';

class ButtonItemWidget extends StatefulWidget {
  const ButtonItemWidget({
    required this.menu,
    required this.color,
    required this.hoverColor,
    required this.borderRadius,
    required this.borderColor,
    required this.borderWidth,
    required this.padding,
    required this.foregroundColor,
    required this.hoverForegroundColor,
    super.key,
  });

  final NestedMenuItem menu;

//Button item background color
//!this will effect the background color of the button
  final Color color;
  final Color hoverColor;

//?Button item border customization
//!this will effect the border radius of the button
  final double borderRadius;
  final Color borderColor;
  final double borderWidth;

//?Button item padding
//!this will effect the padding of the button
  final double padding;

//?Button item foreground color
//!this will effect the icon and text color
  final Color foregroundColor;
  final Color hoverForegroundColor;

  @override
  State<ButtonItemWidget> createState() => _ButtonItemWidgetState();
}

class _ButtonItemWidgetState extends State<ButtonItemWidget> {
  bool _isHovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) => setState(() => _isHovered = true),
      onExit: (event) => setState(() => _isHovered = false),
      child: Container(
        padding: EdgeInsets.all(widget.padding),
        decoration: BoxDecoration(
          color: _isHovered ? (widget.hoverColor) : (widget.color),
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(
            color: widget.borderColor,
            width: widget.borderWidth,
          ),
        ),
        child: Row(
          key: widget.menu.key,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (widget.menu.icon != null) ...[
              Icon(
                widget.menu.icon,
                color: _isHovered
                    ? widget.hoverForegroundColor
                    : widget.foregroundColor,
              ),
              const SizedBox(width: 5),
            ],
            Expanded(
              child: Text(
                widget.menu.title,
                style: TextStyle(
                  color: _isHovered
                      ? widget.hoverForegroundColor
                      : widget.foregroundColor,
                ),
                maxLines: 1,
                overflow: TextOverflow.visible,
              ),
            ),
            if (widget.menu.hasChildren && !widget.menu.isBack)
              Icon(Icons.arrow_right,
                  color: _isHovered
                      ? widget.hoverForegroundColor
                      : widget.foregroundColor),
          ],
        ),
      ),
    );
  }
}
