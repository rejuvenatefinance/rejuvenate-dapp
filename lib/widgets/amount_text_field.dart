import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AmountTextField extends StatelessWidget {
  const AmountTextField({
    Key? key,
    required this.controller,
    required this.hint,
    required this.label,
    required this.formatFunction,
    this.onSubmitted,
    this.icon,
  }) : super(key: key);

  final TextEditingController controller;
  final String hint;
  final String label;
  final TextEditingValue Function(TextEditingValue, TextEditingValue)
      formatFunction;
  final void Function(String)? onSubmitted;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: Theme.of(context).colorScheme.primary,
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
        signed: false,
      ),
      inputFormatters: [
        TextInputFormatter.withFunction(formatFunction),
      ],
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        alignLabelWithHint: false,
        hintText: hint,
        labelText: label,
        border: const OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        suffixIcon: icon,
      ),
    );
  }
}
