

import 'package:GTEvents/createEvent.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../config.dart';
import '../event.dart';

class Filter extends StatefulWidget {
  const Filter({super.key});

  @override
  State<Filter> createState() => _FilterState();
}

Future<void> doFilter(List<int> eventTypeTagSelectState,
    List<int> degreeTagSelectState) async {
  String str = "";
  for (int i in eventTypeTagSelectState) {
    print(i);
    str += "$i,";
  }
  str = str.substring(0, str.length - 1);
  var response = await http.get(
    Uri.parse('${Config.baseURL}/events/events/tag-ids?tagIds=$str'),
    headers: {
      "Content-Type": "application/json",
    },
  );
  print(response.body);
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
  List<int> _degreeTagSelectState = <int>[];
  List<Tag> eventTypeTagList = [];
  List<Tag> degreeTagList = [];

  List<Widget> _getTagList(List<Tag> tagList, List<int> tagSelectState) {
    List<Widget> result = [];
    for (var i = 0; i < tagList.length; i++) {
      result.add(FilterChip(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        label: Text(tagList[i].name, style: const TextStyle(fontSize: 17),),
        showCheckmark: false,
        selected: tagSelectState.contains(tagList[i].tagId),
        backgroundColor: const Color(0xfffffdf5),
        selectedColor: const Color(0xffdcad7d),
        onSelected: (bool val) {
          setState(() {
            if (val) {
              if (!tagSelectState.contains(tagList[i].tagId)) {
                tagSelectState.add(tagList[i].tagId);
              }
            } else {
              tagSelectState.removeWhere((int id) {
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

  @override
  void initState() {
    super.initState();
    getEventTags("event type").then((value) {
      setState(() {
        eventTypeTagList = value;
      });
    });
    getEventTags("degree restriction").then((value) {
      setState(() {
        degreeTagList = value;
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
                    children: _getTagList(eventTypeTagList, _eventTypeTagSelectState),
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
                    children: _getTagList(degreeTagList, _degreeTagSelectState),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
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
              // onPressed: () => context.pop(),
                onPressed: () {
                  // print(_eventTypeTagSelectState);
                  // print(_degreeTagSelectState);
                  doFilter();
                },
                child: const Text("Apply", style: TextStyle(fontSize: 17),)
            ),
          ],
        )
    );
  }
}