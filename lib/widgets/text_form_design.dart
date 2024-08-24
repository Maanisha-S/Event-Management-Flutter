import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldDesign extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final String? validatorText;
  final String? labelText;
  final int? maxLines;
  final FormFieldSetter<String>? onSaved;
  const TextFormFieldDesign({
    super.key,
    this.controller,
    this.keyboardType = TextInputType.text,
 this.validatorText, this.labelText, this.onSaved, this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return
      TextFormField(
        maxLines:maxLines ?? 1,
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Color(0xFF1F1A38),),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
            const BorderSide(color:Color(0xFF1F1A38), width: 2.0),
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),

        validator: (value) {
          if (value == null || value.isEmpty) {
            return validatorText;
          }
          return null;
        },
        onSaved: onSaved,
      );
  }
}