import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/pages/tinder/tag.dart';
import 'package:flutter_application_1/src/pages/tinder/profile.dart';
import 'package:flutter_application_1/src/pages/tinder/profileCard.dart';
import 'package:flutter_application_1/src/pages/tinder/tinder.dart';

class DragWidget extends StatefulWidget {
  const DragWidget({
    Key? key,
    required this.profile,
    required this.swipeNotifier,
    required this.isLastCard,
  }) : super(key: key);

  final Profile profile;
  final ValueNotifier<Swipe> swipeNotifier;
  final bool isLastCard;

  @override
  _DragWidgetState createState() => _DragWidgetState();
}

class _DragWidgetState extends State<DragWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          // _showAlertDialog(context);
        },
        child: ValueListenableBuilder(
          valueListenable: widget.swipeNotifier,
          builder: (context, swipe, _) {
            return Stack(
              children: [
                ProfileCard(profile: widget.profile),
                swipe != Swipe.none && widget.isLastCard
                    ? swipe == Swipe.right
                        ? Positioned(
                            top: 40,
                            left: 20,
                            child: Transform.rotate(
                              angle: 12,
                              child: TagWidget(
                                text: 'LIKE',
                                color: Colors.green[400]!,
                              ),
                            ),
                          )
                        : Positioned(
                            top: 50,
                            right: 24,
                            child: Transform.rotate(
                              angle: -12,
                              child: TagWidget(
                                text: 'DISLIKE',
                                color: Colors.red[400]!,
                              ),
                            ),
                          )
                    : const SizedBox.shrink(),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Tap Action"),
          content: Text("You tapped on the profile card!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
