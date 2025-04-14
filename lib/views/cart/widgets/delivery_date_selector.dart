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
                child: const Text("Tomorrow",
                  style: TextStyle(color: kPrimary),),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close modal
                },
                child: const Text("Day After Tomorrow",
                  style: TextStyle(color: kPrimary),),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "Select Delivery Date",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Theme(
            data: Theme.of(context).copyWith(
              datePickerTheme: DatePickerThemeData(
                dayOverlayColor: WidgetStateProperty.all(kPrimary.withOpacity(0.2)),
                dayBackgroundColor: WidgetStateProperty.resolveWith<Color?>(
                      (Set<WidgetState> states) {
                    if (states.contains(WidgetState.selected)) {
                      return kPrimary;
                    }
                    return null;
                  },
                ),
                todayBackgroundColor: WidgetStateProperty.all(kPrimary),
                backgroundColor: kOffWhite,
                headerBackgroundColor: kPrimary,
                headerForegroundColor: Colors.white,
              ),
            ),
            child : CalendarDatePicker(
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)), // One year from today
              onDateChanged: (date) {
                // Handle date selection
                Navigator.pop(context, date); // Close modal after selection
              },
            ),
          ),
          const SizedBox(height: 16),
          const Text(
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
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}