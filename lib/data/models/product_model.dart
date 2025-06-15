import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.category,
    required super.mrp,
    required super.sellingRate,
    required super.brand,
    required super.imageUrl,
  });

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: (data['id'] as num).toInt(),
      name: data['name'] as String,
      category: data['category'] as String,
      mrp: (data['mrp'] as num).toDouble(),
      sellingRate: (data['sellingRate'] as num).toDouble(),
      brand: data['brand'] as String,
      imageUrl: data['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'mrp': mrp,
      'sellingRate': sellingRate,
      'brand': brand,
      'imageUrl': imageUrl,
    };
  }
} 