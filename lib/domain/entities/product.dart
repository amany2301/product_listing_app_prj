import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String name;
  final String category;
  final double mrp;
  final double sellingRate;
  final String brand;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.mrp,
    required this.sellingRate,
    required this.brand,
  });

  @override
  List<Object?> get props => [id, name, category, mrp, sellingRate, brand];
} 