import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';
import 'package:findersedge/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class DetailsView extends GetView {
  DetailsView({super.key, required this.indexControl});

  final int indexControl;

  final hc = Get.find<HomeController>();
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(hc.searchList[indexControl].title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            SizedBox(
              child: FanCarouselImageSlider.sliderType2(
                imagesLink: hc.searchList[indexControl].images,
                isAssets: false,
                autoPlay: false,
                initalPageIndex: 0,
                sliderHeight: 300,
                currentItemShadow: const [],
                sliderDuration: const Duration(milliseconds: 200),
                imageRadius: 0,
                slideViewportFraction: 1.2,
              ),
            ),
            Text(
              hc.searchList[indexControl].price.toString(),
              style: TextStyle(
                fontSize: 25,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              hc.searchList[indexControl].description,
              style: TextStyle(
                fontSize: 20,
                color: Colors.red.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
