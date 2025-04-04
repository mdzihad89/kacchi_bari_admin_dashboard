import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/color_constants.dart';

class CTextFormField extends StatefulWidget {
  final String labelText;
  final String validatorText;
  final TextEditingController textEditingController;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final bool? readOnly;
  const CTextFormField({super.key, required this.labelText, required this.validatorText, required this.textEditingController,this.onChanged, this.onTap, this.inputFormatters, this.readOnly});

  @override
  State<CTextFormField> createState() => _CTextFormFieldState();
}

class _CTextFormFieldState extends State<CTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextFormField(
        inputFormatters: widget.inputFormatters ?? [],
        maxLines: 1,
        onTap: widget.onTap,
        controller:widget.textEditingController,
        style: Theme.of(context).textTheme.bodyMedium,

        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorConstants.primaryColor),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorConstants.primaryColor),
              borderRadius: BorderRadius.circular(10),
            ),
            errorBorder:  OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(10),
            ),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorConstants.primaryColor),
              borderRadius: BorderRadius.circular(10),
            ),
            labelText: widget.labelText,
            labelStyle: Theme.of(context).textTheme.bodyMedium,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return widget.validatorText;
          }
          return null;
        },
        onChanged: widget.onChanged,
        readOnly: widget.readOnly ?? false,
      ),
    );
  }
}
