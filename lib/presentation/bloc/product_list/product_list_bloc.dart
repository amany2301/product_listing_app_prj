import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/product_repository.dart';
import 'product_list_event.dart';
import 'product_list_state.dart';

class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  final ProductRepository _repository;

  ProductListBloc(this._repository) : super(ProductListInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<SearchProducts>(_onSearchProducts);
    on<FilterByCategory>(_onFilterByCategory);
    on<FilterByBrand>(_onFilterByBrand);
    on<SortByName>(_onSortByName);
    on<SortByMRP>(_onSortByMRP);
  }

  Future<void> _onLoadProducts(LoadProducts event, Emitter<ProductListState> emit) async {
    emit(ProductListLoading());
    final result = await _repository.getProducts();
    result.fold(
      (error) => emit(ProductListError(error.toString())),
      (products) => emit(ProductListLoaded(
        allProducts: products,
        filteredProducts: products,
      )),
    );
  }

  Future<void> _onSearchProducts(SearchProducts event, Emitter<ProductListState> emit) async {
    if (state is ProductListLoaded) {
      final currentState = state as ProductListLoaded;
      emit(ProductListLoading());
      final result = await _repository.searchProducts(event.query);
      result.fold(
        (error) => emit(ProductListError(error.toString())),
        (products) => emit(ProductListLoaded(
          allProducts: currentState.allProducts,
          filteredProducts: products,
          selectedCategory: currentState.selectedCategory,
          selectedBrand: currentState.selectedBrand,
          searchQuery: event.query,
          sortBy: currentState.sortBy,
        )),
      );
    }
  }

  Future<void> _onFilterByCategory(FilterByCategory event, Emitter<ProductListState> emit) async {
    if (state is ProductListLoaded) {
      final currentState = state as ProductListLoaded;
      emit(ProductListLoading());
      final result = await _repository.filterByCategory(event.category);
      result.fold(
        (error) => emit(ProductListError(error.toString())),
        (products) => emit(ProductListLoaded(
          allProducts: currentState.allProducts,
          filteredProducts: products,
          selectedCategory: event.category,
          selectedBrand: currentState.selectedBrand,
          searchQuery: currentState.searchQuery,
          sortBy: currentState.sortBy,
        )),
      );
    }
  }

  Future<void> _onFilterByBrand(FilterByBrand event, Emitter<ProductListState> emit) async {
    if (state is ProductListLoaded) {
      final currentState = state as ProductListLoaded;
      emit(ProductListLoading());
      final result = await _repository.filterByBrand(event.brand);
      result.fold(
        (error) => emit(ProductListError(error.toString())),
        (products) => emit(ProductListLoaded(
          allProducts: currentState.allProducts,
          filteredProducts: products,
          selectedCategory: currentState.selectedCategory,
          selectedBrand: event.brand,
          searchQuery: currentState.searchQuery,
          sortBy: currentState.sortBy,
        )),
      );
    }
  }

  Future<void> _onSortByName(SortByName event, Emitter<ProductListState> emit) async {
    if (state is ProductListLoaded) {
      final currentState = state as ProductListLoaded;
      emit(ProductListLoading());
      final result = await _repository.sortByName();
      result.fold(
        (error) => emit(ProductListError(error.toString())),
        (products) => emit(ProductListLoaded(
          allProducts: currentState.allProducts,
          filteredProducts: products,
          selectedCategory: currentState.selectedCategory,
          selectedBrand: currentState.selectedBrand,
          searchQuery: currentState.searchQuery,
          sortBy: 'name',
        )),
      );
    }
  }

  Future<void> _onSortByMRP(SortByMRP event, Emitter<ProductListState> emit) async {
    if (state is ProductListLoaded) {
      final currentState = state as ProductListLoaded;
      emit(ProductListLoading());
      final result = await _repository.sortByMRP();
      result.fold(
        (error) => emit(ProductListError(error.toString())),
        (products) => emit(ProductListLoaded(
          allProducts: currentState.allProducts,
          filteredProducts: products,
          selectedCategory: currentState.selectedCategory,
          selectedBrand: currentState.selectedBrand,
          searchQuery: currentState.searchQuery,
          sortBy: 'mrp',
        )),
      );
    }
  }
} 