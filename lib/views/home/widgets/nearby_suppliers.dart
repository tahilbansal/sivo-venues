// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rivus_user/common/shimmers/nearby_shimmer.dart';
import 'package:rivus_user/constants/constants.dart';
import 'package:rivus_user/controllers/location_controller.dart';
import 'package:rivus_user/hooks/fetchNearbySuppliers.dart';
import 'package:rivus_user/models/suppliers.dart';
import 'package:rivus_user/views/home/widgets/supplier_widget.dart';
import 'package:rivus_user/views/supplier/suppliers_page.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NearbySuppliers extends HookWidget {
  const NearbySuppliers({super.key});

  @override
  Widget build(BuildContext context) {
    final location = Get.put(UserLocationController());

    final hookResult = useFetchSuppliers();
    final suppliers = hookResult.data;
    final isLoading = hookResult.isLoading;
    final error = hookResult.error;
    //final refetch = hookResult.refetch;

    return (isLoading || suppliers == null || suppliers.isEmpty)
        ? const NearbyShimmer()
        : Container(
            padding: const EdgeInsets.only(left: 12, top: 10),
            height: 210.h,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: suppliers?.length ?? 0,
                itemBuilder: (context, index) {
                  Suppliers supplier = suppliers[index];
                  return SupplierWidget(
                    image: supplier.imageUrl!,
                    title: supplier.title!,
                    time: supplier.time,
                    logo: supplier.logoUrl!,
                    rating: "${supplier.ratingCount} + reviews and ratings",
                    onTap: () {
                      location.setLocation(LatLng(
                          supplier.coords.latitude, supplier.coords.longitude));
                      Get.to(() => SupplierPage(
                            supplier: supplier,
                          ));
                    },
                  );
                }),
          );
  }
}
