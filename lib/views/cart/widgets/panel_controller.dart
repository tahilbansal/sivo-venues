// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:rivus_user/views/cart/widgets/delivery_date_selector.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';
//
// @override
// Widget build(BuildContext context) {
//   final panelController = PanelController();
//
//   return Scaffold(
//     body: Stack(
//       children: [
//         // Your main content here...
//
//         SlidingUpPanel(
//           controller: panelController,
//           panel: DeliveryDateSelector(panelController: panelController),
//           minHeight: 0,
//           maxHeight: MediaQuery.of(context).size.height * 0.6,
//         ),
//       ],
//     ),
//     floatingActionButton: FloatingActionButton(
//       onPressed: () {
//         // Open the panel when "Select Delivery Date" is clicked
//         panelController.open();
//       },
//       child: Icon(Icons.calendar_today),
//     ),
//   );
// }
