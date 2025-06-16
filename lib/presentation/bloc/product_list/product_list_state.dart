import 'package:equatable/equatable.dart';
import '../../../domain/entities/product.dart';

abstract class ProductListState extends Equatable {
  const ProductListState();

  @override
  List<Object?> get props => [];
}

class ProductListInitial extends ProductListState {}

class ProductListLoading extends ProductListState {}

class ProductListLoaded extends ProductListState {
  final List<Product> allProducts;
  final List<Product> filteredProducts;
  final String? selectedCategory;
  final String? selectedBrand;
  final String? searchQuery;
  final String? sortBy;

  const ProductListLoaded({
    required this.allProducts,
    required this.filteredProducts,
    this.selectedCategory,
    this.selectedBrand,
    this.searchQuery,
    this.sortBy,
  });

  @override
  List<Object?> get props => [allProducts, filteredProducts, selectedCategory, selectedBrand, searchQuery, sortBy];
}

class ProductListError extends ProductListState {
  final String message;

  const ProductListError(this.message);

  @override
  List<Object?> get props => [message];
} 