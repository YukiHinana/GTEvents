
import 'dart:convert';

import 'package:GTEvents/config.dart';
import 'package:GTEvents/createEvent.dart';
import 'package:GTEvents/login.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import 'event.dart';
import 'eventsPage.dart';

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

  List<int> _eventTypeSelectedOptions = <int>[];
  List<Tag> eventTypeTagList = [];
  List<Tag> degreeRestrictionTagList = [];

  List<Widget> getEventTypeTags(List<Tag> tagList) {
    List<Widget> result = [];
    for (var i = 0; i < tagList.length; i++) {
      result.add(FilterChip(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        label: Text(tagList[i].name, style: const TextStyle(fontSize: 17),),
        showCheckmark: false,
        selected: _eventTypeSelectedOptions.contains(tagList[i].tagId),
        backgroundColor: const Color(0xffd2cdc8),
        selectedColor: const Color(0xffb68a5e),
        onSelected: (bool val) {
          setState(() {
            if (val) {
              if (!_eventTypeSelectedOptions.contains(tagList[i].tagId)) {
                _eventTypeSelectedOptions.add(tagList[i].tagId);
              }
            } else {
              _eventTypeSelectedOptions.removeWhere((int id) {
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
        degreeRestrictionTagList = value;
      });
    });
    dateRangeDropDownVal = dateRangeOptionList.first;
    startDate = "${mapMonth((curTime.month).toString())} ${curTime.day}, "
        "${curTime.year}";
    eventDateTime = curTime;
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
            Text("Event Type"),
            Wrap(
              spacing: 5,
              children: getEventTypeTags(eventTypeTagList),
            ),
            Text("Degree Restriction"),
            Wrap(
              spacing: 5,
              children: getEventTypeTags(degreeRestrictionTagList),
            ),
            ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text("Apply", style: const TextStyle(fontSize: 17),)
            ),
          ],
        )
    );
  }
}