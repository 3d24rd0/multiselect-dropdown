# MultiSelect Dropdown

[![Pub Version](https://img.shields.io/badge/version-0.0.3-blue.svg)](https://github.com/3d24rd0/multiselect-dropdown)
[![License](https://img.shields.io/github/license/3d24rd0/multiselect-dropdown)](https://github.com/3d24rd0/multiselect-dropdown/blob/main/LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.47.2-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-%3E%3D3.13.2-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)

A versatile, highly customizable MultiSelect Dropdown widget for Flutter. Supports multi-selection, single-selection, grouped lists with section headers, modal bottom-sheet mode, debounced search, form validation, asynchronous data loading, custom builders, and complete localization without hardcoded strings.

---

## Features

- **Multi & Single Select**: Easily switch between multi-selection and single-selection modes.
- **Grouped Items**: Categorize dropdown options with `DropdownGroup<T>` and customizable `GroupHeaderDecoration`.
- **Presentation Modes**: Supports classic overlay dropdown (`DropdownMode.overlay`) and modal bottom-sheet (`DropdownMode.bottomSheet`).
- **Select All / Deselect All**: Built-in toggle action with customizable labels (`showSelectAll: true`).
- **Debounced Search**: Built-in search field with customizable debounce delay (`searchDebounceMs`) and custom filter predicates (`SearchFilter<T>`).
- **Async Data Loading**: Load items asynchronously using the `MultiDropdown.future` constructor with built-in loading indicator.
- **Zero Hardcoded Strings**: Full control over all labels, tooltips, semantics, and empty states for internationalization (i18n).
- **Form Validation**: Seamless integration with Flutter's `Form` and `FormField` validation.
- **Animations**: Configurable open/close transitions, checkmark scale animations, and chip animations.
- **Extensive Styling**: Rich decorations for chips (`ChipDecoration`), field (`FieldDecoration`), dropdown list (`DropdownDecoration`), search field (`SearchFieldDecoration`), and item rows (`DropdownItemDecoration`).

---

## Getting Started

Add `multi_dropdown` to your `pubspec.yaml`:

```yaml
dependencies:
  multi_dropdown:
    git:
      url: https://github.com/3d24rd0/multiselect-dropdown.git
      ref: main
```

Import the package:

```dart
import 'package:multi_dropdown/multi_dropdown.dart';
```

---

## Usage Examples

### 1. Basic Multi-Select

```dart
MultiDropdown<int>(
  items: const [
    DropdownItem(label: 'Apple', value: 1),
    DropdownItem(label: 'Banana', value: 2),
    DropdownItem(label: 'Cherry', value: 3),
  ],
  onSelectionChange: (selectedValues) {
    print('Selected values: $selectedValues');
  },
)
```

### 2. Grouped Items with Section Headers

```dart
MultiDropdown<String>(
  groups: const [
    DropdownGroup(
      label: 'Fruits',
      items: [
        DropdownItem(label: 'Apple', value: 'apple'),
        DropdownItem(label: 'Banana', value: 'banana'),
      ],
    ),
    DropdownGroup(
      label: 'Vegetables',
      items: [
        DropdownItem(label: 'Carrot', value: 'carrot'),
        DropdownItem(label: 'Broccoli', value: 'broccoli'),
      ],
    ),
  ],
  groupHeaderDecoration: const GroupHeaderDecoration(
    showDivider: true,
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  ),
  onSelectionChange: (selectedValues) {
    print('Selected: $selectedValues');
  },
)
```

### 3. Modal Bottom Sheet Mode

```dart
MultiDropdown<int>(
  items: items,
  dropdownMode: DropdownMode.bottomSheet,
  searchEnabled: true,
  fieldDecoration: const FieldDecoration(
    labelText: 'Select Categories',
    hintText: 'Tap to choose',
  ),
  onSelectionChange: (selectedValues) {},
)
```

### 4. Async Data Loading with `.future`

```dart
MultiDropdown<User>.future(
  future: () async {
    final response = await fetchUsersFromApi();
    return response.map((u) => DropdownItem(label: u.name, value: u)).toList();
  },
  onSelectionChange: (selectedUsers) {},
)
```

### 5. Localized Tooltips & Semantics (Spanish Example)

```dart
MultiDropdown<int>(
  items: items,
  searchEnabled: true,
  showSelectAll: true,
  fieldDecoration: const FieldDecoration(
    hintText: 'Selecciona opciones',
    clearTooltip: 'Borrar selecciones',
    clearSemanticsLabel: 'Limpiar todas las selecciones',
    semanticsLabel: 'Desplegable multiselección',
  ),
  searchDecoration: const SearchFieldDecoration(
    hintText: 'Buscar...',
    clearTooltip: 'Borrar búsqueda',
    searchDebounceMs: 300,
  ),
  dropdownDecoration: const DropdownDecoration(
    selectAllText: 'Seleccionar todo',
    deselectAllText: 'Deseleccionar todo',
    noItemsFoundText: 'No se encontraron resultados',
  ),
  chipDecoration: ChipDecoration(
    deleteTooltipBuilder: (label) => 'Eliminar $label',
    deleteSemanticsLabelBuilder: (label) => 'Quitar elemento $label',
    overflowLabelBuilder: (count) => '+$count más',
  ),
)
```

---

## Controller

The `MultiSelectController<T>` enables programmatic control over the dropdown state and selections:

```dart
final controller = MultiSelectController<User>();

// Selection operations
controller.selectAll();
controller.clearAll();
controller.selectAtIndex(0);
controller.selectWhere((item) => item.value.isAdmin);
controller.unselectWhere((item) => item.value.isGuest);
controller.toggleWhere((item) => item.value.id == targetId);

// Item management
controller.setItems(newItemsList);
controller.addItem(DropdownItem(label: 'New User', value: newUser));
controller.addItems(moreUsers);
controller.disableWhere((item) => item.value.isBlocked);

// Search & Visibility
controller.clearSearch();
controller.openDropdown();
controller.closeDropdown();

// Getters
List<DropdownItem<User>> allItems = controller.items;
List<DropdownItem<User>> selectedItems = controller.selectedItems;
List<DropdownItem<User>> disabledItems = controller.disabledItems;
bool isOpen = controller.isOpen;
```

---

## Parameters

### `MultiDropdown<T>`

| Parameter | Type | Description | Default |
| :--- | :--- | :--- | :--- |
| `items` | `List<DropdownItem<T>>` | The list of dropdown items (used when `groups` is null). | `const []` |
| `groups` | `List<DropdownGroup<T>>?` | Grouped items with section headers. | `null` |
| `groupHeaderDecoration` | `GroupHeaderDecoration` | Decoration for group headers. | `GroupHeaderDecoration()` |
| `dropdownMode` | `DropdownMode` | Overlay dropdown (`overlay`) or bottom sheet (`bottomSheet`). | `DropdownMode.overlay` |
| `singleSelect` | `bool` | Single-selection mode if true, multi-selection if false. | `false` |
| `showSelectAll` | `bool` | Shows a "Select All / Deselect All" row at the top. | `false` |
| `chipDecoration` | `ChipDecoration` | Visual configuration for selected item chips. | `ChipDecoration()` |
| `fieldDecoration` | `FieldDecoration` | Decoration for the dropdown input field. | `FieldDecoration()` |
| `dropdownDecoration` | `DropdownDecoration` | Decoration for the dropdown overlay container. | `DropdownDecoration()` |
| `searchDecoration` | `SearchFieldDecoration` | Decoration for the search input field. | `SearchFieldDecoration()` |
| `dropdownItemDecoration` | `DropdownItemDecoration` | Decoration for individual dropdown list items. | `DropdownItemDecoration()` |
| `itemBuilder` | `DropdownItemBuilder<T>?` | Custom builder for dropdown list rows. | `null` |
| `selectedItemBuilder` | `SelectedItemBuilder<T>?` | Custom builder for selected items in the field. | `null` |
| `itemSeparator` | `Widget?` | Separator widget rendered between dropdown items. | `null` |
| `emptyItemsWidget` | `Widget?` | Custom empty state widget when no items match search. | `null` |
| `validator` | `FormFieldValidator?` | Form validator function for form validation. | `null` |
| `autovalidateMode` | `AutovalidateMode` | Form autovalidate mode. | `AutovalidateMode.disabled` |
| `controller` | `MultiSelectController<T>?` | Controller for programmatic control. | `null` |
| `maxSelections` | `int` | Maximum number of allowed selections (0 = unlimited). | `0` |
| `enabled` | `bool` | Whether the dropdown field is interactive. | `true` |
| `searchEnabled` | `bool` | Whether the search bar is displayed inside the dropdown. | `false` |
| `searchFilter` | `SearchFilter<T>?` | Custom predicate function for search filtering. | `null` |
| `focusNode` | `FocusNode?` | Focus node for keyboard focus management. | `null` |
| `future` | `FutureRequest<T>?` | Async data loader used with `.future` constructor. | `null` |
| `onSelectionChange` | `OnSelectionChanged<T>?` | Callback fired when the selection changes. | `null` |
| `onSearchChange` | `OnSearchChanged?` | Callback fired when the search query text changes. | `null` |
| `closeOnBackButton` | `bool` | Closes the open dropdown on Android back button tap. | `false` |
| `openDropDown` | `VoidCallback?` | Callback invoked when the dropdown opens. | `null` |

---

### `ChipDecoration`

| Parameter | Type | Description | Default |
| :--- | :--- | :--- | :--- |
| `deleteIcon` | `Widget?` | Custom delete icon for chips. | `Icon(Icons.close, size: 16)` |
| `backgroundColor` | `Color?` | Background fill color of the chip. | `Theme surface` |
| `labelStyle` | `TextStyle?` | Text style for the chip label. | `null` |
| `padding` | `EdgeInsets` | Padding inside each chip. | `EdgeInsets.symmetric(horizontal: 12, vertical: 4)` |
| `border` | `BoxBorder` | Border around the chip. | `Border()` |
| `spacing` | `double` | Horizontal spacing between chips. | `8.0` |
| `runSpacing` | `double` | Vertical spacing between wrapped chip rows. | `12.0` |
| `borderRadius` | `BorderRadiusGeometry` | Corner radius for the chip. | `BorderRadius.circular(12)` |
| `wrap` | `bool` | Wrap chips into multiple lines or scroll horizontally. | `true` |
| `maxDisplayCount` | `int?` | Max number of chips shown before displaying an overflow label. | `null` |
| `overflowLabelBuilder` | `String Function(int)?` | Builder for "+N more" overflow badge. | `null` |
| `deleteTooltipBuilder` | `String Function(String)?` | Builder for localized delete button tooltip. | `null` |
| `deleteSemanticsLabelBuilder`| `String Function(String)?` | Builder for localized delete button accessibility label. | `null` |

---

### `FieldDecoration`

| Parameter | Type | Description | Default |
| :--- | :--- | :--- | :--- |
| `labelText` | `String?` | Floating label text above the field. | `null` |
| `hintText` | `String?` | Placeholder hint text when nothing is selected. | `'Select'` |
| `border` | `InputBorder?` | Default input border. | `OutlineInputBorder(borderRadius: 12)` |
| `focusedBorder` | `InputBorder?` | Border when the dropdown is open. | `null` |
| `disabledBorder` | `InputBorder?` | Border when `enabled: false`. | `null` |
| `errorBorder` | `InputBorder?` | Border when form validation fails. | `null` |
| `suffixIcon` | `Widget?` | Trailing suffix icon. | `Icon(Icons.arrow_drop_down)` |
| `prefixIcon` | `Widget?` | Leading prefix icon. | `null` |
| `errorIcon` | `Widget?` | Icon displayed next to validation error text. | `null` |
| `labelStyle` | `TextStyle?` | Text style for `labelText`. | `null` |
| `hintStyle` | `TextStyle?` | Text style for `hintText`. | `null` |
| `errorStyle` | `TextStyle?` | Text style for validation error message. | `null` |
| `selectedItemTextStyle` | `TextStyle?` | Text style for selected item in single-select mode. | `null` |
| `borderRadius` | `double` | Default border radius. | `12.0` |
| `animateSuffixIcon` | `bool` | Whether to animate arrow rotation on open/close. | `true` |
| `padding` | `EdgeInsets?` | Content padding inside the field. | `EdgeInsets.symmetric(horizontal: 12, vertical: 8)` |
| `backgroundColor` | `Color?` | Background fill color for the field. | `null` |
| `showClearIcon` | `bool` | Shows clear icon when items are selected. | `true` |
| `clearTooltip` | `String?` | Tooltip for the clear selection button. | `'Clear selection'` |
| `clearSemanticsLabel` | `String?` | Accessibility label for the clear button. | `'Clear all selections'` |
| `semanticsLabel` | `String?` | Accessibility label for the dropdown field. | `'Dropdown field'` |
| `inputDecoration` | `InputDecoration?` | Complete custom `InputDecoration` override. | `null` |

---

### `DropdownDecoration`

| Parameter | Type | Description | Default |
| :--- | :--- | :--- | :--- |
| `backgroundColor` | `Color?` | Background color of dropdown overlay. | `Theme surface` |
| `elevation` | `double` | Shadow elevation. | `1.0` |
| `maxHeight` | `double` | Maximum dropdown overlay height. | `400.0` |
| `marginTop` | `double` | Vertical gap between field and dropdown. | `0.0` |
| `borderRadius` | `BorderRadius` | Border radius for overlay container. | `BorderRadius.circular(12)` |
| `header` | `Widget?` | Optional custom header widget inside dropdown. | `null` |
| `footer` | `Widget?` | Optional custom footer widget inside dropdown. | `null` |
| `listPadding` | `EdgeInsetsGeometry?`| Padding around the list of items. | `null` |
| `noItemsFoundText` | `String` | Message shown when search yields 0 items. | `'No items found'` |
| `noItemsFoundWidget` | `Widget?` | Custom widget shown when search yields 0 items. | `null` |
| `expandDirection` | `ExpandDirection` | Auto-detect, force down, or force up (`auto`, `down`, `up`). | `ExpandDirection.auto` |
| `selectAllText` | `String` | Label for "Select All" action. | `'Select All'` |
| `deselectAllText` | `String` | Label for "Deselect All" action. | `'Deselect All'` |
| `animationDuration` | `Duration` | Open/close animation duration. | `Duration(milliseconds: 200)` |
| `animationCurve` | `Curve` | Animation curve for transitions. | `Curves.easeOutCubic` |

---

### `GroupHeaderDecoration`

| Parameter | Type | Description | Default |
| :--- | :--- | :--- | :--- |
| `textStyle` | `TextStyle?` | Text style for group title. | `Theme labelLarge (w600)` |
| `padding` | `EdgeInsets` | Padding around group title. | `EdgeInsets.fromLTRB(16, 12, 16, 4)` |
| `backgroundColor` | `Color?` | Background fill color for group header. | `null` |
| `showDivider` | `bool` | Whether to render a divider above group headers. | `true` |

---

### `SearchFieldDecoration`

| Parameter | Type | Description | Default |
| :--- | :--- | :--- | :--- |
| `hintText` | `String` | Placeholder hint text for search input. | `'Search'` |
| `searchIcon` | `Widget` | Leading search icon. | `Icon(Icons.search)` |
| `showClearIcon` | `bool` | Shows clear icon when text is entered. | `true` |
| `clearTooltip` | `String?` | Tooltip for the clear search button. | `'Clear search'` |
| `searchDebounceMs` | `int` | Debounce delay in milliseconds before search executes. | `0` |
| `autofocus` | `bool` | Autofocus search field when dropdown opens. | `false` |
| `border` | `InputBorder?` | Border for search input. | `OutlineInputBorder(radius: 12)` |
| `focusedBorder` | `InputBorder?` | Focused border for search input. | `OutlineInputBorder(radius: 12)` |
| `fillColor` | `Color?` | Fill background color. | `null` |
| `textStyle` | `TextStyle?` | Text style of input text. | `null` |
| `hintStyle` | `TextStyle?` | Text style of hint text. | `null` |
| `cursorColor` | `Color?` | Cursor color. | `null` |

---

### `DropdownItemDecoration`

| Parameter | Type | Description | Default |
| :--- | :--- | :--- | :--- |
| `backgroundColor` | `Color?` | Background color of item row. | `null` |
| `selectedBackgroundColor`| `Color?` | Background color when item is selected. | `null` |
| `disabledBackgroundColor`| `Color?` | Background color when item is disabled. | `null` |
| `textColor` | `Color?` | Text color of item label. | `null` |
| `selectedTextColor` | `Color?` | Text color when selected. | `null` |
| `disabledTextColor` | `Color?` | Text color when disabled. | `null` |
| `textStyle` | `TextStyle?` | TextStyle of item label. | `null` |
| `selectedTextStyle` | `TextStyle?` | TextStyle when selected. | `null` |
| `selectedIcon` | `Widget?` | Trailing checkmark/icon when selected. | `Icon(Icons.check)` |
| `disabledIcon` | `Widget?` | Trailing icon when disabled. | `null` |

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

