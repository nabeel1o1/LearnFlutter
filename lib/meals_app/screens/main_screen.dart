import 'package:flutter/material.dart';
import 'package:flutteroid_app/meals_app/data/dummy_data.dart';
import 'package:flutteroid_app/meals_app/models/meal.dart';
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

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Meal> _favoriteMeals = [];

  Map<Filter, bool> _selectedFilters = kDefaultFilters;

  void _onDrawerItemSelect(String item) async {
    Navigator.pop(context);
    if (item == 'filters') {
      final selectedFilters =
          await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => FiltersScreen(filterState: _selectedFilters),
        ),
      );
      setState(() {
        _selectedFilters = selectedFilters ?? kDefaultFilters;
      });
    } else {}
  }

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _toggleMealFavoriteStatus(Meal meal) {
    final isExisting = _favoriteMeals.contains(meal);

    if (isExisting) {
      setState(() {
        _favoriteMeals.remove(meal);
      });
      _showInfoMessage('Meal is no longer a favorite');
    } else {
      setState(() {
        _favoriteMeals.add(meal);
      });
      _showInfoMessage('Marked as a favorite!');
    }
  }

  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredMeals = dummyMeals.where((meal) {
      if (_selectedFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
        false;
      }
      if (_selectedFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
        false;
      }
      if (_selectedFilters[Filter.vegetarian]! && !meal.isVegetarian) {
        false;
      }
      if (_selectedFilters[Filter.vegan]! && !meal.isVegan) {
        false;
      }
      return true;
    }).toList();
    var activePageTitle = 'Categories';

    Widget activePage = CategoriesScreen(
      filteredMeals: filteredMeals,
      onToggleFavorite: _toggleMealFavoriteStatus,
    );
    if (_selectedPageIndex == 1) {
      activePage = MealsScreen(
        meals: _favoriteMeals,
        onToggleFavorite: _toggleMealFavoriteStatus,
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
