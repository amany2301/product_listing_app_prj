import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String name;
  final String category;
  final double mrp;
  final double sellingRate;
  final String brand;
  final String imageUrl;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.mrp,
    required this.sellingRate,
    required this.brand,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [id, name, category, mrp, sellingRate, brand, imageUrl];
} 