import 'package:flutter/material.dart';
import 'package:ghumakkad_2/screens/home/location_detail.dart';
import 'package:ghumakkad_2/search/widget/searched_location_card.dart';
import 'package:ghumakkad_2/utils/constants.dart';
import 'package:ghumakkad_2/widgets/big_location_card.dart';
import 'package:ghumakkad_2/widgets/loader.dart';
import 'package:ghumakkad_2/widgets/location_card.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

class PopularInIndia extends StatefulWidget {
  const PopularInIndia({super.key});

  @override
  State<PopularInIndia> createState() => _PopularInIndiaState();
}

class _PopularInIndiaState extends State<PopularInIndia> {
  List<String> titles = [];
  List<String> urlImages = [];
  List<String> subtitle = [];

  Future getPopularInIndia() async {
    final url = Uri.parse(
        'https://www.incredibleindia.org/content/incredible-india-v2/en.html');
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);

    final titles = html
        .querySelectorAll(
            'div > div > div > div > div > div > div.col-md-12.col-xs-12.poplr-story-content.new-poplr-story-content > div > div.col-md-9.p-0.mobile-responsive-hide > h4')
        .map((element) => element.innerHtml.trim())
        .toList();

    final subtitle = html
        .querySelectorAll('#carousel-text > p')
        .map((element) => element.innerHtml.trim())
        .toList();

    final urlImages = html
        .querySelectorAll(
            'div > div > div > div > div > div > div.col-md-12.col-xs-12.poplr-story-content.new-poplr-story-content > div > div.col-md-3 > div > img')
        .map((element) =>
            "https://www.incredibleindia.org/${element.attributes['src']!}")
        .toList();

    print('Titles Count: ${titles.length}');

    setState(() {
      this.titles = titles;
      this.subtitle = subtitle;
      this.urlImages = urlImages;
    });
  }

  @override
  void initState() {
    // fetchAllLocation();
    super.initState();
    getPopularInIndia();
  }

  @override
  Widget build(BuildContext context) {
    return subtitle.isEmpty
        ? const Loader()
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: ListTile(
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.arrow_back_ios),
                ),
                title: const Text(
                  "Popular In India",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  subtitle[0],
                  textAlign: TextAlign.justify,
                  style:
                      const TextStyle(fontSize: 8, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            body: ListView.builder(
              itemCount: titles.length,
              // itemCount: locationList!.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                    // onTap: () {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => LocationDetailsScreen(
                    //         image: urlImages[index],
                    //         title: titles[index],
                    //         // locationModel: locationList![index],
                    //       ),
                    //     ),
                    //   );
                    // },
                    child: LocationCard(
                      image: urlImages[index],
                      locationName: titles[index], 
                      description: popularInIndiaDescription[index],
                      // image: locationList![index].images[0],
                      // locationName: locationList![index].name,
                    ));
              },
            ),
          );
  }
}
