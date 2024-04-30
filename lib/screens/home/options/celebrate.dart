import 'package:flutter/material.dart';
import 'package:ghumakkad_2/screens/home/location_detail.dart';
import 'package:ghumakkad_2/utils/constants.dart';
import 'package:ghumakkad_2/widgets/big_location_card.dart';
import 'package:ghumakkad_2/widgets/loader.dart';
import 'package:ghumakkad_2/widgets/location_card.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

class Celebrate extends StatefulWidget {
  const Celebrate({super.key});

  @override
  State<Celebrate> createState() => _CelebrateState();
}

class _CelebrateState extends State<Celebrate> {
  List<String> titles = [];
  List<String> urlImages = [];
  List<String> subtitle = [];

  Future getCelebrate() async {
    final url = Uri.parse(
        'https://www.incredibleindia.org/content/incredible-india-v2/en.html');
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);

    final subtitle = html
        .querySelectorAll(
            '#page-3e66f9114e > div > div.responsivegrid.aem-GridColumn.aem-GridColumn--default--12 > div.list-slider.aem-GridColumn.aem-GridColumn--default--12 > section > div > div > div > p')
        .map((element) => element.innerHtml.trim())
        .toList();

    final titles = html
        .querySelectorAll(
            '#page-3e66f9114e > div > div.responsivegrid.aem-GridColumn.aem-GridColumn--default--12 > div.list-slider.aem-GridColumn.aem-GridColumn--default--12 > section > div > div > div > div > div > div.owl-stage-outer > div > div[class*="owl-item"] > div > a > div > h3')
        .map((element) => element.innerHtml.trim())
        .toList();

    final urlImages = html
        .querySelectorAll(
            '#page-3e66f9114e > div > div.responsivegrid.aem-GridColumn.aem-GridColumn--default--12 > div.list-slider.aem-GridColumn.aem-GridColumn--default--12 > section > div > div > div > div > div > div.owl-stage-outer > div > div[class*="owl-item"] > div > a > div > div > img')
        .map((element) =>
            "https://www.incredibleindia.org/${element.attributes['src']!}")
        .toList();

    print('Titles Count: ${titles.length}');
    print('Images Count: ${urlImages.length}');

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
    getCelebrate();
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
                  "Celebrate With Us",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  subtitle[0],
                  textAlign: TextAlign.justify,
                  style:
                      const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            body: ListView.builder(
              itemCount: celebrateTitles.length,
              // itemCount: locationList!.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                    // onTap: () {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => LocationDetailsScreen(
                    //         image: celebrateImages[index],
                    //         title: celebrateTitles[index],
                    //       ),
                    //     ),
                    //   );
                    // },
                    child: LocationCard(
                      image: celebrateImages[index],
                      locationName: celebrateTitles[index],
                      description: celebrateDescription[index],
                    ));
              },
            ),
          );
  }
}
