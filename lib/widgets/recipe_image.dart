import 'package:flutter/material.dart';

class RecipeImage extends StatelessWidget{
    const RecipeImage({super.key, required this.url, this.cacheWidth});
    final String url;
    final int? cacheWidth;

    @override
    Widget build(BuildContext context){
        return Image.network(
            url, 
            fit: BoxFit.cover,
            cacheWidth: cacheWidth,
            loadingBuilder: (context, child, loadingProgress) {
                if(loadingProgress == null) return child;
                return ColoredBox(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: const Center(child: Icon(Icons.restaurant_menu)),
                );
            },
            errorBuilder: (context, error, stackTrace) {
                return Image.asset('assets/images/placeholder.png', fit: BoxFit.cover);
            }
        );
    }
}