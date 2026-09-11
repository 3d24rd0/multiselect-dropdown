part of '../multi_dropdown.dart';

/// Controller for the multiselect dropdown.
class MultiSelectController<T> extends ChangeNotifier {
  /// a flag to indicate whether the controller is initialized.
  bool _initialized = false;

  /// set initialized flag to true.
  void _initialize() {
    _initialized = true;
  }

  final List<DropdownItem<T>> _items = [];

  List<DropdownItem<T>> _filteredItems = [];

  String _searchQuery = '';

  /// Cached selected items, invalidated on notify.
  List<DropdownItem<T>>? _cachedSelectedItems;

  /// Gets the list of dropdown items.
  List<DropdownItem<T>> get items =>
      _searchQuery.isEmpty ? _items : _filteredItems;

  /// Gets the list of selected dropdown items.
  List<DropdownItem<T>> get selectedItems {
    return _cachedSelectedItems ??=
        _items.where((element) => element.selected).toList();
  }

  /// Get the list of selected dropdown item values.
  List<T> get _selectedValues => selectedItems.map((e) => e.value).toList();

  /// Gets the list of disabled dropdown items.
  List<DropdownItem<T>> get disabledItems =>
      _items.where((element) => element.disabled).toList();

  bool _open = false;

  /// Gets whether the dropdown is open.
  bool get isOpen => _open;

  bool _isDisposed = false;

  /// Gets whether the controller is disposed.
  bool get isDisposed => _isDisposed;

  /// on selection changed callback invoker.
  OnSelectionChanged<T>? _onSelectionChanged;

  /// on search changed callback invoker.
  OnSearchChanged? _onSearchChanged;

  /// Optional custom search filter.
  SearchFilter<T>? _searchFilter;

  @override
  void notifyListeners() {
    _cachedSelectedItems = null;
    super.notifyListeners();
  }

  /// Re-applies the current search filter to the items list.
  void _reapplySearchFilter() {
    if (_searchQuery.isEmpty) {
      _filteredItems = List.from(_items);
    } else if (_searchFilter != null) {
      _filteredItems = _searchFilter!(_searchQuery, List.from(_items));
    } else {
      final query = _searchQuery.toLowerCase();
      _filteredItems = _items
          .where((item) => item.label.toLowerCase().contains(query))
          .toList();
    }
  }

  /// sets the list of dropdown items.
  /// It replaces the existing list of dropdown items.
  void setItems(List<DropdownItem<T>> options) {
    _items
      ..clear()
      ..addAll(options);
    _searchQuery = '';
    _filteredItems = List.from(_items);
    notifyListeners();
    _onSelectionChanged?.call(_selectedValues);
  }

  /// Adds a dropdown item to the list of dropdown items.
  /// The [index] parameter is optional, and if provided, the item will be inserted at the specified index.
  void addItem(DropdownItem<T> option, {int index = -1}) {
    if (index == -1) {
      _items.add(option);
    } else {
      _items.insert(index, option);
    }
    _reapplySearchFilter();
    notifyListeners();
    _onSelectionChanged?.call(_selectedValues);
  }

  /// Adds a list of dropdown items to the list of dropdown items.
  void addItems(List<DropdownItem<T>> options) {
    _items.addAll(options);
    _reapplySearchFilter();
    notifyListeners();
    _onSelectionChanged?.call(_selectedValues);
  }

  /// clears all the selected items.
  void clearAll() {
    for (var i = 0; i < _items.length; i++) {
      if (_items[i].selected) {
        _items[i] = _items[i].copyWith(selected: false);
      }
    }
    _reapplySearchFilter();
    notifyListeners();
    _onSelectionChanged?.call(_selectedValues);
  }

  /// selects all the items.
  void selectAll() {
    for (var i = 0; i < _items.length; i++) {
      if (!_items[i].selected) {
        _items[i] = _items[i].copyWith(selected: true);
      }
    }
    _reapplySearchFilter();
    notifyListeners();
    _onSelectionChanged?.call(_selectedValues);
  }

  /// select the item at the specified index.
  ///
  /// The [index] parameter is the index of the item to select.
  void selectAtIndex(int index) {
    if (index < 0 || index >= _items.length) return;

    final item = _items[index];

    if (item.disabled || item.selected) return;

    selectWhere((element) => element == _items[index]);
  }

