

import 'package:GTEvents/createEvent.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import '../config.dart';
import '../event.dart';

class Filter extends StatefulWidget {
  const Filter({super.key});

  @override
  State<Filter> createState() => _FilterState();
}

Future<http.Response> doFilter(List<int> eventTypeTagSelectState,
    List<int> degreeTagSelectState, DateTime? startDate, DateTime? endDate,
    int pageNumber, int pageSize) async {
  String eventTypeStr = eventTypeTagSelectState.join(",");
  String degreeStr = degreeTagSelectState.join(",");
  int startTimeStamp;
  int endTimeStamp;
  if (startDate == null) {
    startTimeStamp = DateTime(2021, 1, 1, 0, 0, 0).toUtc().millisecondsSinceEpoch~/1000;
  } else {
    startTimeStamp = startDate.toUtc().millisecondsSinceEpoch~/1000;
  }
  if (endDate == null) {
    endTimeStamp = DateTime(2050, 12, 31, 23, 59, 59).toUtc().millisecondsSinceEpoch~/1000;
  } else {
    endTimeStamp = endDate.toUtc().millisecondsSinceEpoch~/1000;
  }
  var response = await http.get(
    Uri.parse(
        '${Config.baseURL}/events/events/tag-ids?eventTypeTagIds=$eventTypeStr'
            '&degreeTagIds=$degreeStr&pageNumber=$pageNumber&pageSize=$pageSize'
            '&startDate=$startTimeStamp&endDate=$endTimeStamp'),
    headers: {
      "Content-Type": "application/json",
    },
  );
  return response;
}

class _FilterState extends State<Filter> {
  List<String> dateRangeOptionList = <String>[
    "Any time",
    "Choose the range..."
  ];
  late String dateRangeDropDownVal = "";
  DateTime curTime = DateTime.now();
  late DateTime? startDate;
  late DateTime? endDate;

  List<int> _eventTypeTagSelectState = <int>[];
  List<int> _degreeTagSelectState = <int>[];
  List<Tag> eventTypeTagList = [];
  List<Tag> degreeTagList = [];

  List<Widget> _getTagList(List<Tag> tagList, List<int> tagSelectState) {
    List<Widget> result = [];
    for (var i = 0; i < tagList.length; i++) {
      // build filter
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

  Widget _buildDatePicker(StateSetter setState, int a) {
    DateTime eventDate = endDate == null
        ? DateTime(curTime.year, curTime.month, curTime.day + 1)
        : endDate!;
    if (a == 0) {
      eventDate = startDate == null
          ? DateTime(curTime.year, curTime.month, curTime.day)
          : startDate!;
    }
    return ElevatedButton(
      child: Text('${eventDate.month}/${eventDate.day}/${eventDate
          .year}'),
      onPressed: () async {
        var date = await _pickDate(eventDate);
        if (date == null) {
          return;
        }
        if (a == 1) {
          date = date.add(const Duration(hours: 23, minutes: 59, seconds: 59));
        }
        final newDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          date.hour,
          date.minute,
          date.second,
        );
        setState(() {
          if (a == 0) {
            startDate = newDateTime;
          } else {
            endDate = newDateTime;
          }
        });
      },
    );
  }

  Future<DateTime?> _pickDate(DateTime initialDate) =>
      showDatePicker(
        context: context,
        initialDate: initialDate,
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
    Future.delayed(Duration.zero, () async {
      _eventTypeTagSelectState = StoreProvider.of<AppState>(context).state.filterData.eventTypeTagSelectState;
      _degreeTagSelectState = StoreProvider.of<AppState>(context).state.filterData.degreeTagSelectState;
      DateTime? readStartDate = StoreProvider.of<AppState>(context).state.filterData.startDate;
      DateTime? readEndDate = StoreProvider.of<AppState>(context).state.filterData.endDate;
      if (readStartDate == null && readEndDate == null) {
        dateRangeDropDownVal = dateRangeOptionList.first;
        startDate = null;
        endDate = null;
      } else {
        startDate = readStartDate;
        endDate = readEndDate;
        dateRangeDropDownVal = "from ${convertDateTimeToDate(startDate!)} "
            "to ${convertDateTimeToDate(endDate!)}";
      }
    });
  }

  // build panel for options
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
            backgroundColor: const Color(0xFFCFE5C2),
            collapsedBackgroundColor: const Color(0xFFD3E5C9),
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
            backgroundColor: const Color(0xFFCFE5C2),
            collapsedBackgroundColor: const Color(0xFFD3E5C9),
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

  String convertDateTimeToDate(DateTime curTime) {
    return "${mapMonth((curTime.month).toString())} ${curTime.day}, "
        "${curTime.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Filter'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: DropdownButton<String>(
                  isExpanded: true,
                  hint: Text(dateRangeDropDownVal),
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
                                content: StatefulBuilder(
                                  builder: (BuildContext context, StateSetter setState) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text("from"),
                                        _buildDatePicker(setState, 0),
                                        const Text("to"),
                                        _buildDatePicker(setState, 1),
                                      ],
                                    );
                                  },
                                ),
                                title: const Text('Custom date range',
                                  style: TextStyle(fontSize: 20),),
                                actions: [
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'OK'),
                                      child: const Text('OK'))
                                ],
                              )
                      );
                      setState(() {
                        DateTime start = startDate == null ? DateTime(curTime.year, curTime.month, curTime.day) : startDate!;
                        DateTime end = endDate == null ? DateTime(curTime.year, curTime.month, curTime.day + 1) : endDate!;
                        dateRangeDropDownVal = "from ${convertDateTimeToDate(start)} to ${convertDateTimeToDate(end)}";
                      });
                    } else {
                      setState(() {
                        dateRangeDropDownVal = selectedValue!;
                      });
                    }
                  }
              ),
            ),
            _buildPanel(),
            // TODO: add clear all option
            ElevatedButton(
                onPressed: () {
                  StoreProvider.of<AppState>(context).dispatch(
                      SetTagSelectStateAction(_eventTypeTagSelectState, _degreeTagSelectState));
                  if (dateRangeDropDownVal == dateRangeOptionList.first) {
                    StoreProvider.of<AppState>(context).dispatch(
                        SetFilterDateRangeAction(null, null));
                  } else {
                    StoreProvider.of<AppState>(context).dispatch(
                        SetFilterDateRangeAction(startDate, endDate));
                  }
                  context.replace("/events");
                },
                child: const Text("Apply", style: TextStyle(fontSize: 17),)
            ),
          ],
        )
    );
  }
}