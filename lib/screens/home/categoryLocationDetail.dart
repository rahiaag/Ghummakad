import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:ghumakkad_2/models/location_model.dart';

class CategoryLocationDetailsScreen extends StatefulWidget {
  final String image;
  final String title;
  final int categoryIndex;
  final List<List<String>> categoryLocationData;
  const CategoryLocationDetailsScreen(
      {super.key, required this.image, required this.title, required this.categoryLocationData, required this.categoryIndex});
  // final LocationModel locationModel;
  // const LocationDetailsScreen(
  //     {super.key,
  //     required this.locationModel,
  //     required this.image,
  //     required this.title});

  @override
  State<CategoryLocationDetailsScreen> createState() => _CategoryLocationDetailsScreenState();
}

class _CategoryLocationDetailsScreenState extends State<CategoryLocationDetailsScreen> {
  List<String> locationTitles = [];
  List<String> locationImages = [];
  List<String> locationDescription = [];

  Future getAttractions() async {
    final url = Uri.parse(
        'https://www.incredibleindia.org/content/incredible-india-v2/en/experiences/heritage/most-popular.html');
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);

    final locationTitles = html
        .querySelectorAll(
            '#page-3d51102016 > div > div.responsivegrid.aem-GridColumn.aem-GridColumn--default--12 > div > div.attraction-in-dest-list.aem-GridColumn.aem-GridColumn--default--12 > section > div.container.text-center > div > div.owl-stage-outer > div > div > div > a > div > h2')
        .map((element) => element.innerHtml.trim())
        .toList();

    final locationDescription = html
        .querySelectorAll(
            '#page-3d51102016 > div > div.responsivegrid.aem-GridColumn.aem-GridColumn--default--12 > div > div.attraction-in-dest-list.aem-GridColumn.aem-GridColumn--default--12 > section > div.container.text-center > div > div.owl-stage-outer > div > div > div > a > div > p')
        .map((element) => element.innerHtml.trim())
        .toList();

    final locationImages = html
        .querySelectorAll(
            '#page-3d51102016 > div > div.responsivegrid.aem-GridColumn.aem-GridColumn--default--12 > div > div.attraction-in-dest-list.aem-GridColumn.aem-GridColumn--default--12 > section > div.container.text-center > div > div.owl-stage-outer > div > div > div > a > div > div > img')
        .map((element) =>
            // element.attributes['src']!)
            "https://www.incredibleindia.org${element.attributes['data-src']!}")
        .toList();

    print('Titles Count: ${locationTitles.length}');
    print('Images Count: ${locationImages.length}');
    print('info : $locationDescription');

    setState(() {
      this.locationTitles = locationTitles;
      this.locationDescription = locationDescription;
      this.locationImages = locationImages;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAttractions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_ios),
            ),
            // Text(widget.locationModel.name),
            Text(widget.title),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: widget.categoryLocationData[0].length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                    decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(15),
                    ),
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      widget.categoryLocationData[0][index],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Image(
                    image: NetworkImage(
                      widget.categoryLocationData[1][index],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.categoryLocationData[2][index],
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),

      // SingleChildScrollView(
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Padding(
      //         padding: const EdgeInsets.symmetric(
      //           vertical: 20.0,
      //           horizontal: 10,
      //         ),
      //         child: Text(
      //           // widget.locationModel.name,
      //           widget.title,
      //           style: const TextStyle(
      //             fontSize: 15,
      //           ),
      //         ),
      //       ),
      //       // CarouselSlider(
      //       //   items: widget.locationModel.images.map((i) {
      //       //     return Builder(
      //       //       builder: (BuildContext context) => Image.network(
      //       //         i,
      //       //         fit: BoxFit.contain,
      //       //         height: 200,
      //       //       ),
      //       //     );
      //       //   }).toList(),
      //       //   options: CarouselOptions(
      //       //     viewportFraction: 1,
      //       //     height: 300,
      //       //   ),
      //       // ),
      //       Container(
      //         height: 200,
      //         decoration: BoxDecoration(
      //           color: Colors.black,
      //           borderRadius: BorderRadius.circular(15),
      //           image: DecorationImage(
      //             opacity: 0.8,
      //             image: NetworkImage(widget.image),
      //             fit: BoxFit.cover,
      //             colorFilter: ColorFilter.mode(
      //               Colors.black.withOpacity(0.8),
      //               BlendMode.dstATop,
      //             ),
      //           ),
      //         ),
      //       ),
      //       Container(
      //         color: Colors.black12,
      //         height: 5,
      //       ),
      //       Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: Text(
      //           // widget.locationModel.description,
      //           "HIII",
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
