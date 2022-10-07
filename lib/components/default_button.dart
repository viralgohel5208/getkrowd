import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DefaultButton extends StatefulWidget {
  final String text;
  final GestureTapCallback onTap;
  final Color? primary;
  final Color? onPrimary;
  final Size? minimumSize;
  final double? elevation;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final Widget? childIcon;

  const DefaultButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.primary,
    this.onPrimary,
    this.minimumSize,
    this.elevation,
    this.textStyle,
    this.padding,
    this.childIcon,
  }) : super(key: key);

  @override
  _DefaultButtonState createState() => _DefaultButtonState();
}

class _DefaultButtonState extends State<DefaultButton> {
  Color defaultColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: widget.childIcon ??
          Text(
            widget.text,
            style: widget.textStyle ??
                GoogleFonts.cabin(
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                  fontSize: 24,
                ),
          ),
      onPressed: widget.onTap,
      style: ElevatedButton.styleFrom(
        padding: widget.padding,
        elevation: widget.elevation,
        minimumSize: widget.minimumSize,
        primary: widget.primary ?? defaultColor,
        onPrimary: widget.onPrimary ?? defaultColor,
      ),
    );
  }
}
