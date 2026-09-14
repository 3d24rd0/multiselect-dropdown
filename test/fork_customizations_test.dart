import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import 'test_helpers.dart';

void main() {
  group('Fork Customizations: openDropDown callback', () {
    testWidgets('fires openDropDown callback when dropdown is opened',
        (tester) async {
      var callbackFired = false;
      final controller = MultiSelectController<int>();

      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: createItems(3),
            controller: controller,
            openDropDown: () {
              callbackFired = true;
            },
          ),
        ),
      );

      expect(callbackFired, isFalse);

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(callbackFired, isTrue);
      controller.dispose();
    });
  });

  group('Fork Customizations: emptyItemsWidget', () {
    testWidgets('renders custom emptyItemsWidget when items list is empty in overlay mode',
        (tester) async {
      final controller = MultiSelectController<int>();

      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: const [],
            controller: controller,
            emptyItemsWidget: const Text('Custom Empty State Message'),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(find.text('Custom Empty State Message'), findsOneWidget);
      controller.dispose();
    });

    testWidgets('renders custom emptyItemsWidget in bottomSheet mode',
        (tester) async {
      final controller = MultiSelectController<int>();

      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: const [],
            dropdownMode: DropdownMode.bottomSheet,
            controller: controller,
            emptyItemsWidget: const Text('Sin elementos encontrados'),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(find.text('Sin elementos encontrados'), findsOneWidget);
      controller.dispose();
    });
  });

  group('Fork Customizations: errorIcon and custom error layout', () {
    testWidgets('renders custom errorIcon and errorStyle when validation fails',
        (tester) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: MultiDropdown<int>(
                items: createItems(3),
                validator: (selected) {
                  if (selected == null || selected.isEmpty) {
                    return 'Please select an option';
                  }
                  return null;
                },
                fieldDecoration: const FieldDecoration(
                  errorIcon: Icon(Icons.warning, key: Key('custom-error-icon')),
                  errorStyle: TextStyle(color: Colors.purple, fontSize: 13),
                ),
              ),
            ),
          ),
        ),
      );

      formKey.currentState!.validate();
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('custom-error-icon')), findsOneWidget);
      expect(find.text('Please select an option'), findsOneWidget);

      final textWidget =
          tester.widget<Text>(find.text('Please select an option'));
      expect(textWidget.style?.color, Colors.purple);
    });
  });

  group('Fork Customizations: Localized Tooltips and Semantics', () {
    testWidgets(
        'custom deleteTooltipBuilder and deleteSemanticsLabelBuilder on ChipDecoration',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: const [
              DropdownItem(label: 'España', value: 1, selected: true),
            ],
            chipDecoration: ChipDecoration(
              deleteTooltipBuilder: (label) => 'Eliminar $label',
              deleteSemanticsLabelBuilder: (label) => 'Quitar elemento $label',
            ),
          ),
        ),
      );

      expect(find.byTooltip('Eliminar España'), findsOneWidget);

      final semantics = find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.label == 'Quitar elemento España',
      );
      expect(semantics, findsOneWidget);
    });

    testWidgets(
        'no tooltip rendered on chip delete icon when deleteTooltipBuilder is null',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          const MultiDropdown<int>(
            items: [
              DropdownItem(label: 'España', value: 1, selected: true),
            ],
          ),
        ),
      );

      expect(find.byTooltip('Remove España'), findsNothing);
    });

    testWidgets('custom clearTooltip and clearSemanticsLabel on FieldDecoration',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          const MultiDropdown<int>(
            items: [
              DropdownItem(label: 'Opción 1', value: 1, selected: true),
            ],
            fieldDecoration: FieldDecoration(
              clearTooltip: 'Borrar selección',
              clearSemanticsLabel: 'Limpiar todas las selecciones',
            ),
          ),
        ),
      );

      expect(find.byTooltip('Borrar selección'), findsOneWidget);

      final semantics = find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.label == 'Limpiar todas las selecciones',
      );
      expect(semantics, findsOneWidget);
    });

    testWidgets('custom semanticsLabel on FieldDecoration', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          const MultiDropdown<int>(
            items: [],
            fieldDecoration: FieldDecoration(
              semanticsLabel: 'Campo desplegable multiselección',
            ),
          ),
        ),
      );

      final semantics = find.byWidgetPredicate(
        (widget) =>
            widget is Semantics &&
            widget.properties.label == 'Campo desplegable multiselección',
      );
      expect(semantics, findsOneWidget);
    });

    testWidgets('custom overflowLabelBuilder with Spanish localization',
        (tester) async {
      final items = List.generate(
        5,
        (i) => DropdownItem(label: 'Elem ${i + 1}', value: i + 1, selected: true),
      );

      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: items,
            chipDecoration: ChipDecoration(
              maxDisplayCount: 2,
              overflowLabelBuilder: (n) => '+$n más',
            ),
          ),
        ),
      );

      expect(find.text('Elem 1'), findsOneWidget);
      expect(find.text('Elem 2'), findsOneWidget);
      expect(find.text('+3 más'), findsOneWidget);
    });
  });

  group('Fork Customizations: Bottom Sheet Single Select Mode', () {
    testWidgets('tapping an item in singleSelect bottom sheet pops sheet',
        (tester) async {
      final controller = MultiSelectController<int>();

      await tester.pumpWidget(
        buildTestApp(
          MultiDropdown<int>(
            items: createItems(3),
            dropdownMode: DropdownMode.bottomSheet,
            singleSelect: true,
            controller: controller,
          ),
        ),
      );

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      expect(find.byType(BottomSheet), findsOneWidget);

      await tester.tap(find.widgetWithText(ListTile, 'Item 2'));
      await tester.pumpAndSettle();

      expect(controller.selectedItems.length, 1);
      expect(controller.selectedItems.first.label, 'Item 2');
      expect(find.byType(BottomSheet), findsNothing);

      controller.dispose();
    });
  });

  group('Fork Customizations: Edge Cases & Robustness', () {
    test('DropdownItem.toJson() produces valid JSON string', () {
      const item = DropdownItem<int>(
        label: 'Prueba',
        value: 42,
        selected: true,
        disabled: false,
      );

      final jsonString = item.toJson();
      expect(jsonString, isA<String>());
      expect(jsonString, contains('"label":"Prueba"'));
      expect(jsonString, contains('"value":42'));
      expect(jsonString, contains('"selected":true'));
      expect(jsonString, contains('"disabled":false'));
    });

    test('addItem with negative or out-of-bounds index appends safely', () {
      final controller = MultiSelectController<int>()
        ..setItems([
          const DropdownItem(label: 'Item 1', value: 1),
        ])
        ..addItem(const DropdownItem(label: 'Item 2', value: 2), index: 999);
      expect(controller.items.length, 2);
      expect(controller.items.last.label, 'Item 2');

      controller.addItem(const DropdownItem(label: 'Item 3', value: 3), index: -5);
      expect(controller.items.length, 3);
      expect(controller.items.last.label, 'Item 3');

      controller.dispose();
    });

    testWidgets('didUpdateWidget updates internal items when items prop changes',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          const MultiDropdown<int>(
            items: [
              DropdownItem(label: 'A', value: 1),
            ],
          ),
        ),
      );

      await tester.tap(find.byType(InkWell).first);
      await tester.pumpAndSettle();

      expect(find.text('A'), findsWidgets);

      // Rebuild with new items
      await tester.pumpWidget(
        buildTestApp(
          const MultiDropdown<int>(
            items: [
              DropdownItem(label: 'B', value: 2),
              DropdownItem(label: 'C', value: 3),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('B'), findsWidgets);
      expect(find.text('C'), findsWidgets);
    });
  });
}
