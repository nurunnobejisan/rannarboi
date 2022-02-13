import 'package:flutter/material.dart';
import 'package:cookbook/time/components/duration_view.dart';
import 'package:cookbook/time/model/timeline_item.dart';

class TimelineTab extends StatelessWidget {
  final List<TimelineItem> allPhases;

  TimelineTab(this.allPhases);

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(left: 10, top: 20, bottom: 15),
                child: const Text(
                  "Starting In",
                  // style: Theme.of(context).textTheme.subhead.copyWith(fontSize: 20),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(right: 10, top: 20, bottom: 15),
                child: const Text(
                  "Finishing In",
                  // style: Theme.of(context).textTheme.subhead.copyWith(fontSize: 20),
                ),
              )
            ],
          ),
          Divider(
            color: Theme.of(context).dividerColor,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: allPhases.length,
                itemBuilder: (context, i) => Container(
                      child: ListTile(
                        dense: true,
                        selected: allPhases[i].timeUntilStart <= Duration.zero,
                        enabled: allPhases[i].timeRemaining > Duration.zero,
                        title: Center(
                          child: Text(allPhases[i].ingredientName +
                              " - " +
                              allPhases[i].phaseName),
                        ),
                        leading: DurationView(
                            duration: allPhases[i].timeUntilStart),
                        trailing: DurationView(
                            duration: allPhases[i].timeUntilStart + allPhases[i].timeRemaining),
                      ),
                    )),
          )
        ],
      ),
    );
  }

//  getStatusColour(TimelineItem phase) {
//    if (phase.timeUntilStart > Duration.zero) return Colors.lightBlueAccent;
//    if (phase.timeUntilStart <= Duration.zero && phase.timeRemaining > Duration.zero) return Colors.lightGreenAccent;
//  }
}
