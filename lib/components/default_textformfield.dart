import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getkrowd/constants/global_theming.dart';
import 'package:google_fonts/google_fonts.dart';

class DefaultTextField extends StatefulWidget {
  final String? placeholder;
  final String label;
  final bool obscureText;
  final String? sampleText;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final String? hintText;
  final String? errorText;
  final TextEditingController? controller;
  final bool? autoFocus;
  final int? maxLines;
  final Color? fillColor;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final EdgeInsetsGeometry? contentPadding;
  final Widget? suffixIcon;
  final InputBorder? enabledBorder;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final Function(String)? onSaved;
  final List<TextInputFormatter>? inputParameters;

  const DefaultTextField({
    Key? key,
    this.placeholder,
    this.label = "",
    this.obscureText = false,
    this.sampleText,
    this.onChanged,
    this.validator,
    this.hintText,
    this.errorText,
    this.controller,
    this.autoFocus,
    this.maxLines,
    this.fillColor,
    this.textStyle,
    this.contentPadding,
    this.suffixIcon,
    this.enabledBorder,
    this.hintStyle,
    this.textInputType,
    this.textInputAction,
    this.onSaved,
    this.inputParameters,
  }) : super(key: key);

  @override
  _DefaultTextFieldState createState() => _DefaultTextFieldState();
}

class _DefaultTextFieldState extends State<DefaultTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: TextFormField(
        textInputAction: widget.textInputAction ?? TextInputAction.next,
        keyboardType: widget.textInputType,
        autovalidateMode: AutovalidateMode.always,
        obscureText: widget.obscureText,
        initialValue: widget.sampleText,
        validator: widget.validator,
        controller: widget.controller,
        autofocus: widget.autoFocus ?? false,
        maxLines: widget.maxLines ?? 1,
        onTap: () {},
        style: widget.textStyle,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onSaved,
        inputFormatters: widget.inputParameters,
        // inputFormatters: [
        //   FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,4}'))
        // ],
        decoration: InputDecoration(
          contentPadding: widget.contentPadding ?? const EdgeInsets.all(10),
          border: InputBorder.none,
          fillColor: widget.fillColor ?? Colors.white,
          filled: true,
          errorText: widget.errorText,
          hintText: widget.hintText,
          hintStyle: widget.hintStyle ??
              GoogleFonts.cabin(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
                color: colorGray,
              ),
          suffixIcon: widget.suffixIcon,
          labelStyle: GoogleFonts.cabin(
            fontSize: 14.0,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
          enabledBorder: widget.enabledBorder ??
              OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(
                  color: colorGray,
                  width: 1.0,
                ),
              ),
        ),
      ),
    );
  }
}
