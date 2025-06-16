import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:product_listing_app_prj/data/models/product_model.dart';
import 'package:product_listing_app_prj/data/repositories/product_repository_impl.dart';
import 'package:product_listing_app_prj/domain/entities/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference<Map<String, dynamic>>,
  QuerySnapshot<Map<String, dynamic>>,
  QueryDocumentSnapshot<Map<String, dynamic>>,
])

import 'product_repository_impl_test.mocks.dart';

void main() {
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference<Map<String, dynamic>> mockCollection;
  late ProductRepositoryImpl repository;

  final testProducts = [
    ProductModel(
      id: 1,
      name: 'Test Product 1',
      brand: 'Brand A',
      category: 'Category X',
      mrp: 100.0,
      sellingRate: 80.0,
      imageUrl: 'https://example.com/image1.jpg',
    ),
    ProductModel(
      id: 2,
      name: 'Test Product 2',
      brand: 'Brand B',
      category: 'Category Y',
      mrp: 200.0,
      sellingRate: 150.0,
      imageUrl: 'https://example.com/image2.jpg',
    ),
    ProductModel(
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
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference<Map<String, dynamic>>();
    repository = ProductRepositoryImpl(mockFirestore);

    when(mockFirestore.collection('products')).thenReturn(mockCollection);
  });

  group('ProductRepositoryImpl', () {
    test('getProducts returns list of products', () async {
      final mockSnapshot = MockQuerySnapshot<Map<String, dynamic>>();
      final mockDocs = testProducts.map((product) {
        final mockDoc = MockQueryDocumentSnapshot<Map<String, dynamic>>();
        when(mockDoc.data()).thenReturn(product.toJson());
        when(mockDoc.id).thenReturn(product.id.toString());
        return mockDoc;
      }).toList();

      when(mockSnapshot.docs).thenReturn(mockDocs);
      when(mockCollection.get()).thenAnswer((_) async => mockSnapshot);

      final result = await repository.getProducts();
      expect(result, isA<Right<Exception, List<Product>>>());
      result.fold(
        (l) => fail('Expected Right but got Left'),
        (r) {
          expect(r.length, equals(testProducts.length));
          expect(r.first.name, equals(testProducts.first.name));
        },
      );
    });

    test('getProducts throws exception when Firestore fails', () async {
      when(mockCollection.get()).thenThrow(Exception('Firestore error'));

      final result = await repository.getProducts();
      expect(result, isA<Left<Exception, List<Product>>>());
      result.fold(
        (l) => expect(l, isA<Exception>()),
        (r) => fail('Expected Left but got Right'),
      );
    });

    test('searchProducts returns filtered products', () async {
      final mockSnapshot = MockQuerySnapshot<Map<String, dynamic>>();
      final mockDocs = testProducts.map((product) {
        final mockDoc = MockQueryDocumentSnapshot<Map<String, dynamic>>();
        when(mockDoc.data()).thenReturn(product.toJson());
        when(mockDoc.id).thenReturn(product.id.toString());
        return mockDoc;
      }).toList();

      when(mockSnapshot.docs).thenReturn(mockDocs);
      when(mockCollection.get()).thenAnswer((_) async => mockSnapshot);

      final result = await repository.searchProducts('Test');
      expect(result, isA<Right<Exception, List<Product>>>());
      result.fold(
        (l) => fail('Expected Right but got Left'),
        (r) {
          expect(r.length, equals(2)); // Only products with 'Test' in name
          expect(r.every((p) => p.name.contains('Test')), isTrue);
        },
      );
    });

    test('searchProducts returns all products for empty query', () async {
      final mockSnapshot = MockQuerySnapshot<Map<String, dynamic>>();
      final mockDocs = testProducts.map((product) {
        final mockDoc = MockQueryDocumentSnapshot<Map<String, dynamic>>();
        when(mockDoc.data()).thenReturn(product.toJson());
        when(mockDoc.id).thenReturn(product.id.toString());
        return mockDoc;
      }).toList();

      when(mockSnapshot.docs).thenReturn(mockDocs);
      when(mockCollection.get()).thenAnswer((_) async => mockSnapshot);

      final result = await repository.searchProducts('');
      expect(result, isA<Right<Exception, List<Product>>>());
      result.fold(
        (l) => fail('Expected Right but got Left'),
        (r) {
          expect(r.length, equals(testProducts.length));
        },
      );
    });

    test('searchProducts is case insensitive', () async {
      final mockSnapshot = MockQuerySnapshot<Map<String, dynamic>>();
      final mockDocs = testProducts.map((product) {
        final mockDoc = MockQueryDocumentSnapshot<Map<String, dynamic>>();
        when(mockDoc.data()).thenReturn(product.toJson());
        when(mockDoc.id).thenReturn(product.id.toString());
        return mockDoc;
      }).toList();

      when(mockSnapshot.docs).thenReturn(mockDocs);
      when(mockCollection.get()).thenAnswer((_) async => mockSnapshot);

      final result = await repository.searchProducts('test');
      expect(result, isA<Right<Exception, List<Product>>>());
      result.fold(
        (l) => fail('Expected Right but got Left'),
        (r) {
          expect(r.length, equals(2)); // Should match 'Test' products
          expect(r.every((p) => p.name.toLowerCase().contains('test')), isTrue);
        },
      );
    });

    test('searchProducts matches across all fields', () async {
      final mockSnapshot = MockQuerySnapshot<Map<String, dynamic>>();
      final mockDocs = testProducts.map((product) {
        final mockDoc = MockQueryDocumentSnapshot<Map<String, dynamic>>();
        when(mockDoc.data()).thenReturn(product.toJson());
        when(mockDoc.id).thenReturn(product.id.toString());
        return mockDoc;
      }).toList();

      when(mockSnapshot.docs).thenReturn(mockDocs);
      when(mockCollection.get()).thenAnswer((_) async => mockSnapshot);

      final result = await repository.searchProducts('Brand A');
      expect(result, isA<Right<Exception, List<Product>>>());
      result.fold(
        (l) => fail('Expected Right but got Left'),
        (r) {
          expect(r.length, equals(2)); // Products with Brand A
          expect(r.every((p) => p.brand == 'Brand A'), isTrue);
        },
      );
    });
  });
}