
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sivo_venues/common/app_style.dart';
import 'package:sivo_venues/common/reusable_text.dart';
import 'package:sivo_venues/constants/constants.dart';
import 'package:sivo_venues/controllers/address_controller.dart';
import 'package:sivo_venues/controllers/location_controller.dart';
import 'package:sivo_venues/hooks/fetchDefaultAddress.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sivo_venues/views/profile/address.dart';

class CustomAppBar extends StatefulHookWidget {
  const CustomAppBar({
    super.key,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  final box = GetStorage();
  @override
  void initState() {
    _determinePosition();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _determinePosition();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final location = Get.put(UserLocationController());
    final controller = Get.put(AddressController());
    String? accessToken = box.read("token");
    if (accessToken != null) {
      useFetchDefault(context, false);
    }
    String? userId = box.read("userId");
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4),
      height: 90,
      color: kWhite,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
          GestureDetector(
          onTap: () {
              // Navigate to the Address Page
            Get.to(() => const Addresses(),
            transition: Transition.upToDown,
            duration: const Duration(milliseconds: 700)
            );
            },
            child : Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                          Icons.location_on,
                          color: kSecondary,
                          size: 18,
                          ),
                          const SizedBox(width: 4),
                          ReusableText(
                            text: "Delivering to",
                            style: appStyle(13, kSecondary, FontWeight.w600)
                          ),
                          const SizedBox(width: 2),
                          const Icon(
                            Icons.arrow_drop_down,
                            color: kSecondary,
                            size: 24,
                          ),
                        ]
                      ),
                      Obx(() => SizedBox(
                        width: width * 0.75,
                        child: Text(
                          location.address.isNotEmpty
                              ? controller.defaultAddress == null
                                  ? location.address
                                  : controller.defaultAddress!.addressLine1
                              : "Fetching location...",
                          overflow: TextOverflow.ellipsis,
                          style: appStyle(11, kGray, FontWeight.normal)
                        ),
                      )
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
            // Text(
            //   getTimeOfDay(),
            //   style: const TextStyle(fontSize: 35),
            // )
          ],
        ),
    );
  }

  // String getTimeOfDay() {
  //   DateTime now = DateTime.now();
  //   int hour = now.hour;
  //
  //   if (hour >= 0 && hour < 12) {
  //     return "☀️";
  //   } else if (hour >= 12 && hour < 17) {
  //     return "🌤️";
  //   } else {
  //     return "🌙";
  //   }
  // }

  //String profile = 'https://firebasestorage.googleapis.com/v0/b/rivus-flutter.appspot.com/o/icons%2Fprofile-photo.png?alt=media&token=3afe87ea-0e62-4143-a798-cbb713203045';
  LatLng _center = const LatLng(37.78792117665919, -122.41325651079953);
  Placemark? currentLocation;

  Future<void> _getCurrentLocation() async {
    final location = Get.put(UserLocationController());

    try {
      var currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);

      LatLng currentCoordinates = LatLng(currentPosition.latitude, currentPosition.longitude);
      setState(() {
        _center = currentCoordinates;
        location.setUserLocation(_center);
        location.getAddressFromLatLng(_center);
      });
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    await _getCurrentLocation();
  }
}
