import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String? userId;
  final String? displayname;
  final String? imageUrl;

  const HomePage({Key? key, this.userId, this.displayname, this.imageUrl})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Home"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.network(
              widget.imageUrl!,
              width: 200,
              height: 200,
            ),
            Text("User ID: ${widget.userId}"),
            Text("Display Name: ${widget.displayname}"),
          ],
        ),
      ),
    );
  }
}
