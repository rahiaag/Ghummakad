import 'package:flutter/material.dart';
import 'package:ghumakkad_2/models/location_model.dart';
import 'package:ghumakkad_2/screens/home/categoryLocationDetail.dart';
import 'package:ghumakkad_2/screens/home/location_detail.dart';
import 'package:ghumakkad_2/search/widget/searched_location.dart';
import 'package:ghumakkad_2/services/home_page_services.dart';
import 'package:ghumakkad_2/utils/category/adventure.dart';
import 'package:ghumakkad_2/utils/category/art.dart';
import 'package:ghumakkad_2/utils/category/food_and_cuisine.dart';
import 'package:ghumakkad_2/utils/category/heritage.dart';
import 'package:ghumakkad_2/utils/category/luxury.dart';
import 'package:ghumakkad_2/utils/category/nature_and_wildlife.dart';
import 'package:ghumakkad_2/utils/category/spiritual.dart';
import 'package:ghumakkad_2/utils/category/yoga_and_wellness.dart';
import 'package:ghumakkad_2/widgets/big_location_card.dart';
import 'package:ghumakkad_2/widgets/loader.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

class CategoryScreen extends StatefulWidget {
  final String image;
  final String categoryName;
  const CategoryScreen(
      {super.key, required this.categoryName, required this.image});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<LocationModel>? locationList;
  final HomepageServices categoryServices = HomepageServices();

  fetchCategoryLocation() async {
    locationList = await categoryServices.fetchCategoryLocation(
      context: context,
      categoryQuery: widget.categoryName,
    );
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    // fetchCategoryLocation();
    super.initState();
    getCategoriesLocation();
  }

  List<String> categoryLocationTitle = [];
  List<String> categoryLocationImages = [];
  String categoryLocationInfo = "Hello brother";

  Future getCategoriesLocation() async {
    final url = widget.categoryName == "Heritage"
        ? Uri.parse(
            'https://www.incredibleindia.org/content/incredible-india-v2/en/experiences/heritage.html')
        : widget.categoryName == "Adventure"
            ? Uri.parse(
                'https://www.incredibleindia.org/content/incredible-india-v2/en/experiences/adventure.html')
            : widget.categoryName == "Art"
                ? Uri.parse(
                    'https://www.incredibleindia.org/content/incredible-india-v2/en/experiences/art.html')
                : widget.categoryName == "Food and Cuisine"
                    ? Uri.parse(
                        'https://www.incredibleindia.org/content/incredible-india-v2/en/experiences/food-and-cuisine.html')
                    : widget.categoryName == "Luxury"
                        ? Uri.parse(
                            'https://www.incredibleindia.org/content/incredible-india-v2/en/experiences/luxury.html')
                        : widget.categoryName == "Nature and Wildlife"
                            ? Uri.parse(
                                'https://www.incredibleindia.org/content/incredible-india-v2/en/experiences/nature-and-wildlife.html')
                            : widget.categoryName == "Spiritual"
                                ? Uri.parse(
                                    'https://www.incredibleindia.org/content/incredible-india-v2/en/experiences/spiritual.html')
                                // : widget.categoryName == "Museums In India"
                                //     ? Uri.parse(
                                //         'https://www.incredibleindia.org/content/incredible-india-v2/en/experiences/museums-in-india.html')
                                //     : widget.categoryName == "Shopping"
                                //         ? Uri.parse(
                                //             'https://www.incredibleindia.org/content/incredible-india-v2/en/experiences/shopping.html')
                                : Uri.parse(
                                    'https://www.incredibleindia.org/content/incredible-india-v2/en/experiences/yoga-and-wellness.html');
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);

    final categoryLocationTitle = html
        .querySelectorAll('#masonry-card > a > div > h4')
        .map((element) => element.innerHtml.trim())
        .toList();

    final categoryLocationInfo = html
        .querySelector(
            'div > div.title-description.aem-GridColumn.aem-GridColumn--default--12 > div > div > div > div.col-12.paragraph.text-center.read-more-hide.no-hide-para > p')
        ?.text;

    final categoryLocationImages = html
        .querySelectorAll('#masonry-card > a > div > div > img')
        .map((element) =>
            // element.attributes['src']!)
            "https://www.incredibleindia.org${element.attributes['src']!}")
        .toList();

