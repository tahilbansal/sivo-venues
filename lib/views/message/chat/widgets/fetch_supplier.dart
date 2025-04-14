import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sivo_venues/hooks/fetchSupplier.dart';
import 'package:sivo_venues/views/supplier/suppliers_page.dart';

class SupplierFetcher extends HookWidget {
  final String supplierId;

  const SupplierFetcher({Key? key, required this.supplierId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final fetchHook = useFetchSupplier(supplierId);

    if (fetchHook.isLoading) {
      return const CircularProgressIndicator();
    }

    if (fetchHook.error != null) {
      return const Text('Error fetching supplier');
    }

    if (fetchHook.data == null) {
      return const Text('Supplier not found');
    }

    final supplier = fetchHook.data!;

    return GestureDetector(
      onTap: () {
        Get.to(() => SupplierPage(supplier: supplier));
      },
      child: Container(
        padding: EdgeInsets.only(top: 0.w, bottom: 0.w, right: 0.w),
        child: InkWell(
          child: SizedBox(
            width: 44.w,
            height: 44.w,
            child: CachedNetworkImage(
              imageUrl: supplier.imageUrl!,
              imageBuilder: (context, imageProvider) => Container(
                height: 44.w,
                width: 44.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(44.w)),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => const Image(
                image: AssetImage('assets/images/profile-photo.png'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
