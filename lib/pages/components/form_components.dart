import 'package:flutter/material.dart';

class FormComponents {
  static Widget formGroupTitle(String title) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Text(title, style: const TextStyle(fontSize: 20)),
    );
  }

  static Widget formTextInput(
      {required String label,
      required TextEditingController controller,
      String? Function(String? value)? validator}) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: controller,
        decoration: InputDecoration(
            hintText: label,
            labelText: label,
            border: const OutlineInputBorder()),
        validator: validator,
      ),
    );
  }

  static Widget formNumberInput(
      {required String label,
        required TextEditingController controller,
        String? Function(String? value)? validator}) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: controller,
        decoration: InputDecoration(
            hintText: label,
            labelText: label,
            border: const OutlineInputBorder()),
        validator: validator,
      ),
    );
  }

  static Widget formDropdown<T>({
    required String label,
    required List<T> list,
    required TextEditingController controller,
    required Widget Function(T val) dropDownMenuItemChild
  }) {
    return Container(
        padding: const EdgeInsets.all(5.0),
        child: DropdownMenu(
            controller: controller,
            label: Text(label),
            hintText: label,
            dropdownMenuEntries: list.map((e) => DropdownMenuEntry(labelWidget: dropDownMenuItemChild(e), value: e, label: e.toString())).toList(),
        ));
  }
}
