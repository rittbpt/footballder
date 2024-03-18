import 'package:flutter/material.dart';

class DateDropdown extends StatefulWidget {
  final ValueChanged<DateTime?> onChanged;

  DateDropdown({required this.onChanged});

  @override
  _DateDropdownState createState() => _DateDropdownState();
}

class _DateDropdownState extends State<DateDropdown> {
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
            primaryColor: Colors.green, // Set the primary color of the picker
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Birthday',
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
                      color: selectedDateTime != null ? Color(0xFF146001) : Colors.black,
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
