import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sivo_venues/common/shimmers/nearby_shimmer.dart';
import 'package:sivo_venues/controllers/location_controller.dart';
import 'package:sivo_venues/hooks/fetchNearbySuppliers.dart';
import 'package:sivo_venues/models/suppliers.dart';
import 'package:sivo_venues/views/home/widgets/supplier_widget.dart';
import 'package:sivo_venues/views/supplier/suppliers_page.dart';
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

    return LayoutBuilder(
      builder: (context, constraints) {
        return (isLoading || suppliers == null || suppliers.isEmpty)
            ? const NearbyShimmer()
            : Container(
          padding: EdgeInsets.only(left: 12.w, top: 10.h),
          height: 210.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: suppliers?.length ?? 0,
            itemBuilder: (context, index) {
              Suppliers supplier = suppliers[index];
              return SizedBox(
                width: 300.w.clamp(300, 340),
                child: SupplierWidget(
                  image: supplier.imageUrl!,
                  title: supplier.title!,
                  time: supplier.time,
                  logo: supplier.logoUrl!,
                  onTap: () {
                    location.setLocation(LatLng(
                        supplier.coords.latitude, supplier.coords.longitude));
                    Get.to(() => SupplierPage(supplier: supplier));
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
