import 'package:flutter/material.dart';

class AppExitBox extends StatefulWidget {
  const AppExitBox({super.key});
  @override
  State<AppExitBox> createState() => _AppExitBoxState();
}

class _AppExitBoxState extends State<AppExitBox> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: AlertDialog(
        contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
        titlePadding: const EdgeInsets.all(10),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Oceanmtech DMT", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            ),
            SizedBox(height: 15),
            Align(
              alignment: Alignment.centerLeft,
              child: Text("Are you sure you want to exit ?", style: TextStyle(fontSize: 17)),
            ),
          ],
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: () {}, child: const Text("Rate Us", style: TextStyle(color: Colors.black))),
              TextButton(onPressed: () {}, child: const Text("Yes", style: TextStyle(color: Colors.black)))
            ],
          )
        ],
      ),
    );
  }
}
