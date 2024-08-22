
                // GroupedListView<MagazineItem, int>(
                //   elements: _.listMagazine,
                //   physics: const ScrollPhysics(),
                //   scrollDirection: Axis.vertical,
                //   shrinkWrap: true,
                //   groupBy: (element) => element.getYear(),
                //   groupSeparatorBuilder: (int groupByValue) {
                //     return Padding(
                //       padding: const EdgeInsets.only(
                //           left: 24, right: 24, bottom: 15),
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Text(
                //             groupByValue.toString(),
                //             style: fprimMd,
                //           ),
                //           GestureDetector(
                //             onTap: () {
                //               Get.to(() => CategoryPage(),
                //                   arguments: groupByValue.toString());
                //             },
                //             child: Text(
                //               'See All',
                //               style: fprimMd,
                //             ),
                //           ),
                //         ],
                //       ),
                //     );
                //   },
                //   itemBuilder: (context, MagazineItem element) {
                //     final filteredMagazines = _.listMagazine
                //         .where((magazine) =>
                //             magazine.getYear() == element.getYear()).take(5)
                //         .toList();
                //     return SizedBox(
                //       height: 280,
                //       child: ListView.builder(
                //         scrollDirection: Axis.horizontal,
                //         physics: const ScrollPhysics(),
                //         itemCount: filteredMagazines.length,
                //         itemBuilder: (BuildContext context, int index) {
                //           MagazineItem data = filteredMagazines[index];
                //           return Padding(
                //             padding: const EdgeInsets.only(left: 24),
                //             child: MagazineCard(
                //               item: data,
                //               image: "${Endpoint.storage}/${data.cover}",
                //               title: data.name,
                //               release: data.dateRelease,
                //               pressRead: () {
                //                 Get.to(() => DetailPage(
                //                       item: data,
                //                     ));
                //               },
                //             ),
                //           );
                //         },
                //       ),
                //     );
                //   },
                //   itemComparator: (item1, item2) => item1.getYear()
                //       .compareTo(item2.getYear()), // optional
                //   order: GroupedListOrder.DESC,
                // );