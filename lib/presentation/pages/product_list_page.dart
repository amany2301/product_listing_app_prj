import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/product_list/product_list_bloc.dart';
import '../bloc/product_list/product_list_event.dart';
import '../bloc/product_list/product_list_state.dart';
import '../widgets/product_card.dart';
import '../widgets/filter_chip.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              // TODO: Implement theme toggle
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (query) {
                context.read<ProductListBloc>().add(SearchProducts(query));
              },
            ),
          ),
          BlocBuilder<ProductListBloc, ProductListState>(
            builder: (context, state) {
              if (state is ProductListLoaded) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      CustomFilterChip(
                        label: 'All Categories',
                        isSelected: state.selectedCategory == null,
                        onSelected: (selected) {
                          if (selected) {
                            context.read<ProductListBloc>().add(LoadProducts());
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      CustomFilterChip(
                        label: 'Sort by Name',
                        isSelected: state.sortBy == 'name',
                        onSelected: (selected) {
                          if (selected) {
                            context.read<ProductListBloc>().add(SortByName());
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      CustomFilterChip(
                        label: 'Sort by MRP',
                        isSelected: state.sortBy == 'mrp',
                        onSelected: (selected) {
                          if (selected) {
                            context.read<ProductListBloc>().add(SortByMRP());
                          }
                        },
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          Expanded(
            child: BlocBuilder<ProductListBloc, ProductListState>(
              builder: (context, state) {
                if (state is ProductListInitial) {
                  context.read<ProductListBloc>().add(LoadProducts());
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is ProductListLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is ProductListError) {
                  return Center(child: Text(state.message));
                }
                if (state is ProductListLoaded) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      final product = state.products[index];
                      return ProductCard(product: product);
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
} 