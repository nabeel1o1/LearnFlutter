import 'package:flutteroid_app/meals_app/data/dummy_data.dart';
import 'package:riverpod/riverpod.dart';

final mealsProvider = Provider((_createRef) {
  return dummyMeals;
});
