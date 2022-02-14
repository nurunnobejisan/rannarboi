
import 'dart:io';
import 'package:cookbook/GamePage1/game.dart';
import 'package:cookbook/popmore/privacy_policy.dart';
import 'package:cookbook/time/time.dart';
import 'package:cookbook/widgets/categories.dart';
import 'package:cookbook/widgets/food_showcase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../popmore/about me.dart';
import 'package:flutter/services.dart';




class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Text(
                "রান্নার বই",
                style: TextStyle(
                  fontSize: 22,
                  color: Color(0xfff55a00),
                ),
              ),
              const Spacer(),
              MyPopupMenu(
                child: Icon(
                  Icons.menu_rounded,
                  key: GlobalKey(),
                  color: const Color(0xfff55a00),
                  size: 30,
                ),
              ),
            ],
          ),
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: const [
                    Text(
                      "আপনি আজ কি রান্না করতে চান?",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 30,
                      ),
                    ),
                    // SizedBox(
                    //   height: 16,
                    // ),
                    // Searchbar(),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.timer,
                ),
                color: Colors.orange,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const cooking_timeApp(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.timer,
                ),
                color: Colors.orange,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => cookbook(),
                    ),
                  );
                },
              ),

              const SizedBox(
                height: 20,
              ),
              const Categories(),
              const SizedBox(
                height: 20,
              ),
              Divider(
                height: 10,
                thickness: 0.2,
                indent: 25,
                endIndent: 25,
                color: Theme
                    .of(context)
                    .primaryColorDark,
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "আপনার জন্য প্রস্তাবিত",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  FoodShowcase()
                ],
              ),
            ],
          ),
        ));
  }
  }

class MyPopupMenu extends StatefulWidget {
  final Widget child;

  MyPopupMenu({Key? key, required this.child})
      : assert(child.key != null),
        super(key: key);

  @override
  _MyPopupMenuState createState() => _MyPopupMenuState();
}

class _MyPopupMenuState extends State<MyPopupMenu> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: widget.child,
      onTap: _showPopupMenu,
    );
  }

  void _showPopupMenu() {
    //Find renderbox object
    RenderBox renderBox = (widget.child.key as GlobalKey)
        .currentContext
        ?.findRenderObject() as RenderBox;
    Offset position = renderBox.localToGlobal(Offset.zero);

    showCupertinoDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return PopupMenuContent(
            position: position,
            size: renderBox.size,
            onAction: (x) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: const Duration(seconds: 1),
                content: Text('Action => $x'),
              ));
            },
          );
        });
  }
}

class PopupMenuContent extends StatefulWidget {
  final Offset position;
  final Size size;
  final ValueChanged<String>? onAction;

  const PopupMenuContent(
      {Key? key, required this.position, required this.size, this.onAction})
      : super(key: key);

  @override
  _PopupMenuContentState createState() => _PopupMenuContentState();
}

class _PopupMenuContentState extends State<PopupMenuContent>
    with SingleTickerProviderStateMixin {
  //Let's create animation
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _closePopup("");
        return false;
      },
      child: GestureDetector(
        onTap: () => _closePopup(""),
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            height: double.maxFinite,
            width: double.maxFinite,
            color: Colors.transparent,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right:
                  (MediaQuery
                      .of(context)
                      .size
                      .width - widget.position.dx) -
                      widget.size.width,
                  top: widget.position.dy,
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _animation.value,
                        alignment: Alignment.topRight,
                        child: Opacity(opacity: _animation.value, child: child),
                      );
                    },

                    ///Popup Box...........
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: double.maxFinite,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 24),
                        margin: const EdgeInsets.only(left: 64),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(.1),
                                blurRadius: 8,
                              )
                            ]),
                        child: Column(
                          children: [
                            //Repeat now

                            ///About US..........
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const about()));
                              },
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFF0E3),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: const Icon(
                                      Icons.info_outlined,
                                      color: Colors.red,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Text(
                                    "About US",
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(.7),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ), //Edit workout
                            const SizedBox(
                              height: 16,
                            ),

                            ///Privacy Policy.....
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const PrivacyPolicy()));
                              },
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE1E1FC),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: const Icon(
                                      Icons.privacy_tip_outlined,
                                      color: Color(0xFF3840A2),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Text(
                                    "Privacy Policy",
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(.7),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ), //Share workout
                            const SizedBox(
                              height: 16,
                            ),

                            ///Share Now.........
                            GestureDetector(
                              onTap: () {

                              },
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFDDF3FD),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                    child: const Icon(
                                      Icons.share,
                                      color: Color(0xFF0586C0),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 12,
                                  ),
                                  Text(
                                    "Share Now",
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(.7),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            ///Exit.............
                            SizedBox(
                              height: MediaQuery
                                  .of(context)
                                  .size
                                  .height * .06,
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              child: ListTile(
                                title: Text(
                                  "Exit",
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(.7),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                leading: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.greenAccent,
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Icon(
                                      Icons.exit_to_app_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text(
                                              "Exit from রান্নার বই"),
                                          content: const Text(
                                              "Are you sure want to exit"),
                                          actions: [
                                            FlatButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("No",
                                                  style:
                                                  TextStyle(fontSize: 20)),
                                            ),
                                            FlatButton(
                                              onPressed: () {
                                                exit(0);
                                              },
                                              child: const Text(
                                                "Ok",
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ),
                                          ],
                                        );
                                      });
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            ///getHelp...........
                            GestureDetector(
                              onTap: () => _closePopup("Upcoming"),
                              child: Container(
                                width: double.maxFinite,
                                height: 70,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF7DA0A0),
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(child: Image.asset("assets/images/logo.png", height: 50,)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _closePopup(String action) {
    _animationController.reverse().whenComplete(() {
      Navigator.of(context).pop();

      if (action.isNotEmpty) widget.onAction?.call(action);
    });
  }
}

