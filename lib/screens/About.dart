import 'package:flutter/material.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Devbook",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline5,
          ),
          Text(
            "Encyclopedia for developers",
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 5.0,
          ),
          Text("Inspired from facebook feed"),
          SizedBox(
            height: 20.0,
          ),
          Text("Made with ❤️ by sleepingsaint"),
        ],
      ),
    );
  }
}
