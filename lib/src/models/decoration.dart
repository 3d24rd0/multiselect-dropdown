part of '../multi_dropdown.dart';

/// Represents the decoration for the search field in the dropdown.
class SearchFieldDecoration {
  /// Creates a new instance of [SearchFieldDecoration].
  const new({
    this.hintText = 'Search',
    this.border = const OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xFFE0E0E0)),
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    this.focusedBorder = const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    this.searchIcon = const Icon(Icons.search),
    this.showClearIcon = true,
    this.filled,
    this.fillColor,
    this.cursorColor,
    this.textStyle,
    this.hintStyle,
    this.autofocus = false,
    this.searchDebounceMs = 0,
    this.clearTooltip = 'Clear search',
  });

  /// The hint text to display in the search field.
  final String hintText;

  /// The border of the search field.
  final InputBorder? border;

  /// The border of the search field when it is focused.
  final InputBorder? focusedBorder;

  /// The icon to display in the search field.
  final Widget searchIcon;

  /// Whether to show a clear button in the search field when text is entered.
  final bool showClearIcon;

  /// Whether the search field is filled with [fillColor].
  final bool? filled;

  /// The background fill color of the search field.
  final Color? fillColor;

  /// The color of the cursor in the search field.
  final Color? cursorColor;

  /// The style of the text being edited in the search field.
  final TextStyle? textStyle;

  /// The style of the hint text in the search field.
  final TextStyle? hintStyle;

  /// Whether the search field should automatically focus when the dropdown opens.
  final bool autofocus;

  /// The debounce delay in milliseconds for search query changes.
  final int searchDebounceMs;

  /// The tooltip message for the clear search button.
  final String? clearTooltip;
}

/// Represents the decoration for the dropdown items.
class DropdownItemDecoration {
  /// Creates a new instance of [DropdownItemDecoration].
  const new({
    this.backgroundColor,
    this.disabledBackgroundColor,
    this.selectedBackgroundColor,
    this.selectedTextColor,
    this.textColor,
    this.disabledTextColor,
    this.selectedIcon = const Icon(Icons.check),
    this.disabledIcon,
    this.selectedTextStyle,
    this.textStyle,
  });

  /// The background color of the dropdown item.
  final Color? backgroundColor;

  /// The background color of the disabled dropdown item.
  final Color? disabledBackgroundColor;

  /// The background color of the selected dropdown item.
  final Color? selectedBackgroundColor;

  /// The text color of the selected dropdown item.
  final Color? selectedTextColor;

  /// The text color of the dropdown item.
  final Color? textColor;

  /// The text color of the disabled dropdown item.
  final Color? disabledTextColor;

  /// The icon to display for the selected dropdown item.
  final Widget? selectedIcon;

  /// The icon to display for the disabled dropdown item.
  final Widget? disabledIcon;

  /// The text style of the selected dropdown item.
  final TextStyle? selectedTextStyle;

  /// The text style of the dropdown item.
  final TextStyle? textStyle;
}

/// Represents the decoration for the dropdown.
class DropdownDecoration {
  /// Creates a new instance of [DropdownDecoration].
  const new({
    this.backgroundColor,
    this.elevation = 1,
    this.maxHeight = 400,
    this.marginTop = 0,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.footer,
    this.header,
    this.listPadding,
    this.noItemsFoundText = 'No items found',
    this.noItemsFoundWidget,
    this.expandDirection = ExpandDirection.auto,
    this.showSelectAll = false,
    this.selectAllText = 'Select All',
    this.deselectAllText = 'Deselect All',
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeOutCubic,
  });

  /// The background color of the dropdown.
  ///
  /// When null, resolves to [ColorScheme.surface] from the theme.
  final Color? backgroundColor;

  /// The elevation of the dropdown.
  final double elevation;

  /// The maximum height of the dropdown.
  final double maxHeight;

  /// The border radius of the dropdown.
  final BorderRadius borderRadius;

  /// The margin top of the dropdown.
  final double marginTop;

  /// The custom footer widget to display at the bottom of the dropdown.
  final Widget? footer;

  /// The custom header widget to display at the top of the dropdown.
  final Widget? header;

  /// The padding around the list of items inside the dropdown overlay.
  final EdgeInsetsGeometry? listPadding;

  /// The text to display when no items are found after search.
  final String noItemsFoundText;

  /// A custom widget to display when no items match the search query.
  final Widget? noItemsFoundWidget;

  /// The direction in which the dropdown opens.
  final ExpandDirection expandDirection;

  /// Whether to show a "Select All / Deselect All" toggle at the top.
  final bool showSelectAll;

  /// The text label for the "Select All" action.
  final String selectAllText;

  /// The text label for the "Deselect All" action.
  final String deselectAllText;

  /// The duration of the dropdown open/close animation.
  final Duration animationDuration;

