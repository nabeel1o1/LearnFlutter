import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutteroid_app/meals_app/providers/favorites_provider.dart';
import 'package:flutteroid_app/meals_app/providers/filters_provider.dart';
import 'package:flutteroid_app/meals_app/screens/categories_screen.dart';
import 'package:flutteroid_app/meals_app/screens/filters_screen.dart';
import 'package:flutteroid_app/meals_app/screens/meals_screen.dart';
import 'package:flutteroid_app/meals_app/widgets/main_drawer.dart';

const kDefaultFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false
};

class MealsMainScreen extends ConsumerStatefulWidget {
  const MealsMainScreen({super.key});

  @override
  ConsumerState<MealsMainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MealsMainScreen> {

  void _onDrawerItemSelect(String item) {
    Navigator.pop(context);
    if (item == 'filters') {
      Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => const FiltersScreen(),
        ),
      );
    } else {}
  }

  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredMeals = ref.watch(filteredMealsProvider);
    var activePageTitle = 'Categories';

    Widget activePage = CategoriesScreen(
      filteredMeals: filteredMeals,
    );
    if (_selectedPageIndex == 1) {
      final favoriteMeals = ref.watch(favoriteMealsProvider);
      activePage = MealsScreen(
        meals: favoriteMeals,
      );
      activePageTitle = 'Your Favorites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(
        drawerItemSelected: _onDrawerItemSelect,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
