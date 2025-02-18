import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool isPassword;
  final List<String> validationRules;
  final Function(String?) validator;
  final TextEditingController?
      passwordController; // For confirm password validation

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.isPassword,
    required this.validationRules,
    required this.validator,
    this.passwordController,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  List<bool> get _validationResults {
    final value = widget.controller.text;
    if (widget.label == 'Email') {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      return [value.isNotEmpty && emailRegex.hasMatch(value)];
    } else if (widget.label == 'Password') {
      return [
        value.length >= 6,
        value.contains(RegExp(r'[A-Z]')),
        value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')),
      ];
    } else if (widget.label == 'Confirm Password') {
      return [value.isNotEmpty && value == widget.passwordController?.text];
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final validationResults = _validationResults;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Focus(
          onFocusChange: (hasFocus) {
            setState(() {
              _isFocused = hasFocus;
            });
          },
          child: TextFormField(
            controller: widget.controller,
            obscureText: widget.isPassword,
            decoration: InputDecoration(
              labelText: widget.label,
              border: const OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: _getBorderColor(validationResults),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: _getBorderColor(validationResults),
                  width: 2,
                ),
              ),
            ),
          ),
        ),
        if (_isFocused || widget.controller.text.isNotEmpty) ...[
          const SizedBox(height: 8),
          ...List.generate(
            widget.validationRules.length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                widget.validationRules[index],
                style: TextStyle(
                  color: widget.controller.text.isEmpty
                      ? Colors.grey
                      : validationResults[index]
                          ? Colors.green
                          : Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Color _getBorderColor(List<bool> validationResults) {
    if (widget.controller.text.isEmpty) {
      return Colors.grey;
    }
    return validationResults.every((result) => result)
        ? Colors.green
        : Colors.red;
  }
}
