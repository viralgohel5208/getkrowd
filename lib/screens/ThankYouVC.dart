import 'package:flutter/material.dart';

class ThankYouVC extends StatefulWidget {
  const ThankYouVC({Key? key}) : super(key: key);

  @override
  State<ThankYouVC> createState() => _ThankYouVCState();
}

class _ThankYouVCState extends State<ThankYouVC> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "Thank you!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
