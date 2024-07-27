import 'package:flutteroid_app/meals_app/providers/meals_provider.dart';
import 'package:flutteroid_app/meals_app/screens/filters_screen.dart';
import 'package:riverpod/riverpod.dart';

enum Filter { glutenFree, lactoseFree, vegetarian, vegan }

class FiltersNotifier extends StateNotifier<Map<Filter, bool>> {
  FiltersNotifier()
      : super({
          Filter.glutenFree: false,
          Filter.lactoseFree: false,
          Filter.vegetarian: false,
          Filter.vegan: false
        });

  void setFilters(Map<Filter, bool> selectedFilters) {
    state = selectedFilters;
  }

  void setFilter(Filter filter, bool isSet) {
    state = {...state, filter: isSet};
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>((ref) {
  return FiltersNotifier();
});

final filteredMealsProvider = Provider((ref){
  final meal = ref.watch(mealsProvider);
  final selectedFilters = ref.watch(filtersProvider);
  return meal.where((meal) {
    if (selectedFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
      false;
    }
    if (selectedFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
      false;
    }
    if (selectedFilters[Filter.vegetarian]! && !meal.isVegetarian) {
      false;
    }
    if (selectedFilters[Filter.vegan]! && !meal.isVegan) {
      false;
    }
    return true;
  }).toList();
});
