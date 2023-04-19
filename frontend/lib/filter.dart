

import 'package:GTEvents/createEvent.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'event.dart';

class Filter extends StatefulWidget {
  const Filter({super.key});

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  List<String> dateRangeOptionList = <String>[
    "Any time",
    "Choose the range..."
  ];
  late String dateRangeDropDownVal;
  DateTime curTime = DateTime.now();
  String startDate = "";
  String endDate = "choose a date";
  late DateTime eventDateTime;

  List<int> _eventTypeTagSelectState = <int>[];
  List<Tag> eventTypeTagList = [];
  List<Tag> degreeRestrictionTagList = [];

  List<Widget> _getTagList(List<Tag> tagList) {
    List<Widget> result = [];
    for (var i = 0; i < tagList.length; i++) {
      result.add(FilterChip(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        label: Text(tagList[i].name, style: const TextStyle(fontSize: 17),),
        showCheckmark: false,
        selected: _eventTypeTagSelectState.contains(tagList[i].tagId),
        backgroundColor: const Color(0xfffffdf5),
        selectedColor: const Color(0xffdcad7d),
        onSelected: (bool val) {
          setState(() {
            if (val) {
              if (!_eventTypeTagSelectState.contains(tagList[i].tagId)) {
                _eventTypeTagSelectState.add(tagList[i].tagId);
              }
            } else {
              _eventTypeTagSelectState.removeWhere((int id) {
                return id == tagList[i].tagId;
              });
            }
          });
        },
      )
      );
    }
    return result;
  }

  // TODO: duplicated code
  Widget buildDatePicker() =>
      ElevatedButton(
        child: Text('${eventDateTime.month}/${eventDateTime.day}/${eventDateTime
            .year}'),
        onPressed: () async {
          final date = await pickDate();
          if (date == null) {
            return;
          }
          final newDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            eventDateTime.hour,
            eventDateTime.minute,
          );
          setState(() {
            eventDateTime = newDateTime;
          });
        },
      );

  // TODO: duplicated code
  Future<DateTime?> pickDate() =>
      showDatePicker(
        context: context,
        initialDate: eventDateTime,
        firstDate: DateTime(2021),
        lastDate: DateTime(2050),
      );

  PanelState eventTypePanel = PanelState();
  PanelState degreeRestrictionPanel = PanelState();

  @override
  void initState() {
    super.initState();
    getEventTags("event type").then((value) {
      setState(() {
        eventTypeTagList = value;
        eventTypePanel = PanelState(
            expandedValList: value,
            headerVal: "Event Type");
      });
    });
    getEventTags("degree restriction").then((value) {
      setState(() {
        degreeRestrictionTagList = value;
        degreeRestrictionPanel = PanelState(
            expandedValList: value,
            headerVal: "Degree Restriction");
      });
    });
    dateRangeDropDownVal = dateRangeOptionList.first;
    startDate = "${mapMonth((curTime.month).toString())} ${curTime.day}, "
        "${curTime.year}";
    eventDateTime = curTime;
  }

  Widget _buildPanel() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: ExpansionTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            backgroundColor: Color(0xFFCFE5C2),
            collapsedBackgroundColor: Color(0xFFD3E5C9),
            title: const Text("Event Type",
              style: TextStyle(color: Colors.black, fontSize: 18),),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Wrap(
                    spacing: 10,
                    alignment: WrapAlignment.start,
                    children: _getTagList(eventTypeTagList),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: ExpansionTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            backgroundColor: Color(0xFFCFE5C2),
            collapsedBackgroundColor: Color(0xFFD3E5C9),
            title: const Text("Degree Restriction",
              style: TextStyle(color: Colors.black, fontSize: 18),),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Wrap(
                    spacing: 10,
                    alignment: WrapAlignment.start,
                    children: _getTagList(degreeRestrictionTagList),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );

    // return ExpansionPanelList(
    //   elevation: 4,
    //   expandedHeaderPadding: EdgeInsets.zero,
    //   expansionCallback: (int index, bool isExpanded) {
    //     setState(() {
    //       if (index == 0) {
    //         eventTypePanel.isExpanded = !isExpanded;
    //       } else {
    //         degreeRestrictionPanel.isExpanded = !isExpanded;
    //       }
    //     });
    //   },
    //   children: [
    //     ExpansionPanel(
    //       headerBuilder: (BuildContext context, bool isExpanded) {
    //         return ListTile(
    //           title: Text(eventTypePanel.headerVal??"",
    //             style: const TextStyle(fontSize: 18),),
    //         );
    //       },
    //       body: Column(
    //         children: [
    //           Align(
    //             alignment: Alignment.centerLeft,
    //             child: Wrap(
    //               spacing: 10,
    //               alignment: WrapAlignment.start,
    //               children: _getTagList(eventTypePanel.expandedValList??[]),
    //             ),
    //           ),
    //           const SizedBox(
    //             height: 15,
    //           )
    //         ],
    //       ),
    //       isExpanded: eventTypePanel.isExpanded,
    //     ),
    //     ExpansionPanel(
    //       headerBuilder: (BuildContext context, bool isExpanded) {
    //         return ListTile(
    //           title: Text(degreeRestrictionPanel.headerVal??"",
    //             style: const TextStyle(fontSize: 18),),
    //         );
    //       },
    //       body: Column(
    //         children: [
    //           Align(
    //             alignment: Alignment.centerLeft,
    //             child: Wrap(
    //               spacing: 10,
    //               alignment: WrapAlignment.start,
    //               children: _getTagList(degreeRestrictionPanel.expandedValList??[]),
    //             ),
    //           ),
    //           const SizedBox(
    //             height: 15,
    //           )
    //         ],
    //       ),
    //       isExpanded: degreeRestrictionPanel.isExpanded,
    //     ),
    //   ],
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Filter'),
        ),
        body: Column(
          children: [
            DropdownButton<String>(
                isExpanded: true,
                value: dateRangeDropDownVal,
                items: dateRangeOptionList.map<DropdownMenuItem<String>>(
                        (String val) {
                      return DropdownMenuItem<String>(
                          value: val,
                          child: Text(val)
                      );
                    }).toList(),
                onChanged: (String? selectedValue) {
                  if (selectedValue == "Choose the range...") {
                    showDialog<String>(
                        context: context,
                        builder: (BuildContext context) =>
                            AlertDialog(
                              title: const Text('Custom date range',
                                style: TextStyle(fontSize: 20),),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // TODO: apply button on press, date range on change
                                  Text("from"),
                                  buildDatePicker(),
                                  // Text(startDate),
                                  Text("to"),
                                  Text(endDate),
                                ],
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, 'OK'),
                                    child: const Text('OK'))
                              ],
                            )
                    );
                  } else {
                    setState(() {
                      dateRangeDropDownVal = selectedValue!;
                    });
                  }
                }
            ),
            _buildPanel(),
            ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text("Apply", style: TextStyle(fontSize: 17),)
            ),
          ],
        )
    );
  }
}

class PanelState {
  List<Tag>? expandedValList;
  String? headerVal;
  bool isExpanded;

  PanelState({
    this.expandedValList,
    this.headerVal,
    this.isExpanded = false});
}