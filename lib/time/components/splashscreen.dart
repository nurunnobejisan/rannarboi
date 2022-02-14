import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          children: <Widget>[
            Image(
              image: const AssetImage("assets/chef-hat.png"),
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            const Text(
              "Sous Chef",
              style: TextStyle(color: Colors.white, fontSize: 5, fontWeight: FontWeight.bold)

            ),
            const CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}
