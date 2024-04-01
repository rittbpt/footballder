import 'package:flutter_application_1/src/pages/home/matched.dart';
import 'package:flutter_application_1/src/pages/tinder/drag.dart';
import 'package:flutter_application_1/src/pages/tinder/tinder.dart';
import 'package:flutter_application_1/src/pages/tinder/actionButton.dart';
import 'package:flutter_application_1/src/pages/tinder/profile.dart';
import 'package:flutter_application_1/src/pages/tinder/profileCard.dart';
import 'package:flutter_application_1/src/pages/api_service.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/pages/tinder/tinderBackground.dart';

class CardsStackWidget extends StatefulWidget {
  const CardsStackWidget({Key? key}) : super(key: key);

  @override
  State<CardsStackWidget> createState() => _CardsStackWidgetState();
}

class _CardsStackWidgetState extends State<CardsStackWidget>
    with SingleTickerProviderStateMixin {
  ValueNotifier<Swipe> swipeNotifier = ValueNotifier(Swipe.none);
  late final AnimationController _animationController;
  late Future<List<Profile>> futureProfileList;
  List<Profile> ProfileList = [];
  String userId = globalApiResponse!.userData!['id'];
  bool isReloading = false;

  Future<List<Profile>> fetchData() async {
    try {
      final response =
          await getApi('http://localhost:3099/getallmatch/${userId}');
      print(userId);

      if (response.statusCode == 200) {
        // Parse the response data
        Map<String, dynamic> responseData = response.data;
        print(responseData);
        print("responseData");

        if (responseData.containsKey('data')) {
          List<dynamic> requestJsonList = responseData['data'];

          // Create StadiumInfo objects from the fetched data
          ProfileList =
              requestJsonList.map((json) => Profile.fromJson(json)).toList();
        } else {
          throw Exception('Data format is incorrect');
        }
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (error) {
      print('Error: $error');
    }
    print(ProfileList);

    return ProfileList;
  }

  @override
  void initState() {
    super.initState();
    futureProfileList = fetchData();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        ProfileList.removeLast();
        _animationController.reset();
        swipeNotifier.value = Swipe.none;
      }
    });
    Timer(Duration(seconds: 3), () {
      // After 5 seconds, trigger a reload
      setState(() {
        isReloading = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(ProfileList[1]);
    final TextEditingController _positionController = TextEditingController();

    return Scaffold(
        body: Center(
            child: !isReloading
                ? CircularProgressIndicator(
                    color: Color(0xFF146001),
                  )
                // return
                : Stack(
                    clipBehavior: Clip.none,
                    children: [
                      BackgroudCurveWidget(),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: ValueListenableBuilder(
                          valueListenable: swipeNotifier,
                          builder: (context, swipe, _) => Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children:
                                List.generate(ProfileList.length, (index) {
                              if (index == ProfileList.length - 1) {
                                return PositionedTransition(
                                  rect: RelativeRectTween(
                                    begin: RelativeRect.fromSize(
                                        const Rect.fromLTWH(0, 0, 580, 340),
                                        const Size(580, 340)),
                                    end: RelativeRect.fromSize(
                                        Rect.fromLTWH(
                                            swipe != Swipe.none
                                                ? swipe == Swipe.left
                                                    ? -300
                                                    : 300
                                                : 0,
                                            0,
                                            580,
                                            340),
                                        const Size(580, 340)),
                                  ).animate(CurvedAnimation(
                                    parent: _animationController,
                                    curve: Curves.easeInOut,
                                  )),
                                  child: Stack(
                                    children: [
                                      RotationTransition(
                                        turns: Tween<double>(
                                                begin: 0,
                                                end: swipe != Swipe.none
                                                    ? swipe == Swipe.left
                                                        ? -0.1 * 0.3
                                                        : 0.1 * 0.3
                                                    : 0.0)
                                            .animate(
                                          CurvedAnimation(
                                            parent: _animationController,
                                            curve: const Interval(0, 0.4,
                                                curve: Curves.easeInOut),
                                          ),
                                        ),
                                        child: DragWidget(
                                          profile: ProfileList[index],
                                          // index: index,
                                          swipeNotifier: swipeNotifier,
                                          isLastCard: true,
                                        ),
                                      ),
                                      // Positioned(
                                      //   bottom: 10,
                                      //   left: 0,
                                      //   right: 0,
                                      //   child: Padding(
                                      //     padding: const EdgeInsets.only(
                                      //         bottom: 6.0),
                                      //     child: Row(
                                      //       mainAxisAlignment:
                                      //           MainAxisAlignment.center,
                                      //       children: [
                                      //         ActionButtonWidget(
                                      //           onPressed: () {
                                      //             swipeNotifier.value =
                                      //                 Swipe.left;
                                      //             _animationController
                                      //                 .forward();
                                      //           },
                                      //           icon: const Icon(
                                      //             Icons.close,
                                      //             color: Color(0xFFD94A38),
                                      //           ),
                                      //           borderColor: Color(0xFFD94A38),
                                      //         ),
                                      //         const SizedBox(width: 20),
                                      //         ActionButtonWidget(
                                      //           onPressed: () {
                                      //             swipeNotifier.value =
                                      //                 Swipe.right;
                                      //             showDialog(
                                      //               context: context,
                                      //               builder:
                                      //                   (BuildContext context) {
                                      //                 return AlertDialog(
                                      //                   backgroundColor:
                                      //                       const Color
                                      //                           .fromARGB(255,
                                      //                           255, 255, 255),
                                      //                   title: Text('Position'),
                                      //                   content: TextField(
                                      //                     controller:
                                      //                         _positionController,
                                      //                     decoration:
                                      //                         InputDecoration(
                                      //                       hintText:
                                      //                           'Enter your position',
                                      //                     ),
                                      //                   ),
                                      //                   actions: [
                                      //                     TextButton(
                                      //                       onPressed: () {
                                      //                         // Add logic to save friend's name
                                      //                         String position =
                                      //                             _positionController
                                      //                                 .text;

                                      //                         int currentIndex =
                                      //                             index;
                                      //                         int currentMatchId =
                                      //                             ProfileList[
                                      //                                     currentIndex]
                                      //                                 .matchId;
                                      //                         request(position,
                                      //                             currentMatchId);
                                      //                         Navigator.of(
                                      //                                 context)
                                      //                             .pop();
                                      //                       },
                                      //                       child:
                                      //                           Text('Request'),
                                      //                       style: TextButton
                                      //                           .styleFrom(
                                      //                         primary: Color(
                                      //                             0xFF146001), // Set the text color here
                                      //                       ),
                                      //                     ),
                                      //                   ],
                                      //                 );
                                      //               },
                                      //             );
                                      //             _animationController
                                      //                 .forward();
                                      //           },
                                      //           icon: const Icon(
                                      //             Icons.favorite,
                                      //             color: Color(0xFF146001),
                                      //           ),
                                      //           borderColor: Color(0xFF146001),
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                );
                              } else {
                                return Stack(
                                  children: [
                                    DragWidget(
                                      profile: ProfileList[index],
                                      isLastCard: false,
                                      // index: index,
                                      swipeNotifier: swipeNotifier,
                                    ),
                                    // Positioned(
                                    //     bottom: 10,
                                    //     left: 0,
                                    //     right: 0,
                                    //     child: Padding(
                                    //       padding: const EdgeInsets.only(
                                    //           bottom: 6.0),
                                    //       child: Row(
                                    //         mainAxisAlignment:
                                    //             MainAxisAlignment.center,
                                    //         children: [
                                    //           ActionButtonWidget(
                                    //             onPressed: () {
                                    //               swipeNotifier.value =
                                    //                   Swipe.left;
                                    //               _animationController
                                    //                   .forward();
                                    //             },
                                    //             icon: const Icon(
                                    //               Icons.close,
                                    //               color: Color(0xFFD94A38),
                                    //             ),
                                    //             borderColor: Color(0xFFD94A38),
                                    //           ),
                                    //           const SizedBox(width: 20),
                                    //           ActionButtonWidget(
                                    //             onPressed: () {
                                    //               swipeNotifier.value =
                                    //                   Swipe.right;
                                    //               showDialog(
                                    //                 context: context,
                                    //                 builder:
                                    //                     (BuildContext context) {
                                    //                   return AlertDialog(
                                    //                     backgroundColor:
                                    //                         const Color
                                    //                             .fromARGB(255,
                                    //                             255, 255, 255),
                                    //                     title: Text('Position'),
                                    //                     content: TextField(
                                    //                       controller:
                                    //                           _positionController,
                                    //                       decoration:
                                    //                           InputDecoration(
                                    //                         hintText:
                                    //                             'Enter your position',
                                    //                       ),
                                    //                     ),
                                    //                     actions: [
                                    //                       TextButton(
                                    //                         onPressed: () {
                                    //                           // Add logic to save friend's name
                                    //                           String position =
                                    //                               _positionController
                                    //                                   .text;

                                    //                           int currentIndex =
                                    //                               index;
                                    //                           int currentMatchId =
                                    //                               ProfileList[
                                    //                                       currentIndex]
                                    //                                   .matchId;
                                    //                           request(position,
                                    //                               currentMatchId);
                                    //                           Navigator.of(
                                    //                                   context)
                                    //                               .pop();
                                    //                         },
                                    //                         child:
                                    //                             Text('Request'),
                                    //                         style: TextButton
                                    //                             .styleFrom(
                                    //                           primary: Color(
                                    //                               0xFF146001), // Set the text color here
                                    //                         ),
                                    //                       ),
                                    //                     ],
                                    //                   );
                                    //                 },
                                    //               );
                                    //               // _animationController
                                    //               //     .forward();
                                    //             },
                                    //             icon: const Icon(
                                    //               Icons.favorite,
                                    //               color: Color(0xFF146001),
                                    //             ),
                                    //             borderColor: Color(0xFF146001),
                                    //           ),
                                    //         ],
                                    //       ),
                                    //     ),
                                    //   ),

                                  ],
                                );
                              }
                            }),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ActionButtonWidget(
                                onPressed: () {
                                  swipeNotifier.value = Swipe.left;
                                  _animationController.forward();
                                },
                                icon: const Icon(
                                  Icons.close,
                                  color: Color(0xFFD94A38),
                                ),
                                borderColor: Color(0xFFD94A38),
                              ),
                              const SizedBox(width: 20),
                              ActionButtonWidget(
                                onPressed: () {
                                  // swipeNotifier.value = Swipe.right;
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: const Color.fromARGB(
                                            255, 255, 255, 255),
                                        title: Text('Position'),
                                        content: TextField(
                                          controller: _positionController,
                                          decoration: InputDecoration(
                                            hintText: 'Enter your position',
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              // Add logic to save friend's name
                                              String position =
                                                  _positionController.text;
                                              int currentIndex =
                                                  ProfileList.length - 1;

                                              int currentMatchId =
                                                  ProfileList[currentIndex]
                                                      .matchId;
                                              print(
                                                  "this is matchid  ${currentIndex}");
                                              print(
                                                  "this is matchid  ${ProfileList[currentIndex].matchName}");
                                              request(position, currentMatchId);
                                              _positionController.clear();

                                              Navigator.of(context).pop();
                                            },
                                            child: Text('Request'),
                                            style: TextButton.styleFrom(
                                              primary: Color(
                                                  0xFF146001), // Set the text color here
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  // _animationController.forward();
                                },
                                icon: const Icon(
                                  Icons.favorite,
                                  color: Color(0xFF146001),
                                ),
                                borderColor: Color(0xFF146001),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        child: DragTarget<int>(
                          builder: (
                            BuildContext context,
                            List<dynamic> accepted,
                            List<dynamic> rejected,
                          ) {
                            return IgnorePointer(
                              child: Container(
                                height: 700.0,
                                width: 80.0,
                                color: Colors.transparent,
                              ),
                            );
                          },
                          onAccept: (int index) {
                            setState(() {
                              ProfileList.removeAt(index);
                            });
                          },
                        ),
                      ),
                      Positioned(
                        right: 0,
                        child: DragTarget<int>(
                          builder: (
                            BuildContext context,
                            List<dynamic> accepted,
                            List<dynamic> rejected,
                          ) {
                            return IgnorePointer(
                              child: Container(
                                height: 700.0,
                                width: 80.0,
                                color: Colors.transparent,
                              ),
                            );
                          },
                          onAccept: (int index) {
                            setState(() {
                              ProfileList.removeAt(index);
                            });
                          },
                        ),
                      ),
                    ],
                  )));
    // }
    // },
    // );
  }

  void request(String position, int matchId) async {
    // int MatchId = findMatch.matchId;
    String Position = position;
    String userid = userId;
    String apiUrl = 'http://localhost:3099/insertrequest';

    Map<String, dynamic> requestBody = {
      'MatchId': matchId,
      'Position': Position,
      'userId': userid
    };

    try {
      var response = await postApi(apiUrl, requestBody);

      // Handle the API response
      if (response.statusCode == 200) {
        // API call was successful
        print('API Response: ${response.statusCode} ${response.data}');
        print('match ${matchId}');
        print('match ${Position}');
        print('match ${userid}');
        swipeNotifier.value = Swipe.right;
        _animationController.forward();

        // Navigate back to the login page
        // Navigator.pop(context);
      } else {
        // API call was not successful
        print('API Response: ${response.statusCode} ${response.data}');

        // Handle other responses or show an error message
        // handleApiError(context, response);
      }
    } catch (error) {
      // Handle errors
      print('Error: $error');
    }
  }
}
