import 'package:angular/angular.dart';

import 'hero.dart';
import 'mock_heroes.dart';

class HeroService {
  List<Hero> getAll() => mockHeroes;
}
