import 'package:flutter/material.dart';
import 'package:ghumakkad_2/screens/home/categoryLocationDetail.dart';
import 'package:ghumakkad_2/screens/home/location_detail.dart';
import 'package:ghumakkad_2/widgets/big_location_card.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

class South extends StatefulWidget {
  const South({super.key});

  @override
  State<South> createState() => _SouthState();
}

class _SouthState extends State<South> {
  List<String> regionTitles = [];
  List<String> regionImages = [];

  Future getSouthIndia() async {
    final url =
        Uri.parse('https://www.yatra.com/india-tourism/north-india-guide');
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);

    final regionTitles = html
        .querySelectorAll(
            '#cg-topCities_mscchild > div.blockDeal.block.prel.fs12.set.cg-topCities_mscss.cg-topCitiesmsc_1 > a > div > div.fl > p.c435061.fs18.txt-cap')
        .map((element) => element.innerHtml.trim())
        .toList();

    final regionImages = html
        .querySelectorAll(
            '#cg-topCities_mscchild > div.blockDeal.block.prel.fs12.set.cg-topCities_mscss.cg-topCitiesmsc_1 > a > figure > img')
        .map((element) => element.attributes['src']!)
        .toList();

    setState(() {
      this.regionTitles = regionTitles;
      this.regionImages = regionImages;
    });
  }

  @override
  void initState() {
    // fetchAllLocation();
    super.initState();
    getSouthIndia();
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
            const Expanded(
              child: Text(
                "Popular Cities in South India",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: regionTitles.length,
        // itemCount: locationList!.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryLocationDetailsScreen(
                      image: regionImages[index],
                      title: regionTitles[index],
                      categoryLocationData: [],
                      categoryIndex: 0,
                    ),
                  ),
                );
              },
              child: BigLocationCard(
                image: regionImages[index],
                locationName: regionTitles[index],
              ));
        },
      ),
    );
  }
}
