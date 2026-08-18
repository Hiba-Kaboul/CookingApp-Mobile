// presentation/pages/shopping_list_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project2/core/constants/app_colors.dart';

import '../../data/api/shopping_list_api.dart';
import '../../data/api/mark_purchased_api.dart';
import '../../data/api/mark_unpurchased_api.dart';
import '../../data/api/delete_shopping_items_api.dart';

import '../bloc/bloc_shopping_list/shopping_list_bloc.dart';
import '../bloc/bloc_shopping_list/shopping_list_event.dart';
import '../bloc/bloc_shopping_list/shopping_list_state.dart';

import '../bloc/bloc_mark_purchased/mark_purchased_bloc.dart';
import '../bloc/bloc_mark_purchased/mark_purchased_event.dart';
import '../bloc/bloc_mark_purchased/mark_purchased_state.dart';

import '../bloc/bloc_mark_unpurchased/mark_unpurchased_bloc.dart';
import '../bloc/bloc_mark_unpurchased/mark_unpurchased_event.dart';
import '../bloc/bloc_mark_unpurchased/mark_unpurchased_state.dart';

import '../bloc/bloc_delete_shopping_items/delete_shopping_items_bloc.dart';
import '../bloc/bloc_delete_shopping_items/delete_shopping_items_event.dart';
import '../bloc/bloc_delete_shopping_items/delete_shopping_items_state.dart';

import '../widgets/shopping_bottom_widgets.dart';
import '../widgets/shopping_list_widgets.dart';

class ShoppingListPage extends StatelessWidget {
  const ShoppingListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ShoppingListBloc(ShoppingListApi())
            ..add(GetShoppingListEvent()),
        ),
        BlocProvider(
          create: (_) => MarkPurchasedBloc(MarkPurchasedApi()),
        ),
        BlocProvider(
          create: (_) => MarkUnpurchasedBloc(MarkUnpurchasedApi()),
        ),
        BlocProvider(
          create: (_) => DeleteShoppingItemsBloc(DeleteShoppingItemsApi()),
        ),
      ],
      child: const _ShoppingListView(),
    );
  }
}

class _ShoppingListView extends StatefulWidget {
  const _ShoppingListView();

  @override
  State<_ShoppingListView> createState() => _ShoppingListViewState();
}

class _ShoppingListViewState extends State<_ShoppingListView> {
  final Set<int> _selectedIds = {};

  void _toggleSelection(int id, bool? value) {
    setState(() {
      if (value == true) {
        _selectedIds.add(id);
      } else {
        _selectedIds.remove(id);
      }
    });
  }

  void _toggleSelectAll(bool? value, List items) {
    setState(() {
      if (value == true) {
        _selectedIds
          ..clear()
          ..addAll(items.map((e) => e.id as int));
      } else {
        _selectedIds.clear();
      }
    });
  }

  void _clearSelection() {
    setState(() => _selectedIds.clear());
  }

  void _refreshList(BuildContext context) {
    context.read<ShoppingListBloc>().add(GetShoppingListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: MultiBlocListener(
        listeners: [
          BlocListener<MarkPurchasedBloc, MarkPurchasedState>(
            listener: (context, state) {
              if (state is MarkPurchasedSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.green,
                      content:
                          Text("تم تحديد ${state.updatedCount} عنصر كمشترى")),
                );
                _clearSelection();
                _refreshList(context);
              }
              if (state is MarkPurchasedFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
          ),
          BlocListener<MarkUnpurchasedBloc, MarkUnpurchasedState>(
            listener: (context, state) {
              if (state is MarkUnpurchasedSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.blueGrey,
                      content: Text(
                          "تم تحديد ${state.updatedCount} عنصر كغير مشترى")),
                );
                _clearSelection();
                _refreshList(context);
              }
              if (state is MarkUnpurchasedFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
          ),
          BlocListener<DeleteShoppingItemsBloc, DeleteShoppingItemsState>(
            listener: (context, state) {
              if (state is DeleteShoppingItemsSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("تم الحذف")),
                );
                _clearSelection();
                _refreshList(context);
              }
              if (state is DeleteShoppingItemsFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
          ),
        ],
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: const ShoppingAppBarWidget(),
          body: SafeArea(
            child: BlocBuilder<ShoppingListBloc, ShoppingListState>(
              builder: (context, state) {
                if (state is ShoppingListLoading) {
                  return const Center(
                    child:
                        CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                if (state is ShoppingListError) {
                  return Center(child: Text(state.message));
                }

                if (state is ShoppingListEmpty) {
                  return _buildEmptyState();
                }

                if (state is ShoppingListLoaded) {
                  final items = state.items;
                  final allSelected = items.isNotEmpty &&
                      items.every((e) => _selectedIds.contains(e.id));

                  return Column(
                    children: [
                      // 👇 شريط الإجراءات ظاهر دايماً
                      ShoppingActionsBarWidget(
                        totalCount: items.length,
                        selectedCount: _selectedIds.length,
                        allSelected: allSelected,
                        onSelectAll: (value) =>
                            _toggleSelectAll(value, items),
                        onMarkPurchased: () {
                          context.read<MarkPurchasedBloc>().add(
                                MarkItemsAsPurchased(_selectedIds.toList()),
                              );
                        },
                        onMarkUnpurchased: () {
                          context.read<MarkUnpurchasedBloc>().add(
                                MarkItemsAsUnpurchased(
                                    _selectedIds.toList()),
                              );
                        },
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          padding:
                              const EdgeInsets.fromLTRB(16, 8, 16, 24),
                          child: _buildListCard(items),
                        ),
                      ),
                    ],
                  );
                }

                return const SizedBox();
              },
            ),
          ),
          bottomNavigationBar: CheckoutButtonWidget(onPressed: () {
            if (_selectedIds.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("حددي عناصر أولاً")),
              );
              return;
            }
            context
                .read<MarkPurchasedBloc>()
                .add(MarkItemsAsPurchased(_selectedIds.toList()));
          }),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.otpCardBackground,
            ),
            child: const Icon(Icons.shopping_basket_outlined,
                size: 40, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          const Text(
            "قائمة التسوق فاضية",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "أضيفي مكونات من الوصفات لتظهر هون",
            style: TextStyle(fontSize: 13, color: AppColors.hintText),
          ),
        ],
      ),
    );
  }

  Widget _buildListCard(List items) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.ResetPasswordTextField,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.inputBorder.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShoppingListHeaderImageWidget(
            imageUrl:
                'assets/images/Image Header_margin.png',
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: items.map((item) {
                return ShoppingItemTileWidget(
                  name: item.name,
                  isPurchased: item.isPurchased,
                  isSelected: _selectedIds.contains(item.id),
                  onSelectChanged: (value) =>
                      _toggleSelection(item.id, value),
                  onDelete: () {
                    context.read<DeleteShoppingItemsBloc>().add(
                          DeleteSelectedShoppingItems([item.id]),
                        );
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}