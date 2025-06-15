import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final FirebaseFirestore _firestore;

  ProductRepositoryImpl(this._firestore);

  @override
  Future<Either<Exception, List<Product>>> getProducts() async {
    try {
      final snapshot = await _firestore.collection('products').get();
      final products = snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
      return Right(products);
    } catch (e) {
      return Left(Exception('Failed to fetch products: $e'));
    }
  }

  @override
  Future<Either<Exception, List<Product>>> searchProducts(String query) async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: query + '\uf8ff')
          .get();
      final products = snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
      return Right(products);
    } catch (e) {
      return Left(Exception('Failed to search products: $e'));
    }
  }

  @override
  Future<Either<Exception, List<Product>>> filterByCategory(String category) async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .where('category', isEqualTo: category)
          .get();
      final products = snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
      return Right(products);
    } catch (e) {
      return Left(Exception('Failed to filter products by category: $e'));
    }
  }

  @override
  Future<Either<Exception, List<Product>>> filterByBrand(String brand) async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .where('brand', isEqualTo: brand)
          .get();
      final products = snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
      return Right(products);
    } catch (e) {
      return Left(Exception('Failed to filter products by brand: $e'));
    }
  }

  @override
  Future<Either<Exception, List<Product>>> sortByName() async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .orderBy('name')
          .get();
      final products = snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
      return Right(products);
    } catch (e) {
      return Left(Exception('Failed to sort products by name: $e'));
    }
  }

  @override
  Future<Either<Exception, List<Product>>> sortByMRP() async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .orderBy('mrp')
          .get();
      final products = snapshot.docs
          .map((doc) => ProductModel.fromFirestore(doc))
          .toList();
      return Right(products);
    } catch (e) {
      return Left(Exception('Failed to sort products by MRP: $e'));
    }
  }
} 