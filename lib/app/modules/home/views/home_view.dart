import 'package:findersedge/app/modules/home/views/details_view.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  final hc = Get.find<HomeController>();

  final tecSearch = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width / 3,
                  height: 20,
                  child: TextField(
                    controller: tecSearch,
                    cursorWidth: 1.0,
                    decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: const Padding(
                        padding: EdgeInsetsDirectional.only(start: 2.0, end: 2.0),
                        child: Icon(
                          Icons.search,
                          color: Colors.deepOrangeAccent,
                          size: 20,
                        ),
                      ),
                      // suffixIcon: const Icon(MdiIcons.cameraOutline, color: HenryColors.warmOrange),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.only(left: 10),
                      hintStyle: TextStyle(
                        color: Colors.orangeAccent,
                        fontSize: 14,
                      ),
                      hintText: 'Search items',
                    ),
                    onSubmitted: (value) async {
                      // hc.isSearchEnabled.value = true;
                      hc.isLoading.value = true;
                      final result = await hc.searchProducts(value);
                      if (result!) {
                        // print(value);
                        tecSearch.clear();
                        hc.searchList.refresh();
                        hc.isLoading.value = false;
                      }
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Obx(
                  () => IconButton(
                    alignment: Alignment.topCenter,
                    icon: hc.isSorted.value
                        ? Icon(Icons.sort_by_alpha_outlined)
                        : hc.isLoading.value
                            ? CircularProgressIndicator.adaptive()
                            : Icon(Icons.sort_by_alpha_outlined),
                    onPressed: () async {
                      hc.isLoading.value = true;
                      hc.isSorted.value = true;
                      final result = await hc.sortProdcuts(
                          tecSearch.text.isEmpty ? 'title' : tecSearch.text, hc.isSorted.value ? 'asc' : 'desc');
                      if (result!) {
                        hc.isLoading.value = false;
                        hc.isSorted.value = false;
                        hc.searchList.refresh();
                      }
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: SizedBox(
                  width: 10,
                  height: 20,
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    size: 25,
                    color: Colors.red,
                    applyTextScaling: true,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: Obx(
        () => hc.isLoading.value
            ? Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : GridView.builder(
                itemCount: hc.searchList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: context.orientation == Orientation.landscape ? 4 : 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                ),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height / 5,
                        child: InkWell(
                          onTap: () {
                            Get.to(
                              () => DetailsView(indexControl: index),
                            );
                          },
                          child: Hero(
                            tag: hc.searchList[index].id,
                            child: Image.network(
                              hc.searchList[index].thumbnail,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      GridTileBar(
                        title: Text(
                          hc.searchList[index].title,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '${hc.searchList[index].price}',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.shopping_bag_outlined,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
      ),
    );
  }
}
