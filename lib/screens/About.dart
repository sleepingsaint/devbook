import 'package:flutter/material.dart';
import 'package:devbook/config.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  void initState() {
    theme.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.brightness_3),
                Switch(
                  value: theme.currentTheme() == ThemeMode.light,
                  onChanged: (val) => theme.switchTheme(),
                  activeColor: Colors.amber,
                ),
                Icon(Icons.wb_sunny),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
