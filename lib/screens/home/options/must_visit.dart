import 'package:flutter/material.dart';
import 'package:ghumakkad_2/screens/home/location_detail.dart';
import 'package:ghumakkad_2/utils/constants.dart';
import 'package:ghumakkad_2/widgets/big_location_card.dart';
import 'package:ghumakkad_2/widgets/loader.dart';
import 'package:ghumakkad_2/widgets/location_card.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

class MustVisit extends StatefulWidget {
  const MustVisit({super.key});

  @override
  State<MustVisit> createState() => _MustVisitState();
}

class _MustVisitState extends State<MustVisit> {
  List<String> titles = [];
  List<String> urlImages = [];
  List<String> subtitle = [];

  Future getMustVisit() async {
    final url = Uri.parse(
        'https://www.incredibleindia.org/content/incredible-india-v2/en.html');
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);

    final subtitle = html
        .querySelectorAll(
            '#page-3e66f9114e > div:nth-child(1) > div.responsivegrid.aem-GridColumn.aem-GridColumn--default--12 > div:nth-child(1) > div.list-slider.aem-GridColumn.aem-GridColumn--default--12 > section > div > div:nth-child(1) > div > p')
        .map((element) => element.innerHtml.trim())
        .toList();

    final titles = html
        .querySelectorAll(
            '#page-3e66f9114e > div > div.responsivegrid.aem-GridColumn.aem-GridColumn--default--12 > div > div.list-slider.aem-GridColumn.aem-GridColumn--default--12 > section > div > div:nth-child(2) > div > div > div > div.owl-stage-outer > div > div[class*="owl-stage"] > div > a > div > h3')
        .map((element) => element.innerHtml.trim())
        .toList();

    final urlImages = html
        .querySelectorAll(
            '#page-3e66f9114e > div > div.responsivegrid.aem-GridColumn.aem-GridColumn--default--12 > div > div.list-slider.aem-GridColumn.aem-GridColumn--default--12 > section > div > div:nth-child(2) > div > div > div > div.owl-stage-outer > div > div[class*="owl-stage"] > div > a > div > div > img')
        .map((element) =>
            "https://www.incredibleindia.org/${element.attributes['data-src']!}")
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
    getMustVisit();
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
                  "Must Visit Destinations",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  subtitle[0],
                  textAlign: TextAlign.justify,
                  style: const TextStyle(
                      fontSize: 10, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            body: ListView.builder(
              itemCount: mustVisitTitles.length,
              // itemCount: locationList!.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                    // onTap: () {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => LocationDetailsScreen(
                    //         image: mustVisitImages[index],
                    //         title: mustVisitTitles[index],
                    //         // locationModel: locationList![index],
                    //       ),
                    //     ),
                    //   );
                    // },
                    child: LocationCard(
                      image: mustVisitImages[index],
                      locationName: mustVisitTitles[index],
                      description: mustVisitDescription[index],
                      // image: locationList![index].images[0],
                      // locationName: locationList![index].name,
                    ));
              },
            ),
          );
  }
}
