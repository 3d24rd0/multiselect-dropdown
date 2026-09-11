part of '../multi_dropdown.dart';

/// Internal model representing an entry in a flattened grouped list.
class _GroupListEntry<T> {
  const new header(this.groupLabel)
      : isHeader = true,
        item = null;

  const new item(this.item)
      : isHeader = false,
        groupLabel = null;

  final bool isHeader;
  final String? groupLabel;
  final DropdownItem<T>? item;
}

/// Dropdown content overlay widget.
class _Dropdown<T> extends StatefulWidget {
  /// Creates a dropdown widget.
  const new({
    required this.decoration,
    required this.dropdownItemDecoration,
    required this.searchDecoration,
    required this.width,
    required this.searchEnabled,
    required this.maxSelections,
    required this.items,
    required this.onItemTap,
    this.maxHeight,
    this.emptyItemsWidget,
    this.onSearchChange,
    this.itemBuilder,
    this.itemSeparator,
    this.singleSelect = false,
    this.showSelectAll = false,
    this.groups,
    this.groupHeaderDecoration = const GroupHeaderDecoration(),
    this.onSelectAll,
    this.onDeselectAll,
    super.key,
  });

  /// The decoration of the dropdown.
  final DropdownDecoration decoration;

  /// The decoration of the dropdown items.
  final DropdownItemDecoration dropdownItemDecoration;

  /// The decoration of the search field.
  final SearchFieldDecoration searchDecoration;

  /// The width of the dropdown.
  final double width;

  /// The maximum height of the dropdown.
  final double? maxHeight;

  /// Whether the search field is enabled.
  final bool searchEnabled;

  /// The maximum number of selections allowed.
  final int maxSelections;

  /// The list of dropdown items.
  final List<DropdownItem<T>> items;

  /// Optional grouped items.
  final List<DropdownGroup<T>>? groups;

  /// Decoration for group headers.
  final GroupHeaderDecoration groupHeaderDecoration;

  /// The callback when an item is tapped.
  final ValueChanged<DropdownItem<T>> onItemTap;

  /// The callback when the search field value changes.
  final ValueChanged<String>? onSearchChange;

  /// The builder for the dropdown items.
  final DropdownItemBuilder<T>? itemBuilder;

  /// The separator between the dropdown items.
  final Widget? itemSeparator;

  /// Custom empty items widget.
  final Widget? emptyItemsWidget;

  /// Whether the dropdown is in single select mode.
  final bool singleSelect;

  /// Whether to show the select all / deselect all toggle.
  final bool showSelectAll;

  /// Callback when "Select All" is tapped.
  final VoidCallback? onSelectAll;

  /// Callback when "Deselect All" is tapped.
  final VoidCallback? onDeselectAll;

  @override
  State<_Dropdown<T>> createState() => _DropdownState<T>();
}

