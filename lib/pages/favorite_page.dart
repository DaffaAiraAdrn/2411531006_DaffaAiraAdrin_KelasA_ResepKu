import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resepku/pages/detail_page.dart';
import 'package:resepku/providers/favorite_provider.dart';
import 'package:resepku/widgets/recipe_image.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  Future<void> _confirmClearAll(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Semua Favorit?'),
        content: const Text(
          'Apakah Anda yakin ingin menghapus semua resep dari daftar favorit?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<FavoriteProvider>().clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasFavorites = context.watch<FavoriteProvider>().count > 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorit Saya'),
        actions: [
          TextButton.icon(
            onPressed: hasFavorites ? () => _confirmClearAll(context) : null,
            icon: const Icon(Icons.delete_sweep),
            label: const Text('Hapus semua'),
          ),
        ],
      ),
      body: Consumer<FavoriteProvider>(
        builder: (context, favorite, child) {
          if (favorite.count == 0) {
            return const Center(
              child: Text(
                'Belum ada resep favorit.\nTekan ikon hati di daftar resep.',
                textAlign: TextAlign.center,
              ),
            );
          }
          return ListView.separated(
            itemCount: favorite.items.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final recipe = favorite.items[index];
              return Dismissible(
                key: ValueKey(recipe.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  favorite.toggle(recipe);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${recipe.name} dihapus dari favorit'),
                    ),
                  );
                },
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 56,
                      height: 56,
                      child: RecipeImage(url: recipe.image, cacheWidth: 168),
                    ),
                  ),
                  title: Text(recipe.name),
                  subtitle: Text(recipe.cuisine),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      favorite.toggle(recipe);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${recipe.name} dihapus dari favorit'),
                        ),
                      );
                    },
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(recipe: recipe),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
