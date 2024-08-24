import 'package:flutter/material.dart';
class MaterialButtonDesign extends StatelessWidget {
  final double height;
  final double width;
  final String text;
  final double? size;
  final void Function() onTap;
  const MaterialButtonDesign({super.key,this.size,required this.height, required this.width, required this.text, required this.onTap,});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:  const BoxDecoration(
         color:  Color(0xFF1F1A38),
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: MaterialButton(
        onPressed: onTap,
        height:height,
        minWidth: width,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child:  Text(
          text,
          textAlign: TextAlign.center,
          style:  TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              fontSize: size ?? 16.0,
              color: Colors.white),
        ),
      ),
    );
  }
}
