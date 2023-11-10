import 'package:flutter/material.dart';

class OtobusErrorWidget extends StatelessWidget {
  final String errorText;

  const OtobusErrorWidget({super.key, required this.errorText});


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: Colors.redAccent),
      child: ListTile(
          title: Text(errorText)),
    );
  }
}