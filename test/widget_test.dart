import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:my_commons/my_commons.dart';

void main() {
  final dropdownField = find.byType(DropdownButtonFormField<int?>);
  final dropdownButton = find.byType(DropdownButton<int?>);

  Finder dropdownOption(String label) => find
      .ancestor(of: find.text(label), matching: find.byType(InkWell))
      .hitTestable();

  testWidgets('checkboxes update the selection and invoke the callback', (
    tester,
  ) async {
    final selected = <String>[];
    var changes = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => buildCheckboxes(
              activeColor: Colors.blue,
              displayMap: const {'a': 'Option A'},
              selectedList: selected,
              callbackFn: () => setState(() => changes++),
            ),
          ),
        ),
      ),
    );

    final checkbox = find.byType(Checkbox);
    expect(tester.widget<Checkbox>(checkbox).value, isFalse);
    await tester.tap(checkbox);
    await tester.pumpAndSettle();
    expect(tester.widget<Checkbox>(checkbox).value, isTrue);
    expect(selected, ['a']);
    expect(changes, 1);

    await tester.tap(checkbox);
    await tester.pumpAndSettle();
    expect(tester.widget<Checkbox>(checkbox).value, isFalse);
    expect(selected, isEmpty);
    expect(changes, 2);
  });

  testWidgets('dropdown displays the selection and reports a new value', (
    tester,
  ) async {
    final values = <int?>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: buildDropdownList(
            selected: 1,
            init: null,
            displayMap: const {1: 'First', 2: 'Second'},
            callbackFn: values.add,
          ),
        ),
      ),
    );

    final field = tester.state<FormFieldState<int?>>(dropdownField);
    expect(field.value, 1);
    await tester.tap(dropdownButton);
    await tester.pumpAndSettle();
    await tester.tap(dropdownOption('Second').last);
    await tester.pumpAndSettle();
    expect(values, [2]);
    expect(field.value, 2);
  });

  testWidgets('disabled dropdown does not open or report a value', (
    tester,
  ) async {
    final values = <int?>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: buildDropdownList(
            selected: 1,
            init: null,
            displayMap: const {1: 'First', 2: 'Second'},
            callbackFn: values.add,
            enabled: false,
          ),
        ),
      ),
    );

    expect(
      tester.widget<DropdownButtonFormField<int?>>(dropdownField).enabled,
      isFalse,
    );
    await tester.tap(dropdownButton);
    await tester.pumpAndSettle();
    expect(dropdownOption('Second'), findsNothing);
    expect(values, isEmpty);
  });
}
