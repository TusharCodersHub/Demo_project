import 'package:demo_project/view/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:demo_project/view/home.dart';

class Home extends StatefulWidget {
  final User user;

  const Home({Key? key, required this.user}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.yellow.shade50,
          title: Text(
            "Welcome",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Profile(user: widget.user),
                  ),
                );
              },
              icon: Icon(Icons.account_circle, size: 35),
            )
          ],
        ),
        body: OrientationBuilder(
          builder: (context, orientation) {
            final screenWidth = MediaQuery.of(context).size.width;
            final screenHeight = MediaQuery.of(context).size.height;

            final isPortrait = orientation == Orientation.portrait;
            final crossAxisCount = isPortrait ? 2 : 6;
            final containerHeight = isPortrait
                ? screenHeight / 6.8
                : screenHeight / 2.8;
            final containerWidth = screenWidth / crossAxisCount;

            return Container(
              color: Colors.yellow.shade300,
              child: Stack(
                children: [
                  GridView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio:
                      (screenWidth / crossAxisCount) / containerHeight,
                    ),
                    itemCount: img.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          final snackBar = SnackBar(
                            content: Text("Clicked on ${imgName[index]}"),
                            duration: Duration(seconds: 1),
                          );
                          ScaffoldMessenger.of(context)
                              .showSnackBar(snackBar);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.deepOrange, blurRadius: 13)
                            ],
                            border: Border.all(color: Colors.black),
                            image: DecorationImage(
                              image: AssetImage(img[index]),
                              fit: BoxFit.fill,
                            ),
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: EdgeInsets.all(10),
                        ),
                      );
                    },
                  ),
                  ...List.generate(
                      (crossAxisCount - 1) * ((isPortrait ? 6 : 2) - 1),
                          (index) {
                        final row = (index ~/ (crossAxisCount - 1)) + 1;
                        final col = (index % (crossAxisCount - 1)) + 1;
                        final left = containerWidth * col - 26;
                        final top = containerHeight * row - 25;
                        return Positioned(
                          left: left,
                          top: top,
                          child: CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.orange.shade300,
                            child: InkWell(
                              onTap: () {
                                final snackBar = SnackBar(
                                  content: Text("You select ${index + 1}"),
                                  duration: Duration(seconds: 1),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              },
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 28),
                              ),
                            ),
                          ),
                        );
                      }),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

List<String> img = [
  "assets/images/umb.png",
  "assets/images/kite.png",
  "assets/images/football.png",
  "assets/images/lattu.png",
  "assets/images/sun.png",
  "assets/images/flower.png",
  "assets/images/diya.png",
  "assets/images/fly.png",
  "assets/images/cow.png",
  "assets/images/pigeon.png",
  "assets/images/glass.png",
  "assets/images/rabbit.png",
];

List<String> imgName = [
  "Umbrella",
  "Kite",
  "Football",
  "Spinner",
  "Sun",
  "Flower",
  "Diya",
  "ButterFly",
  "Cow",
  "Pigeon",
  "Glass",
  "Rabbit",
];
