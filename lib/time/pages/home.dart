import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cookbook/time/components/countdown_view.dart';
import 'package:cookbook/time/components/custom_drawer.dart';
import 'package:cookbook/time/components/ingredient_list_view.dart';
import 'package:cookbook/time/components/rename_dialogue.dart';
import 'package:cookbook/time/components/schedule_timer_dialogue.dart';
import 'package:cookbook/time/components/splashscreen.dart';
import 'package:cookbook/time/model/ingredient_model.dart';
import 'package:cookbook/time/model/notification_model.dart';
import 'package:cookbook/time/model/phase.dart';
import 'package:cookbook/time/model/timer_model.dart';
import 'package:cookbook/time/model/timer_state.dart';
import 'package:cookbook/time/pages/edit_ingredient_page.dart';
import 'package:cookbook/time/pages/edit_phase_page.dart';
import 'package:cookbook/time/pages/notification_tab.dart';
import 'package:cookbook/time/pages/timeline_tab.dart';
import 'package:vector_math/vector_math_64.dart';

class HomePage extends StatefulWidget {
  HomePage(
      {
      required this.notify,
      required this.saveRecipeCallback,
      required this.removeNotification,
      this.notifications: const [],
      this.initialTab: 0,
      required this.timerFuture,
      required this.muteAlarm,
      required this.alerting});
      // : super(key: key); <- ??

  final Future<TimerModel> timerFuture;
  final Function notify;
  final List<NotificationModel> notifications;
  final Function removeNotification;
  final Function saveRecipeCallback;
  final int initialTab;
  final Function muteAlarm;
  final bool alerting;

