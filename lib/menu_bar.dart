part of 'nested_menu_bar.dart';

class NestedMenuBar extends StatefulWidget {
  final List<NestedMenuItem> menus;

  /// Text of the back button. (default. 'Go back')
  final String goBackButtonText;

  /// show the back button (default : true )
  final bool showBackButton;

  /// menu height. (default. '45')
  final double height;

  /// {@macro Nested_menu_item_style}
  final NestedMenuItemStyle itemStyle;

  /// Determines the mode in which the submenu is opened.
  ///
  /// [NestedMenuBarMode.tap] Tap to open a submenu.
  /// [NestedMenuBarMode.hover] Opens a submenu by hovering the mouse.
  final NestedMenuBarMode mode;

  //menu bar properties
  final double? menuBarPadding;
  final Decoration? menuBarDecoration;

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

  NestedMenuBar(
      {super.key,
      required this.menus,
      this.goBackButtonText = 'Go back',
      this.showBackButton = true,
      this.height = 45,
      this.itemStyle = const NestedMenuItemStyle(),
      this.mode = NestedMenuBarMode.hover,

      //menu bar properties
      this.menuBarPadding,
      this.menuBarDecoration,

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
      this.menuBarItemHoverColor})
      : assert(menus.isNotEmpty);

  @override
  State<NestedMenuBar> createState() => _NestedMenuBarState();
}

class _NestedMenuBarState extends State<NestedMenuBar> {
  GlobalKey<State<StatefulWidget>>? _selectedMenuKey;

  bool get enabledSelectedTopMenu => widget.itemStyle.enableSelectedTopMenu;

  @override
  void initState() {
    super.initState();

    _initSelectedTopMenu();
  }

  void _initSelectedTopMenu() {
    if (!enabledSelectedTopMenu) return;
    if (widget.itemStyle.initialSelectedTopMenuIndex == null) return;

    int index = widget.itemStyle.initialSelectedTopMenuIndex!;

    if (index < 0) {
      index = 0;
    } else if (index >= widget.menus.length) {
      index = widget.menus.length - 1;
    }
    _selectedMenuKey = widget.menus[index].key;
  }

  void _setSelectedMenuKey(GlobalKey<State<StatefulWidget>>? key) {
    if (!enabledSelectedTopMenu) return;
    setState(() {
      _selectedMenuKey = key;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, size) {
        return Container(
          width: size.maxWidth,
          height: widget.height,
          padding: EdgeInsets.symmetric(horizontal: widget.menuBarPadding ?? 0),
          decoration: widget.menuBarDecoration ??
              const BoxDecoration(color: Colors.white),
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              },
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.menus.length,
              itemBuilder: (_, index) {
                return MenuWidget(
                  widget.menus[index],
                  goBackButtonText: widget.goBackButtonText,
                  showBackButton: widget.showBackButton,
                  height: widget.height,
                  style: widget.itemStyle,
                  mode: widget.mode,
                  selectedMenuKey: _selectedMenuKey,
                  setSelectedMenuKey: _setSelectedMenuKey,

                  //pop up menu item properties
                  popUpMenuItemBackgroundColor:
                      widget.popUpMenuItemBackgroundColor,
                  popUpMenuItemHoverBackgroundColor:
                      widget.popUpMenuItemHoverBackgroundColor,
                  popUpMenuItemBorderRadius: widget.popUpMenuItemBorderRadius,
                  popUpMenuItemBorderColor: widget.popUpMenuItemBorderColor,
                  popUpMenuItemBorderWidth: widget.popUpMenuItemBorderWidth,
                  popUpMenuItemPadding: widget.popUpMenuItemPadding,
                  popUpMenuItemForegroundColor:
                      widget.popUpMenuItemForegroundColor,
                  popUpMenuItemHoverForegroundColor:
                      widget.popUpMenuItemHoverForegroundColor,

                  //pop up menu properties
                  popUpPadding: widget.popUpPadding,
                  popUpDecoration: widget.popUpDecoration,

                  //menu bar menu properties
                  menuBarItemColor: widget.menuBarItemColor,
                  menuBarItemHoverColor: widget.menuBarItemHoverColor,
                );
              },
            ),
          ),
          // ),
        );
      },
    );
  }
}

class NestedMenuItemStyle {
  const NestedMenuItemStyle({
    this.iconColor = Colors.black54,
    this.iconSize = 20,
    this.moreIconColor = Colors.black54,
    this.iconScale = 0.86,
    this.unselectedColor = Colors.black26,
    this.activatedColor = Colors.lightBlue,
    this.indicatorColor = const Color(0xFFDCF5FF),
    this.padding = const EdgeInsets.symmetric(horizontal: 15),
    this.textStyle = const TextStyle(
      color: Colors.black,
      fontSize: 14,
    ),
    this.enableSelectedTopMenu = false,
    this.initialSelectedTopMenuIndex = 0,
    this.selectedTopMenuIconColor = Colors.lightBlue,
    this.selectedTopMenuTextStyle = const TextStyle(
      color: Colors.lightBlue,
      fontSize: 14,
    ),
    this.selectedTopMenuResolver,
  });

  final Color iconColor;

  final double iconSize;

  final Color moreIconColor;

  final double iconScale;

  final Color unselectedColor;

  final Color activatedColor;

  final Color indicatorColor;

  final EdgeInsets padding;

  final TextStyle textStyle;

  /// When the top menu is tapped, the selected style is set.
  final bool enableSelectedTopMenu;

  /// Initial top-level menu selection index.
  ///
  /// If the value is set to null, no menu is selected.
  ///
  /// Valid only when [enableSelectedTopMenu] is set to true.
  final int? initialSelectedTopMenuIndex;

  /// The color of the icon in the selected state of the top menu.
  ///
  /// Valid only when [enableSelectedTopMenu] is set to true.
  final Color selectedTopMenuIconColor;

  /// The text style of the selected state of the top-level menu.
  ///
  /// Valid only when [enableSelectedTopMenu] is set to true.
  final TextStyle selectedTopMenuTextStyle;

  /// Determines whether the top-level menu is enabled or disabled when tapped.
  ///
  /// Valid only when [enableSelectedTopMenu] is set to true.
  ///
  /// ```dart
  /// selectedTopMenuResolver: (menu, enabled) {
  ///   final description = enabled == true ? 'disabled' : 'enabled';
  ///   message(context, '${menu.title} $description');
  ///   return enabled == true ? null : true;
  /// },
  /// ```
  final bool? Function(NestedMenuItem, bool?)? selectedTopMenuResolver;
}

enum NestedMenuBarMode {
  hover,
  tap;

  bool get isHover => this == NestedMenuBarMode.hover;
  bool get isTap => this == NestedMenuBarMode.tap;
}
