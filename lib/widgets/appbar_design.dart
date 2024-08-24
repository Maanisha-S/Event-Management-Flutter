import 'package:flutter/material.dart';

class AppBarDesign extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showLeading;
  final List<Widget>? actions;
  final bool leadingIcon;
  final double? size;
  const AppBarDesign({
    required this.title,
    this.showLeading = true,
    this.actions,
    super.key,  required this.leadingIcon, this.size,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      elevation: 0.0,
      centerTitle: true,
      title: Text(
        title,
        style:  TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
          fontSize: size ?? 21.0,
          color: Colors.white,
        ),
      ),
      leading: leadingIcon == true ?
      IconButton(
        onPressed: (){Navigator.pop(context);},
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.white,
          size: 30,
        ),
      ) : null,

      flexibleSpace: Container(
        decoration:  const BoxDecoration(
          color: Color(0xFF1F1A38),
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20.0),
          ),
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
