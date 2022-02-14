import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cookbook/time/model/phase.dart';

class EditPhasePage extends StatefulWidget {
  final Phase phase;
  final Function submitCallback;
  final Function deleteCallback;

  const EditPhasePage(
      {Key? key, required this.phase,
      required this.submitCallback,
      required this.deleteCallback}) : super(key: key);

  EditPhasePage.empty(
      {Key? key, required this.submitCallback, required this.deleteCallback})
      : phase = Phase(name: "", initialDuration: Duration.zero), super(key: key);

  @override
  _EditPhasePageState createState() => _EditPhasePageState();
}

class _EditPhasePageState extends State<EditPhasePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  Duration selectedDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.phase.name;
    selectedDuration = widget.phase.timeRemaining;
    notesController.text = widget.phase.notes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("রান্নার ধাপ সম্পাদনা করুন"),
        actions: <Widget>[
          FlatButton(
              onPressed: submit,
              child: const Icon(
                Icons.done,
                color: Colors.white,
              )),
          PopupMenuButton(onSelected: (buttonPressed) {
            switch (buttonPressed) {
              case "মুছে ফেলা":
                widget.deleteCallback();
                break;
            }
          }, itemBuilder: (popMenuContext) {
            return [
              const PopupMenuItem<String>(
                value: "মুছে ফেলা",
                child: Text("মুছে ফেলা"),
              ),
            ];
          })
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: buildTitleInput(context),
            ),
            Expanded(
              flex: 5,
              child: buildTimePicker(),
            ),
            Expanded(
              flex: 3,
              child: buildOnDoneInput(context),
            )
          ],
        ),
      ),
    );
  }

  Center buildTitleInput(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(5),
        child: TextField(
          decoration: const InputDecoration(hintText: "e.g. Boil..."),
          textCapitalization: TextCapitalization.sentences,
          textAlign: TextAlign.center,
          controller: nameController,
          onChanged: (value) {
            widget.phase.name = value;
          },
        ),
      ),
    );
  }

  Widget buildTimePicker() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Text(
                "সময়কাল",
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: CupertinoTimerPicker(
              initialTimerDuration: selectedDuration,
              onTimerDurationChanged: (duration) {
                selectedDuration = duration;
              },
            ),
          )
        ],
      ),
    );
  }

  Container buildOnDoneInput(BuildContext context) {
    return Container(
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "মন্তব্য",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  child: TextField(
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(hintText: "যেমন 190 ডিগ্রি সেলসিয়াসে রান্না করুন"),
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle1,
                    controller: notesController,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void submit() {
    widget.submitCallback(Phase(
        name: nameController.text,
        initialDuration: selectedDuration,
        notes: notesController.text));
    Navigator.pop(context);
  }
}
