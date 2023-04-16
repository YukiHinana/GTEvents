
import 'dart:convert';

import 'package:GTEvents/config.dart';
import 'package:GTEvents/component/sidebar.dart';
import 'package:GTEvents/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
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


  Widget buildDatePicker() =>
      ElevatedButton(
        child: Text('${eventDateTime.month}/${eventDateTime.day}/${eventDateTime.year}'),
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
                              title: const Text('Custom date range', style: TextStyle(fontSize: 20),),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
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
          ],
        )
    );
  }
}