import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget with PreferredSizeWidget {
  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(55);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar();
  }
}
