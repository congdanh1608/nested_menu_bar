part of '../nested_menu_bar.dart';

class NestedMenuItem {


  /// Set a unique ID for the menu widget.
  ///
  /// Prevents [key] from being changed when [NestedMenuItem] is created in the [build] method.
  ///
  /// When [NestedMenuItem] is created in [State.initState], etc.,
  /// there is no need to set [id] because [key] does not change
  /// even if [build] is called multiple times.

  Object? id;

  /// Menu title
  final String title;

  final IconData? icon;

  final bool enable;

  /// Callback executed when a menu is tapped
  final Function()? onTap;

  /// Passing [NestedMenuItem] to a [List] creates a sub-menu.
  final List<NestedMenuItem>? children;

  /// Button type menu item.
  NestedMenuItem({
    /// {@macro Nested_menu_item_id}
    this.id,
    required this.title,
    this.icon,
    this.enable = true,
    this.onTap,
    this.children,
  })  : _key = id == null ? GlobalKey() : GlobalObjectKey(id),
        isBack = false {
    _setParent();
  }

  /// A menu item of type checkbox.
  ///
  /// [id]
  /// {@macro Nested_menu_item_id}
  factory NestedMenuItem.checkbox({
    Object? id,
    required String title,
    IconData? icon,
    bool enable = false,
    void Function()? onTap,
    List<NestedMenuItem>? children,
    void Function(bool?)? onChanged,
    bool? initialCheckValue,
  }) {
    return NestedMenuItemCheckbox(
      id: id,
      title: title,
      icon: icon,
      enable: enable,
      onTap: onTap,
      children: children,
      onChanged: onChanged,
      initialCheckValue: initialCheckValue,
    );
  }

  /// A menu item of type radio button.
  ///
  /// [id]
  /// {@macro Nested_menu_item_id}
  factory NestedMenuItem.radio({
    Object? id,
    required String title,
    IconData? icon,
    bool enable = false,
    void Function()? onTap,
    required List<Object> radioItems,
    void Function(Object?)? onChanged,
    String Function(Object)? getTitle,
    Object? initialRadioValue,
  }) {
    return NestedMenuItemRadio(
      id: id,
      title: title,
      icon: icon,
      enable: enable,
      onTap: onTap,
      radioItems: radioItems,
      onChanged: onChanged,
      getTitle: getTitle,
      initialRadioValue: initialRadioValue,
    );
  }

  /// A menu item of type Widget.
  ///
  /// [id]
  /// {@macro Nested_menu_item_id}
  factory NestedMenuItem.widget({
    Object? id,
    required Widget widget,
    bool enable = false,
    void Function()? onTap,
  }) {
    return NestedMenuItemWidget(
      id: id,
      widget: widget,
      enable: enable,
      onTap: onTap,
    );
  }

  /// A menu item of type Divider.
  factory NestedMenuItem.divider({
    double height = 16.0,
    Color? color,
    double? indent,
    double? endIndent,
    double? thickness,
  }) {
    return NestedMenuItemDivider(
      height: height,
      color: color,
      indent: indent,
      endIndent: endIndent,
      thickness: thickness,
    );
  }

  NestedMenuItem.back({
    required this.title,
    this.children,
  })  : icon = null,
        enable = true,
        onTap = null,
        _key = GlobalKey(),
        isBack = true;

  final GlobalKey _key;

  final bool isBack;

  NestedMenuItem? parent;

  GlobalKey get key => _key;

  NestedMenuItemType get type => NestedMenuItemType.button;

  bool get isBackto => isBack;

  bool get hasChildren => children != null && children!.isNotEmpty;

  bool get isRootSubMenu => parent == null;

  bool get hasContext => _key.currentContext != null;

  Offset get position {
    if (_key.currentContext == null) return Offset.zero;

    RenderBox box = _key.currentContext!.findRenderObject() as RenderBox;

    return box.localToGlobal(Offset.zero);
  }

  Size get size {
    if (_key.currentContext == null) return Size.zero;

    RenderBox box = _key.currentContext!.findRenderObject() as RenderBox;

    return box.size;
  }

  void _setParent() {
    if (!hasChildren) return;
    for (var e in children!) {
      e.parent = this;
    }
  }
}

class NestedMenuItemCheckbox extends NestedMenuItem {
  NestedMenuItemCheckbox({
    super.id,
    required super.title,
    super.icon,
    super.enable = true,
    super.onTap,
    super.children,
    this.onChanged,
    this.initialCheckValue,
  });

  NestedMenuItemType get type => NestedMenuItemType.checkbox;

  final Function(bool?)? onChanged;

  final bool? initialCheckValue;
}

class NestedMenuItemRadio extends NestedMenuItem {
  NestedMenuItemRadio({
    super.id,
    required super.title,
    super.icon,
    super.enable = true,
    super.onTap,
    required this.radioItems,
    this.onChanged,
    this.getTitle,
    this.initialRadioValue,
  });

  NestedMenuItemType get type => NestedMenuItemType.radio;

  final Function(Object?)? onChanged;

  String Function(Object)? getTitle;

  final Object? initialRadioValue;

  final List<Object> radioItems;
}

class NestedMenuItemWidget extends NestedMenuItem {
  NestedMenuItemWidget({
    super.id,
    required this.widget,
    super.enable = false,
    super.onTap,
  }) : super(title: '_widget');

  NestedMenuItemType get type => NestedMenuItemType.widget;

  final Widget widget;
}

class NestedMenuItemDivider extends NestedMenuItem {
  NestedMenuItemDivider({
    this.height = 16.0,
    this.color,
    this.indent,
    this.endIndent,
    this.thickness,
  }) : super(title: '_divider', enable: false);

  NestedMenuItemType get type => NestedMenuItemType.divider;

  final double height;

  final Color? color;

  final double? indent;

  final double? endIndent;

  final double? thickness;
}

enum NestedMenuItemType {
  button,
  checkbox,
  radio,
  widget,
  divider;

  bool get isButton => this == NestedMenuItemType.button;
  bool get isCheckbox => this == NestedMenuItemType.checkbox;
  bool get isRadio => this == NestedMenuItemType.radio;
  bool get isWidget => this == NestedMenuItemType.widget;
  bool get isDivider => this == NestedMenuItemType.divider;
}
