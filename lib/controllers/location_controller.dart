// ignore_for_file: prefer_final_fields

import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:rivus_user/models/environment.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class UserLocationController extends GetxController {
  RxInt _currentIndex = 0.obs;

  int get currentIndex => _currentIndex.value;

  var currentPosition = Rx<Position?>(null);

  set currentIndex(int newIndex) {
    _currentIndex.value = newIndex;
  }

  RxBool _defaultAddress = true.obs;
  bool get defaultAddress => _defaultAddress.value;
  set defaultAddress(bool newDefaultAddress) {
    _defaultAddress.value = newDefaultAddress;
  }

  var _supplierLocation = const LatLng(0, 0).obs;

  LatLng get supplierLocation => _supplierLocation.value;

  void setLocation(LatLng newLocation) {
    _supplierLocation.value = newLocation;
    update();
  }

  var _currentLocation = const LatLng(0, 0).obs;

  LatLng get currentLocation => _currentLocation.value;

  void setUserLocation(LatLng newLocation) {
    _currentLocation.value = newLocation;
    update();
  }

  var _userAddress = Placemark(
    name: "Central Park",
    street: "59th St to 110th St",
    isoCountryCode: "US",
    country: "United States",
    postalCode: "10022",
    administrativeArea: "New York",
    subAdministrativeArea: "New York County",
    locality: "New York",
    subLocality: "Manhattan",
    thoroughfare: "Central Park West",
    subThoroughfare: "1",
  ).obs;

  Placemark get userAddress => _userAddress.value;

  void setUserAddress(Placemark newAddress) {
    _userAddress.value = newAddress;
    update();
  }

  var _address = ''.obs;
  String get address => _address.value;
  set address(String newAddress) {
    _address.value = newAddress;
    update();
  }

  var _postalCode = ''.obs;
  String get postalCode => _postalCode.value;
  set postalCode(String newPostalCode) {
    _postalCode.value = newPostalCode;
    update();
  }

  var _district = ''.obs;
  String get district => _district.value;
  set district(String newDistrict) {
    _district.value = newDistrict;
    update();
  }

  var _city = ''.obs;
  String get city => _city.value;
  set city(String newCity) {
    _city.value = newCity;
    update();
  }

  var _country = ''.obs;
  String get country => _country.value;
  set country(String newCountry) {
    _country.value = newCountry;
    update();
  }

  void getAddressFromLatLng(LatLng latLng) async {
    final reverseGeocodeUrl = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${latLng.latitude},${latLng.longitude}&key=${Environment.googleApiKey}');

    final response = await http.get(reverseGeocodeUrl);

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);

      final addressComponents =
          responseBody['results'][0]['address_components'];
      for (var component in addressComponents) {
        if (component['types'].contains('street_address') ||
            component['types'].contains('route')) {
          address = responseBody['results'][0]['formatted_address'];
        } else if (component['types'].contains('sublocality_level_1')) {
          district = component['long_name'];
        } else if (component['types'].contains('locality')) {
          city = component['long_name'];
        } else if (component['types'].contains('postal_code')) {
          postalCode = component['long_name'];
        } else if (component['types'].contains('country')) {
          // Check for the country type
          _country.value = component['long_name']; // Extract the country name
        }
      }
      update();
    } else {
      // Handle the error or no result case
      print('Failed to fetch address details');
    }
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar("Error", "Location services are disabled.");
      return;
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar("Error", "Location permissions are denied.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar("Error", "Location permissions are permanently denied.");
      return;
    }

    // Get the current position
    currentPosition.value = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