  /// deselects all the items.
  void toggleWhere(bool Function(DropdownItem<T> item) predicate) {
    for (var i = 0; i < _items.length; i++) {
      if (predicate(_items[i])) {
        _items[i] = _items[i].copyWith(selected: !_items[i].selected);
      }
    }
    _reapplySearchFilter();
    notifyListeners();
    _onSelectionChanged?.call(_selectedValues);
  }

  /// selects the items that satisfy the predicate.
  ///
  /// The [predicate] parameter is a function that takes a [DropdownItem] and returns a boolean.
  void selectWhere(bool Function(DropdownItem<T> item) predicate) {
    for (var i = 0; i < _items.length; i++) {
      if (predicate(_items[i]) && !_items[i].selected) {
        _items[i] = _items[i].copyWith(selected: true);
      }
    }
    _reapplySearchFilter();
    notifyListeners();
    _onSelectionChanged?.call(_selectedValues);
  }

  void _toggleOnly(DropdownItem<T> item) {
    for (var i = 0; i < _items.length; i++) {
      if (_items[i] == item) {
        _items[i] = _items[i].copyWith(selected: !_items[i].selected);
      } else if (_items[i].selected) {
        _items[i] = _items[i].copyWith(selected: false);
      }
    }
    _reapplySearchFilter();
    notifyListeners();
    _onSelectionChanged?.call(_selectedValues);
  }

  /// unselects the items that satisfy the predicate.
  ///
  /// The [predicate] parameter is a function that takes a [DropdownItem] and returns a boolean.
  void unselectWhere(bool Function(DropdownItem<T> item) predicate) {
    for (var i = 0; i < _items.length; i++) {
      if (predicate(_items[i]) && _items[i].selected) {
        _items[i] = _items[i].copyWith(selected: false);
      }
    }
    _reapplySearchFilter();
    notifyListeners();
    _onSelectionChanged?.call(_selectedValues);
  }

  /// disables the items that satisfy the predicate.
  ///
  /// The [predicate] parameter is a function that takes a [DropdownItem] and returns a boolean.
  void disableWhere(bool Function(DropdownItem<T> item) predicate) {
    for (var i = 0; i < _items.length; i++) {
      if (predicate(_items[i]) && !_items[i].disabled) {
        _items[i] = _items[i].copyWith(disabled: true);
      }
    }
    notifyListeners();
    _onSelectionChanged?.call(_selectedValues);
  }

  /// shows the dropdown, if it is not already open.
  void openDropdown() {
    if (_open) return;

    _open = true;
    notifyListeners();
  }

  /// hides the dropdown, if it is not already closed.
  void closeDropdown() {
    if (!_open) return;

    _open = false;
    notifyListeners();
  }

  // Internal method to set the callback without a public setter.
  // ignore: use_setters_to_change_properties
  void _setOnSelectionChange(OnSelectionChanged<T>? onSelectionChanged) {
    _onSelectionChanged = onSelectionChanged;
  }

  // Internal method to set the callback without a public setter.
  // ignore: use_setters_to_change_properties
  void _setOnSearchChange(OnSearchChanged? onSearchChanged) {
    _onSearchChanged = onSearchChanged;
  }

  // Sets the custom search filter.
  // ignore: use_setters_to_change_properties
  void _setSearchFilter(SearchFilter<T>? filter) {
    _searchFilter = filter;
  }

  // sets the search query.
  // The [query] parameter is the search query.
  void _setSearchQuery(String query) {
    _searchQuery = query;
    _reapplySearchFilter();
    _onSearchChanged?.call(query);
    notifyListeners();
  }

  // clears the search query.
  void _clearSearchQuery({bool notify = false}) {
    _searchQuery = '';
    _filteredItems = List.from(_items);
    if (notify) notifyListeners();
  }

  /// Clears the current search query and resets the filtered items.
  void clearSearch() {
    _clearSearchQuery(notify: true);
  }

  @override
  void dispose() {
    if (_isDisposed) return;
    super.dispose();
    _isDisposed = true;
  }

  @override
  String toString() {
    return 'MultiSelectController(options: $_items, open: $_open)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MultiSelectController<T> &&
        listEquals(other._items, _items) &&
        other._open == _open;
  }

  @override
  int get hashCode => _items.hashCode ^ _open.hashCode;
}
