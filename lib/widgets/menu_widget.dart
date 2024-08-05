part of '../nested_menu_bar.dart';

class MenuWidget extends StatefulWidget {
  final NestedMenuItem menu;

  final String goBackButtonText;

  final bool showBackButton;

  final double height;

  // final Color backgroundColor;

  final NestedMenuItemStyle style;

  final NestedMenuBarMode mode;

  final GlobalKey<State<StatefulWidget>>? selectedMenuKey;

  final void Function(GlobalKey<State<StatefulWidget>>? key)?
  setSelectedMenuKey;

  //pop up menu item properties
  final Color? popUpMenuItemBackgroundColor;
  final Color? popUpMenuItemHoverBackgroundColor;

  final double? popUpMenuItemBorderRadius;
  final Color? popUpMenuItemBorderColor;
  final double? popUpMenuItemBorderWidth;
  final double? popUpMenuItemPadding;

  final Color? popUpMenuItemForegroundColor;
  final Color? popUpMenuItemHoverForegroundColor;

  //menu pop up properties
  final double? popUpPadding;
  final BoxDecoration? popUpDecoration;

  //menu bar menu properties
  final Color? menuBarItemColor;
  final Color? menuBarItemHoverColor;


  MenuWidget(
      this.menu, {
        required this.goBackButtonText,
        required this.showBackButton,
        required this.height,
        // required this.backgroundColor,
        required this.style,
        required this.mode,
        this.selectedMenuKey,
        this.setSelectedMenuKey,
      //pop up menu items properties
        this.popUpMenuItemBackgroundColor,
        this.popUpMenuItemHoverBackgroundColor,
        this.popUpMenuItemBorderRadius,
        this.popUpMenuItemBorderColor,
        this.popUpMenuItemBorderWidth,
        this.popUpMenuItemPadding,
        this.popUpMenuItemForegroundColor,
        this.popUpMenuItemHoverForegroundColor,

        //pop up menu properties
        this.popUpPadding,
        this.popUpDecoration,

        //menu bar menu properties
        this.menuBarItemColor,
        this.menuBarItemHoverColor

      }) : super(key: menu.key);

  @override
  State<MenuWidget> createState() => MenuWidgetState();
}

class MenuWidgetState extends State<MenuWidget> {
  bool _disposed = false;

  final SplayTreeMap<String, OverlayEntry> _popups = SplayTreeMap();

  final Set<String> _hoveredPopupKey = {};

  bool get enabledSelectedTopMenu => widget.style.enableSelectedTopMenu;

  bool get isSelectedMenu =>
      enabledSelectedTopMenu && widget.selectedMenuKey == widget.menu.key;

  Color get iconColor {
    return isSelectedMenu
        ? widget.style.selectedTopMenuIconColor
        : widget.style.iconColor;
  }

  TextStyle get textStyle {
    return isSelectedMenu
        ? widget.style.selectedTopMenuTextStyle
        : widget.style.textStyle;
  }
  

  @override
  void dispose() {
    _disposed = true;

    _hoveredPopupKey.clear();
    _popups.forEach((k, v) => v.remove());
    _popups.clear();

    super.dispose();
  }

  void openMenu(NestedMenuItem menu) async {
    if (widget.menu.onTap != null) {
      widget.menu.onTap!();
    }

    if (widget.menu.hasChildren) {
      showSubMenu(widget.menu);
    }
  }

  void showSubMenu(NestedMenuItem menu) async {
    if (!menu.hasChildren) return;
    if (_disposed) return;

    switch (widget.mode) {
      case NestedMenuBarMode.hover:
        _showHoveredPopupMenu(context,
        menu: menu,
          menuItems:  menu.children!,
        decoration:  widget.popUpDecoration,
        padding: widget.popUpPadding??0,
        );
        break;
      case NestedMenuBarMode.tap:
        _showTappedPopupMenu(menu, context, menu.children!);
        break;
    }
  }