class _DropdownState<T> extends State<_Dropdown<T>>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    final duration = widget.decoration.animationDuration;
    _animationController = AnimationController(
      vsync: this,
      duration: duration,
    );

    final curve = CurvedAnimation(
      parent: _animationController,
      curve: widget.decoration.animationCurve,
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1).animate(curve);
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(curve);

    if (duration > Duration.zero) {
      _animationController.forward();
    } else {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  int get _selectedCount => widget.items.where((i) => i.selected).length;

  static const Map<ShortcutActivator, Intent> _webShortcuts =
      <ShortcutActivator, Intent>{
    SingleActivator(LogicalKeyboardKey.arrowDown):
        DirectionalFocusIntent(TraversalDirection.down),
    SingleActivator(LogicalKeyboardKey.arrowUp):
        DirectionalFocusIntent(TraversalDirection.up),
  };

  /// Builds a flattened list of headers and items matching the current
  /// search results while preserving group structure.
  List<_GroupListEntry<T>> _buildGroupEntries() {
    final entries = <_GroupListEntry<T>>[];
    final visibleItems = widget.items.toSet();

    for (final group in widget.groups!) {
      final matchingItems =
          group.items.where(visibleItems.contains).toList();

      if (matchingItems.isNotEmpty) {
        entries.add(_GroupListEntry.header(group.label));
        for (final item in matchingItems) {
          final currentItem =
              widget.items.firstWhere((i) => i.value == item.value);
          entries.add(_GroupListEntry.item(currentItem));
        }
      }
    }

    return entries;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resolvedBg =
        widget.decoration.backgroundColor ?? theme.colorScheme.surface;
    final isGrouped = widget.groups != null && widget.groups!.isNotEmpty;

    return Shortcuts(
      shortcuts: _webShortcuts,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          alignment: Alignment.topCenter,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: widget.maxHeight ?? widget.decoration.maxHeight,
            ),
            width: widget.width,
            decoration: BoxDecoration(
              color: resolvedBg,
              borderRadius: widget.decoration.borderRadius,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: widget.decoration.elevation * 4,
                  offset: Offset(0, widget.decoration.elevation * 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: widget.decoration.borderRadius,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.searchEnabled)
                    _SearchField(
                      decoration: widget.searchDecoration,
                      onChanged: _onSearchChange,
                    ),
                  if (widget.showSelectAll && !widget.singleSelect)
                    _buildSelectAll(theme),
                  if (widget.decoration.header != null)
                    Flexible(child: widget.decoration.header!),
                  Flexible(
                    child: isGrouped
                        ? _buildGroupedList(theme)
                        : _buildFlatList(theme),
                  ),
                  if (widget.items.isEmpty)
                    widget.emptyItemsWidget ??
                        widget.decoration.noItemsFoundWidget ??
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            widget.decoration.noItemsFoundText,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                  if (widget.decoration.footer != null)
                    Flexible(child: widget.decoration.footer!),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the "Select All / Deselect All" toggle row.
  Widget _buildSelectAll(ThemeData theme) {
    final selectableItems = widget.items.where((i) => !i.disabled).toList();
    final allSelected = selectableItems.isNotEmpty &&
        selectableItems.every((item) => item.selected);
    final noneSelected = selectableItems.every((item) => !item.selected);
    final enabled = selectableItems.isNotEmpty;

    final label =
        allSelected ? widget.decoration.deselectAllText : widget.decoration.selectAllText;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: enabled
              ? () {
                  if (allSelected) {
                    widget.onDeselectAll?.call();
                  } else {
                    widget.onSelectAll?.call();
                  }
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                IgnorePointer(
                  child: Checkbox(
                    value: allSelected ? true : (noneSelected ? false : null),
                    tristate: true,
                    onChanged: enabled ? (_) {} : null,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: enabled
                          ? theme.colorScheme.onSurface
                          : theme.disabledColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }

  /// Builds the flat list of items (no groups).
  Widget _buildFlatList(ThemeData theme) {
    return ListView.separated(
      separatorBuilder: (_, _) =>
          widget.itemSeparator ?? const SizedBox.shrink(),
      shrinkWrap: true,
      padding: widget.decoration.listPadding ?? EdgeInsets.zero,
      itemCount: widget.items.length,
      itemBuilder: (_, index) => _buildOption(widget.items[index], theme),
    );
  }

  /// Builds a grouped list with interleaved section headers and items.
  Widget _buildGroupedList(ThemeData theme) {
    final entries = _buildGroupEntries();

    return ListView.builder(
      shrinkWrap: true,
      padding: widget.decoration.listPadding ?? EdgeInsets.zero,
      itemCount: entries.length,
      itemBuilder: (_, index) {
        final entry = entries[index];

        if (entry.isHeader) {
          return _buildGroupHeader(
            entry.groupLabel!,
            theme,
            isFirst: index == 0,
          );
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildOption(entry.item!, theme),
            if (widget.itemSeparator != null &&
                index < entries.length - 1 &&
                !entries[index + 1].isHeader)
              widget.itemSeparator!,
          ],
        );
      },
    );
  }

  /// Builds a group section header row.
  Widget _buildGroupHeader(
    String label,
    ThemeData theme, {
    required bool isFirst,
  }) {
    final decoration = widget.groupHeaderDecoration;
    final textStyle = decoration.textStyle ??
        theme.textTheme.labelLarge?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!isFirst && decoration.showDivider) const Divider(height: 1),
        Container(
          color: decoration.backgroundColor,
          padding: decoration.padding,
          child: Text(label, style: textStyle),
        ),
      ],
    );
  }

  Widget _buildOption(DropdownItem<T> option, ThemeData theme) {
    if (widget.itemBuilder != null) {
      return widget.itemBuilder!(
        option,
        widget.items.indexOf(option),
        () => widget.onItemTap(option),
      );
    }

    final disabledColor =
        widget.dropdownItemDecoration.disabledBackgroundColor ??
            widget.dropdownItemDecoration.backgroundColor?.withAlpha(100);

    final tileColor = option.disabled
        ? disabledColor
        : option.selected
            ? widget.dropdownItemDecoration.selectedBackgroundColor
            : widget.dropdownItemDecoration.backgroundColor;

    final trailing = option.disabled
        ? widget.dropdownItemDecoration.disabledIcon
        : option.selected
            ? AnimatedScale(
                scale: 1,
                duration: const Duration(milliseconds: 200),
                curve: Curves.elasticOut,
                child: widget.dropdownItemDecoration.selectedIcon,
              )
            : null;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      color: tileColor ?? Colors.transparent,
      child: Material(
        type: MaterialType.transparency,
        child: ListTile(
          title: Text(
            option.label,
            style: option.selected
                ? widget.dropdownItemDecoration.selectedTextStyle
                : widget.dropdownItemDecoration.textStyle,
          ),
          trailing: trailing,
          dense: true,
          autofocus: true,
          enabled: !option.disabled,
          selected: option.selected,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          focusColor:
              widget.dropdownItemDecoration.backgroundColor?.withAlpha(100),
          selectedColor: widget.dropdownItemDecoration.selectedTextColor ??
              theme.colorScheme.onSurface,
          textColor: option.disabled
              ? widget.dropdownItemDecoration.disabledTextColor ??
                  theme.disabledColor
              : widget.dropdownItemDecoration.textColor ??
                  theme.colorScheme.onSurface,
          tileColor: Colors.transparent,
          selectedTileColor: Colors.transparent,
          onTap: () {
            if (option.disabled) return;

            if (widget.singleSelect || !_reachedMaxSelection(option)) {
              widget.onItemTap(option);
              return;
            }
          },
        ),
      ),
    );
  }

  void _onSearchChange(String value) => widget.onSearchChange?.call(value);

  bool _reachedMaxSelection(DropdownItem<dynamic> option) {
    return !option.selected &&
        widget.maxSelections > 0 &&
        _selectedCount >= widget.maxSelections;
  }
}

