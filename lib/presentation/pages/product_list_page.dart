import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/product_list/product_list_bloc.dart';
import '../bloc/product_list/product_list_event.dart';
import '../bloc/product_list/product_list_state.dart';
import '../bloc/theme/theme_bloc.dart';
import '../widgets/product_card.dart';
import '../widgets/filter_chip.dart';
import '../widgets/filter_dropdown.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              context.read<ThemeBloc>().add(ToggleTheme());
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
                final allCategories = state.allProducts
                    .map((p) => p.category)
                    .toSet()
                    .toList()
                  ..sort();
                final allBrands = state.allProducts
                    .map((p) => p.brand)
                    .toSet()
                    .toList()
                  ..sort();

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: FilterDropdown(
                          label: 'Category',
                          items: allCategories,
                          selectedValue: state.selectedCategory,
                          onChanged: (value) {
                            if (value == null) {
                              context.read<ProductListBloc>().add(LoadProducts());
                            } else {
                              context
                                  .read<ProductListBloc>()
                                  .add(FilterByCategory(value));
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilterDropdown(
                          label: 'Brand',
                          items: allBrands,
                          selectedValue: state.selectedBrand,
                          onChanged: (value) {
                            if (value == null) {
                              context.read<ProductListBloc>().add(LoadProducts());
                            } else {
                              context
                                  .read<ProductListBloc>()
                                  .add(FilterByBrand(value));
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(height: 8),
          BlocBuilder<ProductListBloc, ProductListState>(
            builder: (context, state) {
              if (state is ProductListLoaded) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
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
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<ProductListBloc>().add(LoadProducts());
                    },
                    child: GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.45,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: state.filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = state.filteredProducts[index];
                        return ProductCard(product: product);
                      },
                    ),
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