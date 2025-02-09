import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AmountTextField extends StatelessWidget {
  const AmountTextField({
    required this.controller,
    required this.focusNode,
    required this.onChange,
    super.key,
  });

  final FocusNode focusNode;
  final TextEditingController controller;
  final Function(String value) onChange;

  // @override
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(maxWidth: 130),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextField(
          focusNode: focusNode,
          controller: controller,
          onChanged: onChange,
          textAlign: TextAlign.right,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))],
          decoration: InputDecoration(border: InputBorder.none),
          keyboardType: TextInputType.number,
        ),
      ),
    );
  }
}