class _SearchField extends StatefulWidget {
  const new({
    required this.decoration,
    required this.onChanged,
  });

  final SearchFieldDecoration decoration;

  final ValueChanged<String> onChanged;

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  late final TextEditingController _controller = TextEditingController();
  bool _hasText = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final currentHasText = _controller.text.isNotEmpty;
    if (currentHasText != _hasText) {
      setState(() {
        _hasText = currentHasText;
      });
    }
  }

  void _handleSearchChange(String value) {
    final debounceMs = widget.decoration.searchDebounceMs;
    if (debounceMs <= 0) {
      widget.onChanged(value);
      return;
    }

    _debounce?.cancel();
    _debounce = Timer(Duration(milliseconds: debounceMs), () {
      widget.onChanged(value);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller
      ..removeListener(_onTextChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget? clearIconWidget;
    if (widget.decoration.showClearIcon && _hasText) {
      final iconButton = IconButton(
        icon: const Icon(Icons.clear, size: 18),
        onPressed: () {
          _controller.clear();
          _debounce?.cancel();
          widget.onChanged('');
        },
      );
      if (widget.decoration.clearTooltip != null &&
          widget.decoration.clearTooltip!.isNotEmpty) {
        clearIconWidget = Tooltip(
          message: widget.decoration.clearTooltip,
          child: iconButton,
        );
      } else {
        clearIconWidget = iconButton;
      }
    }

    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        controller: _controller,
        autofocus: widget.decoration.autofocus,
        style: widget.decoration.textStyle,
        cursorColor: widget.decoration.cursorColor,
        decoration: InputDecoration(
          isDense: true,
          hintText: widget.decoration.hintText,
          hintStyle: widget.decoration.hintStyle,
          border: widget.decoration.border,
          focusedBorder: widget.decoration.focusedBorder,
          filled: widget.decoration.filled,
          fillColor: widget.decoration.fillColor,
          prefixIcon: widget.decoration.searchIcon,
          suffixIcon: clearIconWidget,
        ),
        onChanged: _handleSearchChange,
      ),
    );
  }
}
