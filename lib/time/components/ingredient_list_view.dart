import 'package:flutter/material.dart';
import 'package:cookbook/time/components/duration_view.dart';
import 'package:cookbook/time/components/phase_chip.dart';
import 'package:cookbook/time/model/ingredient_model.dart';
import 'package:cookbook/time/model/phase.dart';

class IngredientListView extends StatelessWidget {
  final IngredientModel ingredient;
  final Duration totalDuration;
  final Function addPhaseCallback;
  final Function removeIngredientCallback;
  final Function editPhaseCallback;
  final Function editIngredientCallback;

  IngredientListView(
      {required this.ingredient,
      required this.totalDuration,
      required this.addPhaseCallback,
      required this.removeIngredientCallback,
      required this.editPhaseCallback,
      required this.editIngredientCallback});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        editIngredientCallback();
      },
      child: ExpansionTile(
        initiallyExpanded: true,
        leading: DurationView(
          duration: ingredient.timeRemaining,
        ),
        title: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 6,
                child: Center(
                  child: Text(
                    ingredient.name,
                  ),
                ),
              ),
              Expanded(
                child: IconButton(
                    icon: Icon(
                        ingredient.isPaused ? Icons.play_arrow : Icons.pause),
                    onPressed: () {
                      ingredient.isPaused
                          ? ingredient.resume()
                          : ingredient.pause();
                    }),
              ),
              Expanded(
                child: PopupMenuButton(onSelected: (buttonPressed) {
                  switch (buttonPressed) {
                    case "edit":
                      editIngredientCallback();
                      break;
                    case "add":
                      addPhaseCallback(context);
                      break;
                    case "delete":
                      removeIngredientCallback();
                      break;
                  }
                }, itemBuilder: (popMenuContext) {
                  return [
                    const PopupMenuItem<String>(
                      value: "edit",
                      child: Text("উপাদান সম্পাদনা"),
                    ),
                    const PopupMenuItem<String>(
                      value: "add",
                      child: Text("ধাপ যোগ করুন"),
                    ),
                    const PopupMenuItem<String>(
                      value: "delete",
                      child: Text("উপাদান মুছুন"),
                    ),
                  ];
                }),
              ),
            ],
          ),
        ),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: buildPhaseView(context),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> buildPhaseView(BuildContext context) {
    List<Widget> phaseWidgets = [];

    //Spacer for ingredients with offset
    phaseWidgets.add(Container(
      width: PhaseChip.getWidthWithoutMin(ingredient.initialOffset, totalDuration),
    ));

    for (var i = 0; i < ingredient.phases.length; i++) {
      phaseWidgets.add(PhaseChip(ingredient.phases[i], (Phase phase) {
        ingredient.phases[i] = phase;
        editPhaseCallback(context, ingredient, i);
      }, this.totalDuration));
    }
    phaseWidgets.add(FlatButton(
        textColor: Theme.of(context).primaryColor,
        shape: const CircleBorder(),
        onPressed: () {
          addPhaseCallback(context);
        },
        child: const Icon(Icons.add)));

    return phaseWidgets;
  }
}