  void _showHoveredPopupMenu(
      BuildContext context,
    {  
      required NestedMenuItem menu,
     required List<NestedMenuItem> menuItems,
      required BoxDecoration? decoration,
      required double padding,
      }
) {
    if (_disposed) return;
    if (_popups.containsKey(menu.key.toString())) return;
    if (!menu.hasContext) return;

    final RenderBox overlay =
    Overlay.of(context).context.findRenderObject() as RenderBox;

    const double itemMinWidth = 150.0;
    const double itemMinHeight = 43.0;
    final Offset menuPosition = menu.position - const Offset(0, 1);
    final Size menuSize = menu.size;
    final bool rootMenu = menu.parent == null;
    final Offset positionOffset =
    rootMenu ? Offset(0, widget.height) : Offset(menuSize.width - 10, 10);

    Offset position = menuPosition + positionOffset;
    double? top = position.dy;
    double? left = position.dx;
    double? right;
    double? bottom;

    if (position.dx + itemMinWidth > overlay.size.width) {
      if (rootMenu) {
        left = null;
        right = 0;
      } else {
        left = null;
        right = overlay.size.width - menuPosition.dx;
        if (right + menuSize.width >= overlay.size.width) {
          top = menuPosition.dy + 30;
          bottom = null;
          left = menuPosition.dx <= 15 ? menuPosition.dx + 10 : 0;
          right = null;
        }
      }
    }

    if (position.dy + itemMinHeight * menuItems.length > overlay.size.height) {
      if (rootMenu) {
        top = null;
        bottom = 0;
      } else {
        top = null;
        bottom = overlay.size.height - menuPosition.dy;
        if (bottom + menuSize.height >= overlay.size.height) {
          top = menuPosition.dy + 30;
          bottom = null;
          top = menuPosition.dy <= 15 ? menuPosition.dy + 10 : 0;
          bottom = null;
        }
      }
    }
      
    _popups[menu.key.toString()] = OverlayEntry(
      builder: (_) {
        Widget buildItemWidget(NestedMenuItem item) {
          Widget menuItemWidget = _ItemWidget(
            menu: item,
            iconScale: widget.style.iconScale,
            unselectedColor: widget.style.unselectedColor,
            activatedColor: widget.style.activatedColor,
            indicatorColor: widget.style.indicatorColor,
            menuIconColor: widget.style.iconColor,
            moreIconColor: widget.style.moreIconColor,
            menuIconSize: widget.style.iconSize,
            
            //pop up menu item properties
            popUpMenuItemBackgroundColor: widget.popUpMenuItemBackgroundColor,
            popUpMenuItemHoverBackgroundColor: widget.popUpMenuItemHoverBackgroundColor,
            popUpMenuItemBorderRadius: widget.popUpMenuItemBorderRadius,
            popUpMenuItemBorderColor: widget.popUpMenuItemBorderColor,
            popUpMenuItemBorderWidth: widget.popUpMenuItemBorderWidth,
            popUpMenuItemPadding: widget.popUpMenuItemPadding,
            popUpMenuItemForegroundColor: widget.popUpMenuItemForegroundColor,
            popUpMenuItemHoverForegroundColor: widget.popUpMenuItemHoverForegroundColor,
        
          );

          if (item.type.isDivider) return menuItemWidget;

          EdgeInsets padding;
          if (item.type.isCheckbox || item.type.isRadio) {
            padding = const EdgeInsets.symmetric(vertical: 10);
          } else {
            padding = EdgeInsets.zero;
          }

          menuItemWidget = InkWell(
            onTap: () {
              if (item.onTap != null) {
                item.onTap!();
              }
            },
            child: Padding(padding: padding, child: menuItemWidget),
          );

          if (!item.hasChildren) return menuItemWidget;

          onHoverItem(_) {
            _addHoveredPopupKey(item);
            _showSubMenuDelay(item);
          }

          onExitItem(_) {
            _removeHoveredPopupKey(item);
          }

          return MouseRegion(
            onHover: onHoverItem,
            onExit: onExitItem,
            child: menuItemWidget,
          );
        }

        onHover(_) { 
          // isHovered=true;
          _addHoveredPopupKey(menu);}

        onExit(_) {
          // isHovered=false;
          _removeHoveredPopupKey(menu);
          }

        //final menuItemWidgets = menuItems.map(buildItemWidget).toList();

        return Positioned(
          top: top,
          // left: left!+35,
          left: left!+20,
          right: right,
          bottom: bottom,
          child: ClipRRect(
          borderRadius:decoration?.borderRadius?? BorderRadius.circular(0),
            child: Material(
              child: Container(
                padding: EdgeInsets.all(padding),
                decoration:decoration??const BoxDecoration(color: Colors.white,),
                  child: MouseRegion(
                    onHover: onHover,
                    onExit: onExit,
                    child: IntrinsicWidth(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for(var menu in menuItems) ...{
                              buildItemWidget(menu),
                            },
                          ],
                        ),
                      ),
                    ),
                  ),
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context).insert(_popups[menu.key.toString()]!);
  }

  void _showTappedPopupMenu(
      NestedMenuItem menu,
      BuildContext context,
      List<NestedMenuItem> menuItems,
) {
    if (_disposed) return;
    if (!menu.hasContext) return;
    final items = [...menuItems];

    if (widget.mode.isTap && widget.showBackButton && !menu.isRootSubMenu) {
      final backButton = NestedMenuItem.back(
        title: widget.goBackButtonText,
        children: items.first.parent?.parent?.children,
      );
      backButton.parent = items.first.parent?.parent?.parent;
      items.add(backButton);
    }

    final RenderBox overlay =
    Overlay.of(context).context.findRenderObject() as RenderBox;

    final Offset position = widget.menu.position + Offset(0, widget.height - 1);

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx+35,
        position.dy,
        position.dx + overlay.size.width,
        position.dy + overlay.size.height,
      ),
      items: items.map((menu) {
        Widget menuItem = _ItemWidget(
          menu: menu,
          iconScale: widget.style.iconScale,
          unselectedColor: widget.style.unselectedColor,
          activatedColor: widget.style.activatedColor,
          indicatorColor: widget.style.indicatorColor,
          menuIconColor: widget.style.iconColor,
          moreIconColor: widget.style.moreIconColor,
          menuIconSize: widget.style.iconSize,

          //pop up menu item properties
          popUpMenuItemBackgroundColor: widget.popUpMenuItemBackgroundColor,
          popUpMenuItemHoverBackgroundColor: widget.popUpMenuItemHoverBackgroundColor,
          popUpMenuItemBorderRadius: widget.popUpMenuItemBorderRadius,
          popUpMenuItemBorderColor: widget.popUpMenuItemBorderColor,
          popUpMenuItemBorderWidth: widget.popUpMenuItemBorderWidth,
          popUpMenuItemPadding: widget.popUpMenuItemPadding,
          popUpMenuItemForegroundColor: widget.popUpMenuItemForegroundColor,
          popUpMenuItemHoverForegroundColor: widget.popUpMenuItemHoverForegroundColor,
        );

        double height = kMinInteractiveDimension;
        EdgeInsets? padding;
        if (menu.type.isDivider) {
          height = (menu as NestedMenuItemDivider).height;
          padding = const EdgeInsets.only(left: 0, right: 0);
        }

        return PopupMenuItem<NestedMenuItem>(
          value: menu,
          enabled: menu.enable,
          height: height,
          padding: padding,
          child: menuItem,
        );
      }).toList(growable: false),
      elevation: 2.0,
      color: widget.popUpDecoration?.color??Colors.white,
      useRootNavigator: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.popUpMenuItemBorderRadius??8), // Set desired border radius
      ),
    ).then((selectedMenu) async {
      if (selectedMenu == null) return;

      if (selectedMenu.hasChildren) {
        _showTappedPopupMenu(selectedMenu, context, selectedMenu.children!);
        return;
      }

      if (selectedMenu.onTap != null) {
        selectedMenu.onTap!();
      }
    });
  }


  void _addHoveredPopupKey(NestedMenuItem menu, {bool addSelf = true}) {
    if (addSelf) _hoveredPopupKey.add(menu.key.toString());

    var current = menu.parent;
    while (current != null) {
      _hoveredPopupKey.add(current.key.toString());
      current = current.parent;
    }
  }

  void _showSubMenuDelay(NestedMenuItem menu) {
    Future.delayed(const Duration(milliseconds: 50), () {
      showSubMenu(menu);
    });
  }

  void _removeHoveredPopupKey(NestedMenuItem menu) {
    _hoveredPopupKey.clear();

    Future.delayed(const Duration(milliseconds: 60), () {
      if (!_hoveredPopupKey.contains(menu.key.toString())) {
        _popups[menu.key.toString()]?.remove();
        _popups.remove(menu.key.toString());
      }

      if (_hoveredPopupKey.isEmpty) {
        _popups.forEach((k, v) => v.remove());
        _popups.clear();
      }
    });
  }

  void _setSelectedMenuKey() {
    if (!enabledSelectedTopMenu) return;

    bool? resolved = true;

    if (widget.style.selectedTopMenuResolver != null) {
      resolved = widget.style.selectedTopMenuResolver!(
        widget.menu,
        widget.selectedMenuKey == null
            ? null
            : widget.menu.key == widget.selectedMenuKey,
      );
    }

    if (resolved == false) return;

    widget.setSelectedMenuKey!(resolved == null ? null : widget.menu.key);
  }

  @override
  Widget build(BuildContext context) {
    
    Widget menuWidget = InkWell(
      onTap: () async {
        _setSelectedMenuKey();

        openMenu(widget.menu);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // if (widget.menu.icon != null) ...[
          //   Icon(
          //     widget.menu.icon,
          //     color: iconColor,
          //     size: widget.style.iconSize,
          //   ),
          //   const SizedBox(width: 5),
          // ],
          // Text(widget.menu.title, style: textStyle),
          _AppBarMenuItem(
            menu: widget.menu,
            color: widget.menuBarItemColor??Colors.black,
            hoverColor: widget.menuBarItemHoverColor??Colors.blue,
          ),
        ],
      ),
    );

    if (widget.mode.isHover) {
      onHover(event) {
        _hoveredPopupKey.clear();

        if (!widget.menu.hasChildren) return;

        _addHoveredPopupKey(widget.menu, addSelf: false);

        _showSubMenuDelay(widget.menu);
      }

      onExit(event) => _removeHoveredPopupKey(widget.menu);

      menuWidget = MouseRegion(
        onHover: onHover,
        onExit: onExit,
        child: menuWidget,
      );
    }

    return SizedBox(
      height: widget.height,
      child: Padding(
        padding: widget.style.padding,
        child: menuWidget,
      ),
    );
  }
}


