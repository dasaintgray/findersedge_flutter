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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          // title: Text('FINDERSEDGE'),
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
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                        // suffixIcon: const Icon(MdiIcons.cameraOutline, color: HenryColors.warmOrange),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.only(left: 10),
                        hintStyle: TextStyle(
                          color: Colors.black,
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
                  flex: 2,
                  child: GestureDetector(
                    child: Obx(
                      () => Icon(
                        hc.isSorted.value ? Icons.sort_by_alpha_outlined : Icons.soap_outlined,
                        size: 25,
                        applyTextScaling: true,
                      ),
                    ),
                    onTap: () async {
                      if (hc.isSorted.value) {
                        hc.isSorted.value = false;
                        final result = await hc.sortProdcuts(tecSearch.text.isEmpty ? 'title' : tecSearch.text, 'desc');
                        if (result!) {
                          // hc.isSorted.value = true;
                          hc.searchList.refresh();
                        }
                      } else {
                        hc.isSorted.value = true;
                        final result = await hc.sortProdcuts(tecSearch.text.isEmpty ? 'title' : tecSearch.text, 'asc');
                        if (result!) {
                          // hc.isSorted.value = false;
                          hc.searchList.refresh();
                        }
                      }
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    width: 10,
                    height: 20,
                    child: GestureDetector(
                      onTap: () {},
                      child: Badge(
                        label: Text('1'),
                        smallSize: 1.5,
                        alignment: Alignment.topCenter,
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          size: 25,
                          color: Colors.red,
                          applyTextScaling: true,
                        ),
                      ),
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
                            child: Image.network(
                              hc.searchList[index].thumbnail,
                              fit: BoxFit.contain,
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
                            onPressed: () {
                              
                            },
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
      ),
    );
  }
}