  @override
  _HomePageState createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  // late Animation<double> animation;
  late AnimationController animationController;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: widget.initialTab);
    _tabController.addListener(() => widget.muteAlarm());
    widget.timerFuture.then((timer) {
      return timer.clock.getTickStream().listen((tick) {
        setState(() {});
      });
    });

    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this)
      ..addListener(() {
        setState(() {});
      });
    animationController.repeat();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: widget.timerFuture,
        builder: (context, timerSnapshot) {
          if (timerSnapshot.connectionState == ConnectionState.done && timerSnapshot.data != null) {
            TimerModel timer = timerSnapshot.data as TimerModel; //
            timer.recipe.ingredients
                .sort((a, b) => b.initialDuration.compareTo(a.initialDuration));
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "${timer.recipe.name}",
                ),
                actions: <Widget>[
                  Builder(
                    builder: (context) => FlatButton(
                          onPressed: () {
                            widget.saveRecipeCallback(timer.recipe);
                            Scaffold.of(context).showSnackBar(
                                const SnackBar(content: const Text("Recipe Saved!")));
                          },
                          child: const Icon(
                            Icons.save,
                            // color: Theme.of(context)
                            //     .buttonTheme
                            //     .colorScheme
                            //     .onPrimary,
                          ),
                        ),
                  ),
                  PopupMenuButton(itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                          child: FlatButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => RenameDialogue(
                                            "Rename Recipe", timer.recipe.name,
                                            (String newValue) {
                                          timer.recipe.name = newValue;
                                          widget
                                              .saveRecipeCallback(timer.recipe);
                                          Navigator.of(context).pop();
                                        }));
                              },
                              child: const Text("Rename Recipe")))
                    ];
                  })
                ],
              ),
              drawer: const CustomDrawer(),
              body: SafeArea(
                child: TabBarView(controller: _tabController, children: [
                  buildTimerTab(timer),
                  TimelineTab(timer.recipe.getTimelineList()),
                  NotificationTab(
                      widget.notifications, widget.removeNotification)
                ]),
              ),
              floatingActionButton: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.0,
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      newIngredient(timer);
                    },
                    child: const Icon(Icons.add),
                  )
                ],
              ),
              bottomNavigationBar: buildNavbar(context),
            );
          } else {
            return const SplashScreen();
            //todo thing of better loading screen
          }
        });
  }

  Tab buildTimerTab(timer) {
    return Tab(
      child: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: buildCountdownView(timer),
            ),
            Expanded(
              flex: 5,
              child: timer.recipe.ingredients.isNotEmpty
                  ? buildIngredientList(timer)
                  : ListTile(
                      title: Text(
                        "Try Adding an Ingredient",
                        style: Theme.of(context).textTheme.caption,
                        textAlign: TextAlign.center,
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  ListView buildIngredientList(timer) {
    return ListView.builder(
      itemCount: timer.recipe.ingredients.length,
      itemBuilder: (context, index) {
        return IngredientListView(
          ingredient: timer.recipe.ingredients[index],
          totalDuration: timer.recipe.initialDuration,
          addPhaseCallback: (context) {
            newPhase(context, index, timer);
          },
          removeIngredientCallback: () {
            removeIngredient(index, timer);
          },
          editIngredientCallback: () {
            editIngredient(index, timer);
          },
          editPhaseCallback: (context, ingredient, index) {
            editPhase(context, ingredient, index, timer);
          },
        );
      },
      padding: const EdgeInsets.all(10),
    );
  }

  CountdownView buildCountdownView(timer) {
    return CountdownView(
        timer: timer,
        playOrPauseCallback: playOrPauseTimer,
        scheduleTimerCallback: _showScheduleTimerDialogue,
        resetCallback: () {
          widget.muteAlarm();
          setState(() {
            timer.reset();
          });
        });
  }

  _showScheduleTimerDialogue(TimerModel timer) {
    showDialog(
        context: context,
        builder: (context) => ScheduleTimerDialogue(
                "Finish At", timer.scheduledTime, (selectedTime) {
              setState(() {
                timer.scheduledTime = selectedTime ?? TimeOfDay.now();
              });
            }));
  }

  void playOrPauseTimer(timer) {
    setState(() {
      if (timer.isRunning()) {
        timer.pause();
      } else {
        playTimer(timer);
      }
    });
  }

  void playTimer(TimerModel timer) {
    if (timer.hasStarted) {
      timer.resume();
    } else {
      timer.start();
    }
  }

  Material buildNavbar(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColor,
      child: TabBar(
        tabs: <Widget>[
          Container(
            padding: const EdgeInsets.all(20),
            child: const Icon(Icons.timer),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: const Icon(Icons.timeline),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: widget.alerting
                ? Transform(
                    child: const Icon(Icons.notifications_active),
                    transform: Matrix4.translation(getTranslation()),
                  )
                : const Icon(Icons.notifications),
          )
        ],
        controller: _tabController,
      ),
    );
  }

  Vector3 getTranslation() {
    double progress = animationController.value;
    double offset = sin(progress * pi * 12);
    return Vector3(offset, 0.0, 0.0);
  }

  void newPhase(context, ingredientIndex, timer) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditPhasePage.empty(
              submitCallback: (Phase phase) {
                timer.recipe.ingredients[ingredientIndex].phases.add(phase);
                if (timer.recipe.ingredients[ingredientIndex].state ==
                    TimerState.FINISHED) {
                  timer.recipe.ingredients[ingredientIndex].state =
                      TimerState.RUNNING;
                }
                recipeChanged(timer);
              },
              deleteCallback: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
      ),
    );
  }

  void recipeChanged(timer) {
    timer.ingredientsChanged();
    widget.saveRecipeCallback(timer.recipe);
  }

  void removeIngredient(ingredientIndex, timer) {
    setState(() {
      timer.recipe.ingredients.removeAt(ingredientIndex);
      recipeChanged(timer);
    });
  }

  void editIngredient(ingredientIndex, timer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditIngredientPage(
              ingredient: timer.recipe.ingredients[ingredientIndex],
              submitCallback: (IngredientModel ingredient) {
                timer.recipe.ingredients[ingredientIndex] = ingredient;
                recipeChanged(timer);
              },
              alertCallback: widget.notify,
            ),
      ),
    );
  }

  void newIngredient(timer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditIngredientPage.empty(
              submitCallback: (IngredientModel ingredient) {
                timer.recipe.ingredients.add(ingredient);
                recipeChanged(timer);
              },
              alertCallback: widget.notify,
            ),
      ),
    );
  }

  void editPhase(
      BuildContext context, IngredientModel ingredient, int index, timer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPhasePage(
              phase: ingredient.phases[index],
              submitCallback: (Phase phase) {
                phase.state = TimerState.PENDING;
                ingredient.phases[index] = phase;
                recipeChanged(timer);
              },
              deleteCallback: () {
                ingredient.phases.removeAt(index);
                recipeChanged(timer);
                Navigator.of(context).pop();
              },
            ),
      ),
    );
  }
}
