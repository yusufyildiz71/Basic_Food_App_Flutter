import 'package:cloud_firestore/cloud_firestore.dart';

class Foods {
  String imageUrl;
  String name;
  String price;

  Foods({
    required this.imageUrl,
    required this.name,
    required this.price,
  });
  Map<String, dynamic> toJson() => {
        'imageUrl': imageUrl,
        'name':name,
        'price':price,
      };
}
