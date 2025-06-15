import 'package:equatable/equatable.dart';

abstract class ProductListEvent extends Equatable {
  const ProductListEvent();

  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductListEvent {}

class SearchProducts extends ProductListEvent {
  final String query;

  const SearchProducts(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterByCategory extends ProductListEvent {
  final String category;

  const FilterByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class FilterByBrand extends ProductListEvent {
  final String brand;

  const FilterByBrand(this.brand);

  @override
  List<Object?> get props => [brand];
}

class SortByName extends ProductListEvent {}

class SortByMRP extends ProductListEvent {} 