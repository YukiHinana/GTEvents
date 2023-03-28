
import 'package:flutter/material.dart';

class CreateEvent extends StatefulWidget{
  const CreateEvent({ Key? key }) : super(key: key);
  
  @override
  _CreateEventState createState() => _CreateEventState();
}
class _CreateEventState extends State<CreateEvent>{
  //Variables
  final catagoryItems = ['Outdoor Sports', 'Indoor Sports', 'Social', 'Food', 'Club'];
  String? value;
  //DateTime currentDate = DateTime.now();
  DateTime dateTime = DateTime(2023, 03, 28);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Event')),
      body: ListView(
        padding: EdgeInsets.all(32),
        children: [
          buildEventTitleField(),
          const SizedBox(height: 24),
          buildEventLocationField(),
          const SizedBox(height: 24),
          buildEventDiscriptionField(),
          const SizedBox(height: 24),
          buildCatagoryPicker(),
          const SizedBox(height: 24),
          buildDatePicker(),
          const SizedBox(height: 24),
          buildCreateEvent(),

        ],
      ),
    );
  }

  Widget buildEventTitleField() => TextField(
    decoration: InputDecoration(
      labelText: 'Enter Event Title',
      border: OutlineInputBorder(),
    ),
  );


  Widget buildEventLocationField() => TextField(
    decoration: InputDecoration(
      labelText: 'Enter Event Location',
      border: OutlineInputBorder(),
    ),
  );

  Widget buildCatagoryPicker() => DropdownButton<String>(
    hint: Text('Pick Catogory'),
    value: value,
    items: catagoryItems.map((buildCatagoryItem)).toList(), 
    onChanged: (value) => setState(() => this.value = value),
  );
  DropdownMenuItem<String> buildCatagoryItem(String item) => DropdownMenuItem(
    value: item,
    child: Text(
      item,
    )
  );

  Widget buildEventDiscriptionField() => TextField(
    decoration: InputDecoration(
      labelText: 'Enter Event Discription',
      border: OutlineInputBorder(),
    ),
     keyboardType: TextInputType.multiline,
     maxLines: null,
  );

  Widget buildDatePicker() => ElevatedButton(
    child: Text('${dateTime.month}/${dateTime.day}/${dateTime.year}'),
    onPressed: () async {
      final date = await pickDate();
      if (date == null) {
        return;
      }
    }, 
  );

  Future<DateTime?> pickDate() => showDatePicker(
    context: context, 
    initialDate: dateTime, 
    firstDate: DateTime(2021), 
    lastDate: DateTime(2100),
  );

  Widget buildCreateEvent() => FloatingActionButton.extended(
    onPressed: () {

    }, 
    label: const Text("Preview and Create")
  );
  
}