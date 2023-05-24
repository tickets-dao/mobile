import 'package:flutter/material.dart';

class TimePickerWidget extends StatefulWidget {
  const TimePickerWidget({required this.onSelected, super.key});

  final Function onSelected;

  @override
  TimePickerWidgetState createState() => TimePickerWidgetState();
}

class TimePickerWidgetState extends State<TimePickerWidget> {
  TimeOfDay selectedTime = TimeOfDay.now();

  _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
      widget.onSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(height: 20.0),
        ElevatedButton(
          onPressed: () => _selectTime(context),
          child: const Text('Выбрать время'),
        ),
      ],
    );
  }
}