class _AppBarMenuItem extends StatefulWidget {
  const _AppBarMenuItem({
    required this.menu,
    required this.color,
    required this.hoverColor,
  });

  final NestedMenuItem menu;
  final Color color;
  final Color hoverColor;



  @override
  State<_AppBarMenuItem> createState() => __AppBarMenuItemState();
}

class __AppBarMenuItemState extends State<_AppBarMenuItem> {
  bool _isHovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) => setState(() => _isHovered = true),
      onExit: (event) => setState(() => _isHovered = false),
      child: Row(
        children: [
            Icon(widget.menu.icon,
                color: _isHovered ? widget.hoverColor : widget.color,
              ),
            const SizedBox(width: 5),
            Text(widget.menu.title, style: TextStyle(
              color: _isHovered ? widget.hoverColor : widget.color,
            )),
        ],
      ),
    );
  }
}


class _ItemWidget extends StatelessWidget {


  final NestedMenuItem menu;

  final double iconScale;

  final Color unselectedColor;

  final Color activatedColor;

  final Color indicatorColor;

  final Color menuIconColor;

  final Color moreIconColor;

  final double menuIconSize;


  //pop up menu item properties
  final Color? popUpMenuItemBackgroundColor;
  final Color? popUpMenuItemHoverBackgroundColor;

