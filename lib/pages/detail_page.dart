import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resepku/models/recipe.dart';
import 'package:resepku/providers/favorite_provider.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.recipe});

  final Recipe recipe;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late int _servings;

  @override
  void initState() {
    super.initState();
    _servings = widget.recipe.servings;
  }

  void _addServing() {
    setState(() => _servings++);
  }

  void _removeServing() {
    if (_servings > 1) {
      setState(() => _servings--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;
    final totalCalories = recipe.caloriesPerServing * _servings;
    final isFavorite = context.watch<FavoriteProvider>().isFavorite(recipe);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 260,
            actions: [
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                ),
                onPressed: () =>
                    context.read<FavoriteProvider>().toggle(recipe),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Builder(
                builder: (context) {
                  // Tinggi SliverAppBar saat ini, dibaca dari FlexibleSpaceBar.
                  final settings = context.dependOnInheritedWidgetOfExactType<
                      FlexibleSpaceBarSettings>()!;
                  // 1 = foto terlihat penuh, 0 = foto sudah memudar habis.
                  // Rumus ini mengikuti cara FlexibleSpaceBar memudarkan foto.
                  final imageOpacity =
                      ((settings.currentExtent - settings.minExtent) /
                              (kToolbarHeight * 2))
                          .clamp(0.0, 1.0);
                  return Text(
                    recipe.name,
                    style: TextStyle(
                      // Putih di atas foto, kembali ke warna tema saat foto hilang.
                      color: Color.lerp(
                        Theme.of(context).colorScheme.onSurface,
                        Colors.white,
                        imageOpacity,
                      ),
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(
                            alpha: 0.6 * imageOpacity,
                          ),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  );
                },
              ),
              background: CachedNetworkImage(
                imageUrl: recipe.image,
                fit: BoxFit.cover,
                placeholder: (context, url) => ColoredBox(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: const Center(child: Icon(Icons.restaurant_menu)),
                ),
                errorWidget: (context, url, error) => Image.asset(
                  'assets/images/placeholder.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${recipe.cuisine} • ${recipe.difficulty} • ${recipe.totalTimeMinutes} menit',
                    style: textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Text('Porsi', style: textTheme.titleMedium),
                          const Spacer(),
                          IconButton.filledTonal(
                            onPressed: _servings > 1 ? _removeServing : null,
                            icon: const Icon(Icons.remove),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              '$_servings',
                              style: textTheme.titleLarge,
                            ),
                          ),
                          IconButton.filledTonal(
                            onPressed: _addServing,
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Total kalori: $totalCalories kkal',
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(height: 24),
                  Text('Bahan', style: textTheme.titleLarge),
                ],
              ),
            ),
          ),
          SliverList.builder(
            itemCount: recipe.ingredients.length,
            itemBuilder: (context, index) {
              final item = recipe.ingredients[index];
              return ListTile(
                dense: true,
                leading: const Icon(Icons.check_circle_outline),
                title: Text(item),
              );
            },
          ),
        ],
      ),
    );
  }
}