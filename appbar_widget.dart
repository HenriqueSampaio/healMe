import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

AppBar buildAppBar(BuildContext context){
  const icon = CupertinoIcons.moon_stars;
  return AppBar(
    title: Text("healMe"),
    backgroundColor: Colors.transparent,
    actions: [
      IconButton(
        icon: const Icon(icon),
        onPressed: (){},
      ),
    ],
  );
}