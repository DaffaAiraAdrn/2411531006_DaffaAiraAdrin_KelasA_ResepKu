import 'package:flutter/foundation.dart';
import 'package:resepku/models/recipe.dart';

class FavoriteProvider extends ChangeNotifier {
    final List<Recipe> _items = [];
    
    List<Recipe> get items => List.unmodifiable(_items);
    int get count => _items.length;


    bool isFavorite(Recipe recipe) => _items.any((r) => r.id == recipe.id);

    void toggle(Recipe recipe){
        if(isFavorite(recipe)) {
            _items.removeWhere((r) => r.id == recipe.id);
        }else{
            _items.add(recipe);
        }
        notifyListeners();
    }

    void clear(){
        _items.clear();
        notifyListeners();
    }
}