import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:product_listing_app_prj/domain/entities/product.dart';
import 'package:product_listing_app_prj/domain/repositories/product_repository.dart';
import 'package:product_listing_app_prj/presentation/bloc/product_list/product_list_bloc.dart';
import 'package:product_listing_app_prj/presentation/bloc/product_list/product_list_event.dart';
import 'package:product_listing_app_prj/presentation/bloc/product_list/product_list_state.dart';
import 'package:dartz/dartz.dart';

@GenerateMocks([ProductRepository])
import 'product_list_bloc_test.mocks.dart';

void main() {
  late MockProductRepository mockRepository;
  late ProductListBloc bloc;

  final testProducts = [
    Product(
      id: 1,
      name: 'Test Product 1',
      brand: 'Brand A',
      category: 'Category X',
      mrp: 100.0,
      sellingRate: 80.0,
      imageUrl: 'https://example.com/image1.jpg',
    ),
    Product(
      id: 2,
      name: 'Test Product 2',
      brand: 'Brand B',
      category: 'Category Y',
      mrp: 200.0,
      sellingRate: 150.0,
      imageUrl: 'https://example.com/image2.jpg',
    ),
    Product(
      id: 3,
      name: 'Another Product',
      brand: 'Brand A',
      category: 'Category X',
      mrp: 150.0,
      sellingRate: 120.0,
      imageUrl: 'https://example.com/image3.jpg',
    ),
  ];

  setUp(() {
    mockRepository = MockProductRepository();
    bloc = ProductListBloc(mockRepository);
  });

  tearDown(() {
    bloc.close();
  });

  group('ProductListBloc', () {
    test('initial state is ProductListInitial', () {
      expect(bloc.state, isA<ProductListInitial>());
    });

    blocTest<ProductListBloc, ProductListState>(
      'emits [loading, loaded] when products are loaded successfully',
      build: () {
        when(mockRepository.getProducts())
            .thenAnswer((_) async => Right(testProducts));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadProducts()),
      expect: () => [
        isA<ProductListLoading>(),
        isA<ProductListLoaded>().having(
          (state) => state.allProducts,
          'all products',
          testProducts,
        ),
      ],
    );

    blocTest<ProductListBloc, ProductListState>(
      'emits [loading, error] when loading products fails',
      build: () {
        when(mockRepository.getProducts())
            .thenAnswer((_) async => Left(Exception('Failed to load products')));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadProducts()),
      expect: () => [
        isA<ProductListLoading>(),
        isA<ProductListError>().having(
          (state) => state.message,
          'error message',
          'Exception: Failed to load products',
        ),
      ],
    );

    blocTest<ProductListBloc, ProductListState>(
      'filters products by category correctly',
      build: () {
        when(mockRepository.getProducts())
            .thenAnswer((_) async => Right(testProducts));
        when(mockRepository.filterByCategory('Category X'))
            .thenAnswer((_) async => Right(testProducts.where((p) => p.category == 'Category X').toList()));
        return bloc;
      },
      act: (bloc) => bloc.add(FilterByCategory('Category X')),
      expect: () => [
        isA<ProductListLoading>(),
        isA<ProductListLoaded>().having(
          (state) => state.allProducts,
          'all products',
          testProducts,
        ),
        isA<ProductListLoading>(),
        isA<ProductListLoaded>().having(
          (state) => state.filteredProducts,
          'filtered products',
          testProducts.where((p) => p.category == 'Category X').toList(),
        ),
      ],
    );

    blocTest<ProductListBloc, ProductListState>(
      'filters products by brand correctly',
      build: () {
        when(mockRepository.getProducts())
            .thenAnswer((_) async => Right(testProducts));
        when(mockRepository.filterByBrand('Brand A'))
            .thenAnswer((_) async => Right(testProducts.where((p) => p.brand == 'Brand A').toList()));
        return bloc;
      },
      act: (bloc) => bloc.add(FilterByBrand('Brand A')),
      expect: () => [
        isA<ProductListLoading>(),
        isA<ProductListLoaded>().having(
          (state) => state.allProducts,
          'all products',
          testProducts,
        ),
        isA<ProductListLoading>(),
        isA<ProductListLoaded>().having(
          (state) => state.filteredProducts,
          'filtered products',
          testProducts.where((p) => p.brand == 'Brand A').toList(),
        ),
      ],
    );

    blocTest<ProductListBloc, ProductListState>(
      'sorts products by name correctly',
      build: () {
        when(mockRepository.getProducts())
            .thenAnswer((_) async => Right(testProducts));
        when(mockRepository.sortByName())
            .thenAnswer((_) async => Right([...testProducts]..sort((a, b) => a.name.compareTo(b.name))));
        return bloc;
      },
      act: (bloc) => bloc.add(SortByName()),
      expect: () => [
        isA<ProductListLoading>(),
        isA<ProductListLoaded>().having(
          (state) => state.allProducts,
          'all products',
          testProducts,
        ),
        isA<ProductListLoading>(),
        isA<ProductListLoaded>().having(
          (state) => state.filteredProducts,
          'sorted products',
          [...testProducts]..sort((a, b) => a.name.compareTo(b.name)),
        ),
      ],
    );

    blocTest<ProductListBloc, ProductListState>(
      'sorts products by MRP correctly',
      build: () {
        when(mockRepository.getProducts())
            .thenAnswer((_) async => Right(testProducts));
        when(mockRepository.sortByMRP())
            .thenAnswer((_) async => Right([...testProducts]..sort((a, b) => a.mrp.compareTo(b.mrp))));
        return bloc;
      },
      act: (bloc) => bloc.add(SortByMRP()),
      expect: () => [
        isA<ProductListLoading>(),
        isA<ProductListLoaded>().having(
          (state) => state.allProducts,
          'all products',
          testProducts,
        ),
        isA<ProductListLoading>(),
        isA<ProductListLoaded>().having(
          (state) => state.filteredProducts,
          'sorted products',
          [...testProducts]..sort((a, b) => a.mrp.compareTo(b.mrp)),
        ),
      ],
    );

    blocTest<ProductListBloc, ProductListState>(
      'searches products correctly',
      build: () {
        when(mockRepository.getProducts())
            .thenAnswer((_) async => Right(testProducts));
        when(mockRepository.searchProducts('Test'))
            .thenAnswer((_) async => Right(testProducts.where((p) => p.name.contains('Test')).toList()));
        return bloc;
      },
      act: (bloc) => bloc.add(SearchProducts('Test')),
      expect: () => [
        isA<ProductListLoading>(),
        isA<ProductListLoaded>().having(
          (state) => state.allProducts,
          'all products',
          testProducts,
        ),
        isA<ProductListLoading>(),
        isA<ProductListLoaded>().having(
          (state) => state.filteredProducts,
          'searched products',
          testProducts.where((p) => p.name.contains('Test')).toList(),
        ),
      ],
    );

    blocTest<ProductListBloc, ProductListState>(
      'handles empty search query correctly',
      build: () {
        when(mockRepository.getProducts())
            .thenAnswer((_) async => Right(testProducts));
        when(mockRepository.searchProducts(''))
            .thenAnswer((_) async => Right(testProducts));
        return bloc;
      },
      act: (bloc) => bloc.add(SearchProducts('')),
      expect: () => [
        isA<ProductListLoading>(),
        isA<ProductListLoaded>().having(
          (state) => state.allProducts,
          'all products',
          testProducts,
        ),
        isA<ProductListLoading>(),
        isA<ProductListLoaded>().having(
          (state) => state.filteredProducts,
          'all products after empty search',
          testProducts,
        ),
      ],
    );

    blocTest<ProductListBloc, ProductListState>(
      'combines filters correctly',
      build: () {
        when(mockRepository.getProducts())
            .thenAnswer((_) async => Right(testProducts));
        when(mockRepository.filterByCategory('Category X'))
            .thenAnswer((_) async => Right(testProducts.where((p) => p.category == 'Category X').toList()));
        when(mockRepository.filterByBrand('Brand A'))
            .thenAnswer((_) async => Right(testProducts.where((p) => p.brand == 'Brand A').toList()));
        return bloc;
      },
      act: (bloc) {
        bloc.add(FilterByCategory('Category X'));
        bloc.add(FilterByBrand('Brand A'));
      },
      expect: () => [
        isA<ProductListLoading>(),
        isA<ProductListLoaded>().having(
          (state) => state.allProducts,
          'all products',
          testProducts,
        ),
        isA<ProductListLoading>(),
        isA<ProductListLoaded>().having(
          (state) => state.filteredProducts,
          'category filtered products',
          testProducts.where((p) => p.category == 'Category X').toList(),
        ),
        isA<ProductListLoading>(),
        isA<ProductListLoaded>().having(
          (state) => state.filteredProducts,
          'category and brand filtered products',
          testProducts.where((p) => p.category == 'Category X' && p.brand == 'Brand A').toList(),
        ),
      ],
    );
  });
} 