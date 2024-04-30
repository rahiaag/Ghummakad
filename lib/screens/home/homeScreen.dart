import 'package:flutter/material.dart';
import 'package:ghumakkad_2/models/location_model.dart';
import 'package:ghumakkad_2/screens/home/category_screen.dart';
import 'package:ghumakkad_2/screens/home/directions/east.dart';
import 'package:ghumakkad_2/screens/home/directions/north.dart';
import 'package:ghumakkad_2/screens/home/directions/south.dart';
import 'package:ghumakkad_2/screens/home/directions/west.dart';
import 'package:ghumakkad_2/screens/home/location_detail.dart';
import 'package:ghumakkad_2/screens/home/options/celebrate.dart';
import 'package:ghumakkad_2/screens/home/options/exploreBefore.dart';
import 'package:ghumakkad_2/screens/home/options/must_visit.dart';
import 'package:ghumakkad_2/screens/home/options/popular_in_india.dart';
import 'package:ghumakkad_2/screens/home/options/popular_trips.dart';
import 'package:ghumakkad_2/services/home_page_services.dart';
import 'package:ghumakkad_2/utils/constants.dart';
import 'package:ghumakkad_2/widgets/big_location_card.dart';
import 'package:ghumakkad_2/widgets/category_location_card.dart';
import 'package:ghumakkad_2/widgets/direction_card.dart';
import 'package:ghumakkad_2/widgets/home_app_bar.dart';
import 'package:ghumakkad_2/widgets/loader.dart';
import 'package:kommunicate_flutter/kommunicate_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<LocationModel>? locationList;
  final HomepageServices homepageServices = HomepageServices();
  var category = [
    'Popular In India',
    'Must Visit Destinations',
    // 'Top Attractions in India',
    'Explore Before You Visit',
    'Popular Trips',
    'Celebrate With Us',
  ];

  chatBot() async {
    tooltip:
    'Start Conversation';
    try {
      dynamic conversationObject = {
        'appId': '1e44f2ecb9b3b2ba0b8c971814178dd58',
      };
      KommunicateFlutterPlugin.buildConversation(conversationObject)
          .then((clientConversationId) {
        print("Conversation builder success : " +
            clientConversationId.toString());
      }).catchError((error) {
        print("Conversation builder error : " + error.toString());
      });
    } on Exception catch (error) {
      print("Conversation builder error : " + error.toString());
    }
  }

  fetchAllLocation() async {
    locationList = await homepageServices.fetchAllLocation(
      context: context,
    );
    setState(() {});
  }

  @override
  void initState() {
    // fetchAllLocation();
    super.initState();
    getCategories();
  }

  List<String> categoryTitle = [];
  List<String> categoryImages = [];

  Future getCategories() async {
    final url = Uri.parse(
        'https://www.incredibleindia.org/content/incredible-india-v2/en.html');
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);

    final categoryTitle = html
        .querySelectorAll(
            'div > div.responsivegrid.aem-GridColumn.aem-GridColumn--default--12 > div > div.experience-items.aem-GridColumn.aem-GridColumn--default--12 > section > div > div.row.justify-content-center > div > a > span')
        .map((element) => element.innerHtml.trim())
        .toList();

    final categoryImages = html
        .querySelectorAll(
            'div > div.responsivegrid.aem-GridColumn.aem-GridColumn--default--12 > div > div.experience-items.aem-GridColumn.aem-GridColumn--default--12 > section > div > div.row.justify-content-center > div > a > div > img')
        .map((element) =>
            // element.attributes['src']!)
            "https://www.incredibleindia.org${element.attributes['data-src']!}")
        .toList();

    print('Title : ${categoryTitle}');
    print('info : $categoryImages');

    setState(() {
      this.categoryTitle = categoryTitle;
      this.categoryImages = categoryImages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return
        // locationList == null
        categoryTitle.isEmpty
            ? const Loader()
            : Scaffold(
                appBar: const PreferredSize(
                  preferredSize: Size.fromHeight(100.0),
                  child: HomeAppBar(),
                ),
                body: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 200,
                                  child: ListView.builder(
                                    itemCount: categoryTitle.length,
                                    // itemCount: categories.length,
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CategoryScreen(
                                                categoryName:
                                                    categoryTitle[index],
                                                image: categoryImages[index],
                                                // categoryName: categories[index]['title']!,
                                              ),
                                            ),
                                          );
                                        },
                                        child: ((index >=0 && index <7) || index == 9) ? CategoryCard(
                                          image: categoryImages[index],
                                          categoryName: categoryTitle[index],
                                          // image: categories[index]['image']!,
                                          // categoryName: categories[index]['title']!,
                                        ) : Container(),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  for (int i = 0; i < 5; i++)
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => i == 0
                                                ? const PopularInIndia()
                                                : i == 1
                                                    ? const MustVisit()
                                                    : i == 2
                                                        ? const ExploreBefore()
                                                        : i == 3
                                                            ? const PopularTrips()
                                                            : const Celebrate(),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          category[i],
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Ghumakkad",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: const Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "One of the oldest civilisations in the world, India is a mosaic of multicultural experiences. With a rich heritage and myriad attractions, the country is among the most popular tourist destinations in the world. It covers an area of 32, 87,263 sq. km, extending from the snow-covered Himalayan heights to the tropical rain forests of the south. As the 7th largest country in the world, India stands apart from the rest of Asia, marked off as it is by mountains and the sea, which give the country a distinct geographical entity.",
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Fringed by the Great Himalayas in the north, it stretches southwards and at the Tropic of Cancer, tapers off into the Indian Ocean between the Bay of Bengal on the east and the Arabian Sea on the west. As you travel the expanse of the country, you are greeted by diverse nuances of cuisines, faiths, arts, crafts, music, nature, lands, tribes, history and adventure sports. India has a mesmeric conflation of the old and the new. As the bustling old bazaars rub shoulders with swanky shopping malls, and majestic monuments accompany luxurious heritage hotels, the quintessential traveller can get the best of both worlds. Head to the mountains, enjoy a beach retreat or cruise through the golden Thar, India has options galore for all.",
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // const Padding(
                          //   padding: EdgeInsets.all(8.0),
                          //   child: Align(
                          //     alignment: Alignment.centerLeft,
                          //     child: Text(
                          //       "Ghumakkad Travels",
                          //       style: TextStyle(
                          //         fontSize: 20,
                          //         fontWeight: FontWeight.bold,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.all(8.0),
                          //   child: Container(
                          //     width: MediaQuery.of(context).size.width,
                          //     child: Column(
                          //       children: [
                          //         Row(
                          //           mainAxisAlignment: MainAxisAlignment.center,
                          //           children: [
                          //             InkWell(
                          //               onTap: () {
                          //                 Navigator.push(
                          //                   context,
                          //                   MaterialPageRoute(
                          //                     builder: (context) =>
                          //                         const North(),
                          //                   ),
                          //                 );
                          //               },
                          //               child: const DirectionCard(
                          //                 name: "North India",
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //         const SizedBox(
                          //           height: 15,
                          //         ),
                          //         Row(
                          //           mainAxisAlignment:
                          //               MainAxisAlignment.spaceBetween,
                          //           children: [
                          //             InkWell(
                          //               onTap: () {
                          //                 Navigator.push(
                          //                   context,
                          //                   MaterialPageRoute(
                          //                     builder: (context) =>
                          //                         const West(),
                          //                   ),
                          //                 );
                          //               },
                          //               child: const DirectionCard(
                          //                 name: "West India",
                          //               ),
                          //             ),
                          //             InkWell(
                          //               onTap: () {
                          //                 Navigator.push(
                          //                   context,
                          //                   MaterialPageRoute(
                          //                     builder: (context) =>
                          //                         const East(),
                          //                   ),
                          //                 );
                          //               },
                          //               child: const DirectionCard(
                          //                 name: "East India",
                          //               ),
                          //             ),
                          //           ],
                          //         ),
                          //         const SizedBox(
                          //           height: 15,
                          //         ),
                          //         Row(
                          //           mainAxisAlignment: MainAxisAlignment.center,
                          //           children: [
                          //             InkWell(
                          //               onTap: () {
                          //                 Navigator.push(
                          //                   context,
                          //                   MaterialPageRoute(
                          //                     builder: (context) =>
                          //                         const South(),
                          //                   ),
                          //                 );
                          //               },
                          //               child: const DirectionCard(
                          //                 name: "South India",
                          //               ),
                          //             ),
                          //           ],
                          //         )
                          //       ],
                          //     ),
                          //   ),
                          // )
                        ],
                      ),
                    ),
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  shape: const CircleBorder(),
                  backgroundColor: Colors.white,
                  onPressed: chatBot,
                  child: const Icon(
                    Icons.chat,
                    color: Colors.orange,
                    size: 30,
                  ),
                ),
              );
  }
}
