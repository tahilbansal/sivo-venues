import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sivo_venues/common/app_style.dart';
import 'package:sivo_venues/common/divida.dart';
import 'package:sivo_venues/common/reusable_text.dart';
import 'package:sivo_venues/constants/constants.dart';
import 'package:sivo_venues/controllers/location_controller.dart';
import 'package:sivo_venues/models/distance_time.dart';
import 'package:sivo_venues/models/environment.dart';
import 'package:sivo_venues/models/suppliers.dart';
import 'package:sivo_venues/services/distance.dart';
import 'package:sivo_venues/views/home/widgets/custom_btn.dart';
import 'package:sivo_venues/views/supplier/suppliers_page.dart';

class DirectionsPage extends StatefulWidget {
  const DirectionsPage({super.key, required this.supplier});

  final Suppliers supplier;

  @override
  State<DirectionsPage> createState() => _DirectionsPageState();
}

class _DirectionsPageState extends State<DirectionsPage> {
  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};
  Placemark? place;
  String googleApiKey = "AIzaSyC8naF0AUbEMsmLCFzD3O_Mw2qezpm2P7w";
  late GoogleMapController mapController;
  LatLng _center = const LatLng(45.521563, -122.677433);

  Map<MarkerId, Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    var currentLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    setState(() {
      _center = LatLng(currentLocation.latitude, currentLocation.longitude);
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _center,
          zoom: 15.0,
          bearing: 50,
        ),
      ));

      _addMarker(_center, "current_location");
      _addMarker(
          LatLng(widget.supplier.coords.latitude,
              widget.supplier.coords.longitude),
          "restaurant_location");
      _getPolyline();
    });
  }

  void _addMarker(LatLng position, String id) {
    setState(() {
      final markerId = MarkerId(id);
      final marker = Marker(
        markerId: markerId,
        position: position,
        infoWindow: const InfoWindow(title: 'Current Location'),
      );
      markers[markerId] = marker;
    });
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: Environment.googleApiKey,
      request: PolylineRequest(
        origin: PointLatLng(_center.latitude, _center.longitude),
        destination: PointLatLng(
            widget.supplier.coords.latitude, widget.supplier.coords.longitude),
        mode: TravelMode.driving,
        optimizeWaypoints: true,
      ),
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      print(result.errorMessage);
    }
    _addPolyLine();
  }

  _addPolyLine() {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: kPrimary, points: polylineCoordinates, width: 6);
    polylines[id] = polyline;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final location = Get.put(UserLocationController());

    DistanceTime distanceTime = Distance().calculateDistanceTimePrice(
        location.currentLocation.latitude,
        location.currentLocation.longitude,
        widget.supplier.coords.latitude,
        widget.supplier.coords.longitude,
        10,
        2.00);

    double totalTime = 20 + distanceTime.time;

    LatLng restaurant = LatLng(
        widget.supplier.coords.latitude, widget.supplier.coords.longitude);
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: restaurant,
              zoom: 30.0,
            ),
            markers: Set<Marker>.of(markers.values),
            polylines: Set<Polyline>.of(polylines.values),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: width,
              height: 280.h,
              decoration: BoxDecoration(
                  color: kPrimary.withOpacity(0.5),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r))),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                margin: EdgeInsets.fromLTRB(8.w, 8.w, 8.w, 0),
                decoration: BoxDecoration(
                    color: kLightWhite,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.r),
                        topRight: Radius.circular(20.r))),
                child: Column(
                  children: [
                    SizedBox(
                      height: 5.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ReusableText(
                            text: widget.supplier.title!,
                            style: appStyle(20, kGray, FontWeight.bold)),
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: kTertiary,
                          backgroundImage:
                              NetworkImage(widget.supplier.imageUrl!),
                        ),
                      ],
                    ),
                    const Divida(),
                    RowText(
                        first: "Distance To Restaurant",
                        second:
                            "${distanceTime.distance.toStringAsFixed(3)} km"),
                    SizedBox(
                      height: 5.h,
                    ),
                    RowText(
                        first: "Price From Current Location",
                        second: "\$ ${distanceTime.price.toStringAsFixed(3)}"),
                    SizedBox(
                      height: 5.h,
                    ),
                    RowText(
                        first: "Estimated Delivery Time",
                        second: "${totalTime.toStringAsFixed(0)} mins"),
                    SizedBox(
                      height: 5.h,
                    ),
                    RowText(
                        first: "Business Hours", second: widget.supplier.time),
                    SizedBox(
                      height: 10.h,
                    ),
                    const Divida(),
                    RowText(
                        first: "Address",
                        second: widget.supplier.coords.address),
                    SizedBox(
                      height: 10.h,
                    ),
                    const CustomButton(
                      color: kPrimary,
                      btnHieght: 35,
                      radius: 6,
                      text: "Make a reservation",
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 40.h,
            left: 20.w,
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: const Icon(
                Ionicons.chevron_back_circle,
                color: kDark,
                size: 35,
              ),
            ),
          )
        ],
      ),
    );
  }
}