  /// The curve used for the dropdown open/close animation.
  final Curve animationCurve;
}

/// Represents the decoration for the dropdown field.
class FieldDecoration {
  /// Creates a new instance of [FieldDecoration].
  const new({
    this.labelText,
    this.hintText = 'Select',
    this.border,
    this.focusedBorder,
    this.disabledBorder,
    this.errorBorder,
    this.suffixIcon = const Icon(Icons.arrow_drop_down),
    this.prefixIcon,
    this.errorIcon,
    this.labelStyle,
    this.hintStyle,
    this.errorStyle,
    this.borderRadius = 12,
    this.animateSuffixIcon = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.backgroundColor,
    this.showClearIcon = true,
    this.selectedItemTextStyle,
    this.inputDecoration,
    this.clearTooltip = 'Clear selection',
    this.clearSemanticsLabel = 'Clear all selections',
  });

  /// The label text to display above the dropdown field.
  final String? labelText;

  /// The hint text to display in the dropdown field.
  final String? hintText;

  /// The border of the dropdown field.
  final InputBorder? border;

  /// The border of the dropdown field when it is focused.
  final InputBorder? focusedBorder;

  /// The border of the dropdown field when it is disabled.
  final InputBorder? disabledBorder;

  /// The border of the dropdown field when there is an error.
  final InputBorder? errorBorder;

  /// The icon to display at the end of dropdown field.
  final Widget? suffixIcon;

  /// The icon to display at the start of dropdown field.
  final Widget? prefixIcon;

  /// The icon to display at the start of the error message.
  final Widget? errorIcon;

  /// The style of the label text.
  final TextStyle? labelStyle;

  /// The style of the hint text.
  final TextStyle? hintStyle;

  /// The style of the error text.
  final TextStyle? errorStyle;

  /// The border radius of the dropdown field.
  final double borderRadius;

  /// Whether to animate the suffix icon rotation when the dropdown opens/closes.
  final bool animateSuffixIcon;

  /// The padding around the dropdown field content.
  final EdgeInsets? padding;

  /// The background fill color of the dropdown field.
  final Color? backgroundColor;

  /// Whether to show a clear/deselect icon when items are selected.
  final bool showClearIcon;

  /// The text style of the selected item in single-select mode.
  final TextStyle? selectedItemTextStyle;

  /// A custom [InputDecoration] for the dropdown field.
  final InputDecoration? inputDecoration;

  /// Tooltip message for the clear selection button.
  final String? clearTooltip;

  /// Accessibility semantics label for the clear selection button.
  final String? clearSemanticsLabel;
}

/// Configuration class for customizing the appearance of chips in the multi-select dropdown.
class ChipDecoration {
  /// Creates a new instance of [ChipDecoration].
  const new({
    this.deleteIcon,
    this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    this.border = const Border(),
    this.spacing = 8,
    this.runSpacing = 12,
    this.labelStyle,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.wrap = true,
    this.maxDisplayCount,
    this.overflowLabelBuilder,
    this.deleteTooltipBuilder,
    this.deleteSemanticsLabelBuilder,
  });

  /// The icon to display for deleting a chip.
  final Widget? deleteIcon;

  /// The background color of the chip.
  ///
  /// When null, resolves to [ColorScheme.surfaceContainerHighest] or theme surface.
  final Color? backgroundColor;

  /// The style of the chip label.
  final TextStyle? labelStyle;

  /// The padding around the chip.
  final EdgeInsets padding;

  /// The border of the chip.
  final BoxBorder border;

  /// The spacing between chips.
  final double spacing;

  /// The spacing between chip rows (when the chips wrap).
  final double runSpacing;

  /// The border radius of the chip.
  final BorderRadiusGeometry borderRadius;

  /// Whether to wrap or scroll horizontally.
  final bool wrap;

  /// The maximum number of chips to display.
  final int? maxDisplayCount;

  /// A builder to customize the overflow label shown when [maxDisplayCount] is exceeded.
  final String Function(int remaining)? overflowLabelBuilder;

  /// Builder for delete button tooltip.
  final String Function(String label)? deleteTooltipBuilder;

  /// Builder for delete button semantics label.
  final String Function(String label)? deleteSemanticsLabelBuilder;
}

/// Configuration class for customizing the appearance of group headers
/// in the dropdown when using [MultiDropdown] with grouped items.
class GroupHeaderDecoration {
  /// Creates a new instance of [GroupHeaderDecoration].
  const new({
    this.textStyle,
    this.padding = const EdgeInsets.fromLTRB(16, 12, 16, 4),
    this.backgroundColor,
    this.showDivider = true,
  });

  /// The text style of the group header label.
  final TextStyle? textStyle;

  /// The padding around the group header content.
  final EdgeInsets padding;

  /// The background color of the group header.
  final Color? backgroundColor;

  /// Whether to show a divider above each group header (except the first).
  final bool showDivider;
}