  final double? popUpMenuItemBorderRadius;
  final Color? popUpMenuItemBorderColor;
  final double? popUpMenuItemBorderWidth;
  final double? popUpMenuItemPadding;

  final Color? popUpMenuItemForegroundColor;
  final Color? popUpMenuItemHoverForegroundColor;


    const _ItemWidget({
    required this.menu,
    required this.iconScale,
    required this.unselectedColor,
    required this.activatedColor,
    required this.indicatorColor,
    required this.menuIconColor,
    required this.moreIconColor,
    required this.menuIconSize,
    //pop up menu item properties
    this.popUpMenuItemBackgroundColor,
    this.popUpMenuItemHoverBackgroundColor,
    this.popUpMenuItemBorderRadius,
    this.popUpMenuItemBorderColor,
    this.popUpMenuItemBorderWidth,
    this.popUpMenuItemPadding,
    this.popUpMenuItemForegroundColor,
    this.popUpMenuItemHoverForegroundColor,
  });

  @override
  Widget build(BuildContext context) {

    switch (menu.type) {
      case NestedMenuItemType.button:
        return ButtonItemWidget(
          menu: menu,
          color:popUpMenuItemBackgroundColor?? Colors.white,
          hoverColor: popUpMenuItemHoverBackgroundColor??Colors.blue,
          borderRadius: popUpMenuItemBorderRadius?? 0,
          borderColor: popUpMenuItemBorderColor??Colors.transparent,
          borderWidth: popUpMenuItemBorderWidth??0,
          padding: popUpMenuItemPadding??10,
          foregroundColor: popUpMenuItemForegroundColor??Colors.black,
          hoverForegroundColor: popUpMenuItemHoverForegroundColor??Colors.white,
        );
      case NestedMenuItemType.checkbox:
        return CheckboxItemWidget(
          menu: menu as NestedMenuItemCheckbox,
          iconScale: iconScale,
          unselectedColor: unselectedColor,
          activatedColor: menuIconColor,
          indicatorColor: indicatorColor,
          moreIconColor: moreIconColor,
          textStyle: const TextStyle(color: Colors.black,fontSize: 14,),
        );
      case NestedMenuItemType.radio:
        return RadioItemWidget(
          menu: menu as NestedMenuItemRadio,
          iconScale: iconScale,
          activatedColor: activatedColor,
          unselectedColor: unselectedColor,
          textStyle: const TextStyle(color: Colors.black,fontSize: 14,),
        );
      case NestedMenuItemType.widget:
        return (menu as NestedMenuItemWidget).widget;
      case NestedMenuItemType.divider:
        final dividerItem = menu as NestedMenuItemDivider;
        return Divider(
          color: dividerItem.color,
          indent: dividerItem.indent,
          endIndent: dividerItem.endIndent,
          thickness: dividerItem.thickness,
        );
    }
  }
}


