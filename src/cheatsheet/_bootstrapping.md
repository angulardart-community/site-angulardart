<?code-excerpt path-base="examples/ng/doc"?>

<div id="runApp" class="md-table table table-striped" markdown="1">

{:.md-thead}
- Bootstrapping

- {% prettify dart tag="code" %}
    import 'package:angular/angular.dart';
  {% endprettify %}

<hr>

- 
  {% prettify dart tag="code+br" %}
    import 'package:angular_app/app_component.template.dart' as ng;
    void main() {
      [!runApp!](ng.AppComponentNgFactory);
    }
  {% endprettify %}

- Launch the app, using `AppComponent` as the root component.

  See: [Architecture Overview](/guide/architecture),
  [Dependency Injection](/guide/dependency-injection)

<hr>

- 
  {% prettify dart tag="code+br" %}
    import 'package:angular_router/angular_router.dart';
    import 'package:angular_tour_of_heroes/app_component.template.dart' as ng;

    import 'main.template.dart' as self;

    [!@GenerateInjector!](
      routerProviders,
    )
    final InjectorFactory injector = self.injector$Injector;

    void main() {
      runApp(ng.AppComponentNgFactory, [!createInjector!]: injector);
    }
  {% endprettify %}

- Launch the app, using a compile-time generated root injector.

  See: [Architecture Overview](/guide/architecture),
  [Dependency Injection](/guide/dependency-injection)

</div>
