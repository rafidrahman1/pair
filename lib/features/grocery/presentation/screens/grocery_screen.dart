import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pair/core/theme/app_theme.dart';
import 'package:pair/features/grocery/domain/entities/grocery_item_entity.dart';
import 'package:pair/features/grocery/presentation/providers/grocery_providers.dart';

class GroceryScreen extends ConsumerStatefulWidget {
  const GroceryScreen({super.key});

  @override
  ConsumerState<GroceryScreen> createState() => _GroceryScreenState();
}

class _GroceryScreenState extends ConsumerState<GroceryScreen> {
  final _itemController = TextEditingController();

  @override
  void dispose() {
    _itemController.dispose();
    super.dispose();
  }

  void _addItem() {
    final text = _itemController.text;
    if (text.trim().isEmpty) return;
    ref.read(groceryControllerProvider.notifier).addItem(text);
    _itemController.clear();
  }

  Future<void> _confirmClearChecked(int checkedCount) async {
    if (checkedCount == 0) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear checked items?'),
        content: Text(
          'Remove $checkedCount checked ${checkedCount == 1 ? 'item' : 'items'} from the list?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      ref.read(groceryControllerProvider.notifier).clearCheckedItems();
    }
  }

  @override
  Widget build(BuildContext context) {
    final itemsState = ref.watch(groceryControllerProvider);
    final items = itemsState.valueOrNull ?? [];
    final uncheckedCount = items.where((item) => !item.isChecked).length;
    final checkedCount = items.length - uncheckedCount;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text('Grocery List'),
            if (items.isNotEmpty)
              Text(
                '$uncheckedCount to buy',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.secondary,
                    ),
              ),
          ],
        ),
        actions: [
          if (checkedCount > 0)
            IconButton(
              tooltip: 'Clear checked items',
              onPressed: () => _confirmClearChecked(checkedCount),
              icon: const Icon(Icons.delete_sweep_outlined),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: itemsState.when(
              data: (items) {
                if (items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 64,
                          color: AppColors.primary.withValues(alpha: 0.4),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Your grocery list is empty',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add items you need to buy together',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return _GroceryItemTile(
                      item: item,
                      onToggle: () => ref
                          .read(groceryControllerProvider.notifier)
                          .toggleItem(item),
                      onDelete: () => ref
                          .read(groceryControllerProvider.notifier)
                          .deleteItem(item),
                    );
                  },
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text(error.toString())),
            ),
          ),
          _GroceryInput(
            controller: _itemController,
            onAdd: _addItem,
          ),
        ],
      ),
    );
  }
}

class _GroceryItemTile extends StatelessWidget {
  const _GroceryItemTile({
    required this.item,
    required this.onToggle,
    required this.onDelete,
  });

  final GroceryItemEntity item;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Theme.of(context).colorScheme.error,
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: CheckboxListTile(
        value: item.isChecked,
        onChanged: item.isPending ? null : (_) => onToggle(),
        activeColor: AppColors.primary,
        title: Text(
          item.text,
          style: TextStyle(
            decoration: item.isChecked ? TextDecoration.lineThrough : null,
            color: item.isChecked
                ? Theme.of(context).colorScheme.onSurfaceVariant
                : null,
          ),
        ),
        subtitle: item.isPending
            ? Text(
                'Adding...',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.secondary,
                      fontStyle: FontStyle.italic,
                    ),
              )
            : null,
        secondary: item.isPending
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : null,
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }
}

class _GroceryInput extends StatelessWidget {
  const _GroceryInput({
    required this.controller,
    required this.onAdd,
  });

  final TextEditingController controller;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'Add grocery item...',
                ),
                onSubmitted: (_) => onAdd(),
              ),
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
