import 'package:flutter/material.dart';
import 'package:flutteroid_app/meals_app/data/dummy_data.dart';
import 'package:flutteroid_app/meals_app/models/Category.dart';
import 'package:flutteroid_app/meals_app/models/meal.dart';
import 'package:flutteroid_app/meals_app/screens/meals_screen.dart';
import 'package:flutteroid_app/meals_app/widgets/category_grid_item.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({required this.filteredMeals, super.key});

  final List<Meal> filteredMeals;

  void _selectCategory(BuildContext context, Category category) {
    print('Filtered Meal : ${this.filteredMeals}');
    final filteredMeals = this.filteredMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(
          title: category.title,
          meals: filteredMeals,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children: [
          ...availableCategories.map(
            (category) => CategoryGridItem(
              category: category,
              onSelectCategory: () {
                _selectCategory(context, category);
              },
            ),
          )
          // for(final category in availableCategories)
          //   CategoryGridItem(category: category)
        ],
    );
  }
}
