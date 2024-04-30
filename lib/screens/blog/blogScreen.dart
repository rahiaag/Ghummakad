import 'package:flutter/material.dart';
import 'package:ghumakkad_2/screens/blog/create_blog_screen.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Ghumakkad",
                style: TextStyle(fontSize: 22),
              ),
              Text(" Blog", style: TextStyle(fontSize: 22, color: Colors.blue))
            ],
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0),
      body: Container(),
      floatingActionButton: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FloatingActionButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CreateBlog()));
                },
                child: const Icon(Icons.add),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:ghumakad/screens/blog/create_blog_screen.dart';
// import 'package:ghumakad/services/firestore_methods.dart';

// class BlogPage extends StatefulWidget {
//   const BlogPage({super.key});

//   @override
//   _BlogPageState createState() => _BlogPageState();
// }

// class _BlogPageState extends State<BlogPage> {
//   FireStoreMethods crudMethods = FireStoreMethods();

//   late QuerySnapshot blogsSnapshot;
//   Widget BlogsList() {
//     return Container(
//         child: blogsSnapshot != null
//             ? Column(
//                 children: <Widget>[
//                   ListView.builder(
//                       padding: EdgeInsets.symmetric(horizontal: 16),
//                       itemCount: blogsSnapshot.docs.length,
//                       shrinkWrap: true,
//                       itemBuilder: (context, index) {
//                         (
//                           BlogsTile(
//                               authorName:
//                                   blogsSnapshot.docs[index].get('authorName'),
//                               title: blogsSnapshot.docs[index].get('title'),
//                               description:
//                                   blogsSnapshot.docs[index].get('desc'),
//                               imgUrl: blogsSnapshot.docs[index].get('imgUrl')),
//                         );
//                       })
//                 ],
//               )
//             : Container(
//                 alignment: Alignment.center,
//                 child: CircularProgressIndicator(),
//               ));
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();

//     crudMethods.getData().then((result) {
//       blogsSnapshot = result;
//     });
//     // }

//     @override
//     Widget build(BuildContext context) {
//       return Scaffold(
//         appBar: AppBar(
//             title: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Text(
//                   "Ghumakkad ",
//                   style: TextStyle(fontSize: 22),
//                 ),
//                 Text("Blog", style: TextStyle(fontSize: 22, color: Colors.blue))
//               ],
//             ),
//             backgroundColor: Colors.transparent,
//             elevation: 0.0),
//         body: Container(),
//         floatingActionButton: Container(
//           padding: EdgeInsets.symmetric(vertical: 20),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               FloatingActionButton(
//                 onPressed: () {
//                   Navigator.push(context,
//                       MaterialPageRoute(builder: (context) => CreateBlog()));
//                 },
//                 child: Icon(Icons.add),
//               )
//             ],
//           ),
//         ),
//       );
//     }
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     throw UnimplementedError();
//   }
// }

// class BlogsTile extends StatefulWidget {
//   String imgUrl, title, description, authorName;
//   BlogsTile(
//       {required this.imgUrl,
//       required this.title,
//       required this.description,
//       required this.authorName});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         child: Stack(
//       children: <Widget>[
//         ClipRRect(
//           borderRadius: BorderRadius.circular(6),
//           child: Image.network(imgUrl,
//               width: MediaQuery.of(context).size.width, fit: BoxFit.cover),
//         ),
//         Container(
//           margin: EdgeInsets.only(bottom: 16),
//           height: 150,
//           decoration: BoxDecoration(
//               color: Colors.black45.withOpacity(0.3),
//               borderRadius: BorderRadius.circular(6)),
//         ),
//         Container(
//           width: MediaQuery.of(context).size.width,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               Text(title,
//                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
//               SizedBox(height: 4),
//               Text(
//                 description,
//                 style: TextStyle(fontSize: 17),
//               ),
//               SizedBox(height: 4),
//               Text(authorName)
//             ],
//           ),
//         )
//       ],
//     ));
//   }

//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     throw UnimplementedError();
//   }
// }

