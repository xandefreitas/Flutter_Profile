import 'package:flutter/material.dart';
import 'package:flutter_profile/common/widgets/custom_form_field.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders the label', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: CustomFormField(label: 'Course', controller: TextEditingController(), color: Colors.blue),
        ),
      ),
    );

    expect(find.text('Course'), findsOneWidget);
  });

  testWidgets('enforces maxLength by truncating input beyond the limit', (tester) async {
    final controller = TextEditingController();
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: CustomFormField(label: 'Course', controller: controller, color: Colors.blue, maxLength: 5),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField), 'abcdefghij');

    expect(controller.text, 'abcde');
  });

  testWidgets('onChanged fires with the entered text', (tester) async {
    String? changed;
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: CustomFormField(label: 'Course', controller: TextEditingController(), color: Colors.blue, onChanged: (value) => changed = value),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField), 'Dart');

    expect(changed, 'Dart');
  });

  testWidgets('onSaved and validator fire through the wrapping Form', (tester) async {
    final formKey = GlobalKey<FormState>();
    String? saved;
    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: Form(
            key: formKey,
            child: CustomFormField(
              label: 'Course',
              controller: TextEditingController(),
              color: Colors.blue,
              onSaved: (value) => saved = value,
              validator: (value) => (value == null || value.isEmpty) ? 'required' : null,
            ),
          ),
        ),
      ),
    );

    expect(formKey.currentState!.validate(), false);
    await tester.pump();
    expect(find.text('required'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), 'Dart');
    expect(formKey.currentState!.validate(), true);
    formKey.currentState!.save();
    expect(saved, 'Dart');
  });
}
