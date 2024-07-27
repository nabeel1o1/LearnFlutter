import 'package:flutteroid_app/meals_app/models/meal.dart';
import 'package:riverpod/riverpod.dart';

class FavoritesMealsNotifier extends StateNotifier<List<Meal>> {
  FavoritesMealsNotifier() : super([]);

  String toggleMealFavoriteStatus(Meal meal) {
    final isMealFavorite = state.contains(meal);

    if (isMealFavorite) {
      state = state.where((thisMeal) => thisMeal.id != meal.id).toList();
      return 'Meal removed as a favorite';
    } else {
      state = [...state, meal];
      return 'Meal add as a favorite';
    }
  }
}

final favoriteMealsProvider =
    StateNotifierProvider<FavoritesMealsNotifier, List<Meal>>((_createFn) {
  return FavoritesMealsNotifier();
});
