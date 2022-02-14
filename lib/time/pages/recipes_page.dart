import 'package:flutter/material.dart';
import 'package:cookbook/time/components/recipe_view.dart';
import 'package:cookbook/time/model/recipe.dart';
import 'package:cookbook/time/model/timer_model.dart';

class RecipesPage extends StatefulWidget {
  final Future<TimerModel> currentTimerFuture;
  final Function saveRecipeCallback;
  final Function deleteRecipeCallback;
  final Function renameRecipeCallback;
  final Stream<List<Recipe>> recipesFuture;
  final Function createEmptyRecipe;

  const RecipesPage(this.currentTimerFuture,
      this.saveRecipeCallback,
      this.deleteRecipeCallback,
      this.renameRecipeCallback,
      this.recipesFuture,
      this.createEmptyRecipe, {Key? key}) : super(key: key);

//TODO stateless?
  @override
  _RecipesPageState createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recipes"),
      ),

      body: SafeArea(
          child: StreamBuilder(
              stream: widget.recipesFuture,
              builder: (context, recipesStream) {
                if (recipesStream.hasData) {
                  return Column(
                    children: <Widget>[
                      FutureBuilder(
                          future: widget.currentTimerFuture,
                          builder: (BuildContext context,
                              AsyncSnapshot<TimerModel> snapshot) {
                            if (snapshot.hasData &&
                                snapshot.data!.isRunning()) {

                              return buildCurrentTimerView(snapshot.data!);
                            } else {
                              return Container();
                            }
                          }),
                      Expanded(
                        child: ListView.separated(
                            itemCount: (recipesStream.data as List<Recipe>).length,
                            separatorBuilder: (context, i) =>
                                Divider(
                                  color: Theme
                                      .of(context)
                                      .dividerColor,
                                ),
                            itemBuilder: (context, i) =>
                                RecipeView(
                                    (recipesStream.data as List<Recipe>)[i],
                                    widget.deleteRecipeCallback,
                                    widget.renameRecipeCallback,
                                    widget.saveRecipeCallback,
                                    showDialogueIfTimerRunning)),
                      ),
                    ],
                  );
                } else {
                  return ListView();
                }
              })),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add), onPressed: () async{
        var pushNewRecipe = () {
          widget
              .createEmptyRecipe()
              .then((recipe) =>
              Navigator.of(context).pushNamed(recipe.documentId));
        };
        showDialogueIfTimerRunning(pushNewRecipe);
      }),
    );
  }

  Widget buildCurrentTimerView(TimerModel timer) =>
      Card(
        elevation: 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: const Text("টাইমার চলছে",
                  // style: Theme
                  //     .of(context)
                  //     .textTheme
                  //     .subhead
              ),
              padding: const EdgeInsets.all(10),
            ),
            Divider(
              color: Theme
                  .of(context)
                  .dividerColor,
            ),
            RecipeView(
              timer.recipe,
              widget.deleteRecipeCallback,
              widget.renameRecipeCallback,
              widget.saveRecipeCallback,
              (onContinue) => onContinue(),
              routeToPush: '',
            )
          ],
        ),
      );

  void showDialogueIfTimerRunning(Function onContinue) async {
    var timer = await widget.currentTimerFuture;

    if (timer.isRunning()) {
      showWarningDialogue(context, onContinue);
    } else {
      onContinue();
    }
  }

  void showWarningDialogue(context, onContinue) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text("আপনি একটি টাইমার চলমান আছে"),
            content: const Text("বর্তমান টাইমার বন্ধ করা হবে"),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  onContinue();
                },
                child: const Text("চালিয়ে যান"),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("বাতিল করুন"),
              )
            ],
          ),
    );
  }
}