    print('Titles Count: ${categoryLocationTitle.length}');
    print('Images Count: ${categoryLocationImages.length}');
    print('Title : ${categoryLocationTitle[0]}');
    print('info : $categoryLocationInfo');
    print('Images : ${categoryLocationImages[0]}');

    setState(() {
      // this.categoryLocationInfo = categoryLocationInfo!;
      this.categoryLocationTitle = categoryLocationTitle;
      this.categoryLocationImages = categoryLocationImages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_ios),
            ),
            Expanded(
              child: Text(
                widget.categoryName,
              ),
            ),
          ],
        ),
      ),
      body:
          // locationList == null
          categoryLocationTitle.isEmpty
              ? const Loader()
              : SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Container(
                        //   // height: MediaQuery.of(context).size.height,
                        //   width: MediaQuery.of(context).size.width,
                        //   decoration: BoxDecoration(
                        //     color: Colors.grey[200],
                        //     borderRadius: BorderRadius.circular(7),
                        //   ),
                        //   padding: const EdgeInsets.all(8),
                        //   child: Text(
                        //     categoryLocationInfo,
                        //     textAlign: TextAlign.justify,
                        //     style: const TextStyle(
                        //       fontSize: 14,
                        //     ),
                        //   ),
                        // ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height - 120,
                          child: ListView.builder(
                            itemCount: categoryLocationTitle.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CategoryLocationDetailsScreen(
                                          image: categoryLocationImages[index],
                                          title: categoryLocationTitle[index],
                                          categoryIndex: widget.categoryName ==
                                                  "Heritage"
                                              ? 0
                                              : widget.categoryName ==
                                                      "Adventure"
                                                  ? 1
                                                  : widget.categoryName == "Art"
                                                      ? 2
                                                      : widget.categoryName ==
                                                              "Food and Cuisine"
                                                          ? 3
                                                          : widget.categoryName ==
                                                                  "Luxury"
                                                              ? 4
                                                              : widget.categoryName ==
                                                                      "Nature and Wildlife"
                                                                  ? 5
                                                                  : widget.categoryName ==
                                                                          "Spiritual"
                                                                      ? 6
                                                                      : 7,
                                          categoryLocationData: widget
                                                      .categoryName ==
                                                  "Heritage"
                                              ? heritageCategory[index]
                                              : widget.categoryName ==
                                                      "Adventure"
                                                  ? adventureCategory[index]
                                                  : widget.categoryName == "Art"
                                                      ? artCategory[index]
                                                      : widget.categoryName ==
                                                              "Food and Cuisine"
                                                          ? foodAndCuisineCategory[
                                                              index]
                                                          : widget.categoryName ==
                                                                  "Luxury"
                                                              ? luxuryCategory[
                                                                  index]
                                                              : widget.categoryName ==
                                                                      "Nature and Wildlife"
                                                                  ? natureAndWildlifeCategory[
                                                                      index]
                                                                  : widget.categoryName ==
                                                                          "Spiritual"
                                                                      ? spiritualCategory[
                                                                          index]
                                                                      : yogaAndWellnessCategory[
                                                                          index],
                                        ),
                                      ),
                                    );
                                  },
                                  child: BigLocationCard(
                                    image: categoryLocationImages[index],
                                    locationName: categoryLocationTitle[index],
                                  ));
                            },
                          ),

                          // GridView.builder(
                          //   scrollDirection: Axis.vertical,
                          //   gridDelegate:
                          //       SliverGridDelegateWithFixedCrossAxisCount(
                          //     childAspectRatio: width / (height / 1.5),
                          //     crossAxisSpacing: 2,
                          //     mainAxisSpacing: 15,
                          //     crossAxisCount: 2,
                          //   ),
                          //   itemBuilder: (context, index) {
                          //     // if (locationList != null && locationList!.isNotEmpty) {
                          //     //   if (index >= 0 && index < locationList!.length) {
                          //     if (categoryLocationTitle.isNotEmpty) {
                          //       if (index >= 0 &&
                          //           index < categoryLocationTitle.length) {
                          //         print(index);
                          //         print(categoryLocationTitle[index]);
                          //         print(categoryLocationImages[index]);
                          //         return SearchedLocation(
                          //           image: categoryLocationImages[index],
                          //           title: categoryLocationTitle[index],
                          //           // locationModel: locationList![index],
                          //         );
                          //       } else {
                          //         print("Index out of bounds");
                          //       }
                          //     } else {
                          //       print("Data is empty or null");
                          //     }
                          //   },
                          // ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
