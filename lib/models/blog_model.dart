import 'package:cloud_firestore/cloud_firestore.dart';

class Blog {
  final String description;
  final String title;
  final String authorName;
  final String postId;
  final String postUrl;

  const Blog({
    required this.description,
    required this.title,
    required this.authorName,
    required this.postId,
    required this.postUrl,
  });

  Map<String , dynamic> toJson() => {
    "description": description,
    "title": title,
    "authorName": authorName,
    "postId" : postId,
    "postUrl": postUrl,
  };

  static Blog fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map<String , dynamic>;

    return Blog(
      authorName: snapshot['authorName'],
      title: snapshot['title'],
      description: snapshot['description'],
      postId: snapshot['postId'],
      postUrl: snapshot['postUrl'],
    );
  }
}
