import 'package:flutter/material.dart';

class DateTimeDropdown extends StatefulWidget {
  final ValueChanged<DateTime?> onChanged;

  DateTimeDropdown({required this.onChanged});

  @override
  _DateTimeDropdownState createState() => _DateTimeDropdownState();
}

class _DateTimeDropdownState extends State<DateTimeDropdown> {
  DateTime? selectedDateTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.green, // Set the primary color of the picker // Set the accent color of the picker
            colorScheme: ColorScheme.light(
              primary: Colors.green, // Set the primary color of the picker
              onPrimary: Colors.white,
            ),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    )) ?? DateTime.now();

    if (picked != null && picked != selectedDateTime) {
      setState(() {
        selectedDateTime = picked;
        widget.onChanged(selectedDateTime);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked = (await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.green, // Set the primary color of the picker // Set the accent color of the picker
            colorScheme: ColorScheme.light(
              primary: Colors.green, // Set the primary color of the picker
              onPrimary: Colors.white,
            ),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    )) ?? TimeOfDay.now();

    if (picked != null) {
      DateTime pickedDateTime = DateTime(
        selectedDateTime?.year ?? DateTime.now().year,
        selectedDateTime?.month ?? DateTime.now().month,
        selectedDateTime?.day ?? DateTime.now().day,
        picked.hour,
        picked.minute,
      );

      setState(() {
        selectedDateTime = pickedDateTime;
        widget.onChanged(selectedDateTime);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date & Time',
          style: TextStyle(
            color: Color(0xFF146001),
            fontFamily: 'DM Sans-Bold',
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        Container(
          height: 45,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => _selectDate(context),
                  child: Text(
                    selectedDateTime != null
                        ? '${selectedDateTime!.toLocal().day}/${selectedDateTime!.toLocal().month}/${selectedDateTime!.toLocal().year}'
                        : 'Select Date',
                        style: TextStyle(
                          color: selectedDateTime != null ? Color(0xFF146001) : Colors.black, // Change the color here
                        ),
                  ),
                ),
              ),
              VerticalDivider(
                width: 1,
                color: Colors.grey,
                thickness: 1,
              ),
              Expanded(
                child: TextButton(
                  onPressed: () => _selectTime(context),
                  child: Text(
                    selectedDateTime != null
                        ? '${selectedDateTime!.toLocal().hour}:${selectedDateTime!.toLocal().minute}'
                        : 'Select Time',
                        style: TextStyle(
                          color: selectedDateTime != null ? Color(0xFF146001) : Colors.black, // Change the color here
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }
}
