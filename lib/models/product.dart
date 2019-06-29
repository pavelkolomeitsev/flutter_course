import 'package:flutter/material.dart';

// create a class which holds all information about the product
// in other words we create a simple PODO-object

class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String image;
  final bool isFavorite;
  final String userEmail;
  final String userId;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.image,
    @required this.userEmail,
    @required this.userId,
    this.isFavorite = false,
  });
}
