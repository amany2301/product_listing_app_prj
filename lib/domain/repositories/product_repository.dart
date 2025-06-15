import 'package:dartz/dartz.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  Future<Either<Exception, List<Product>>> getProducts();
  Future<Either<Exception, List<Product>>> searchProducts(String query);
  Future<Either<Exception, List<Product>>> filterByCategory(String category);
  Future<Either<Exception, List<Product>>> filterByBrand(String brand);
  Future<Either<Exception, List<Product>>> sortByName();
  Future<Either<Exception, List<Product>>> sortByMRP();
} 