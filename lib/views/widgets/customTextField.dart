// CustomTextField component for reuse
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? hintText;
  final int? maxLines;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool enabled;
  final TextCapitalization textCapitalization;
  final FocusNode? focusNode;
  final void Function()? onEditingComplete;
  final void Function(String)? onSubmitted;
  final bool autofocus;
  final EdgeInsetsGeometry? contentPadding;

  const CustomTextField(
    this.controller,
    this.label, {
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.hintText,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.enabled = true,
    this.textCapitalization = TextCapitalization.none,
    this.focusNode,
    this.onEditingComplete,
    this.onSubmitted,
    this.autofocus = false,
    this.contentPadding,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        maxLines: maxLines,
        enabled: enabled,
        textCapitalization: textCapitalization,
        focusNode: focusNode,
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
        onSubmitted: onSubmitted,
        autofocus: autofocus,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          contentPadding: contentPadding ??
              const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.greenAccent, width: 2),
          ),
        ),
      ),
    );
  }
}
