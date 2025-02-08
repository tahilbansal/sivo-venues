import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sivo_venues/constants/constants.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class DeliveryDateSelector extends StatelessWidget {
  const DeliveryDateSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 16.0,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close modal
                },
                child: Text("Tomorrow",
                  style: TextStyle(color: kPrimary),),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close modal
                },
                child: Text("Day After Tomorrow",
                  style: TextStyle(color: kPrimary),),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            "Select Delivery Date",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Theme(
            data: Theme.of(context).copyWith(
              datePickerTheme: DatePickerThemeData(
                dayOverlayColor: MaterialStateProperty.all(kPrimary.withOpacity(0.2)),
                dayBackgroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) {
                      return kPrimary;
                    }
                    return null;
                  },
                ),
                todayBackgroundColor: MaterialStateProperty.all(kPrimary),
                backgroundColor: kOffWhite,
                headerBackgroundColor: kPrimary,
                headerForegroundColor: Colors.white,
              ),
            ),
            child : CalendarDatePicker(
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(Duration(days: 365)), // One year from today
              onDateChanged: (date) {
                // Handle date selection
                Navigator.pop(context, date); // Close modal after selection
              },
            ),
          ),
          SizedBox(height: 16),
          Text(
            "Custom delivery days may not always be guaranteed for on-time delivery.",
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class DeliveryDateOption extends StatelessWidget {
  final String date;
  final PanelController panelController;

  const DeliveryDateOption({Key? key, required this.date, required this.panelController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        panelController.close();
        // Handle specific date selection logic here
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        date,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}