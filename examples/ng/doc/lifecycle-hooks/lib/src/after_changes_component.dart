import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';

class Hero {
  String name;
  Hero(this.name);
  Map<String, dynamic> toJson() => {'name': name};
}

@Component(
  selector: 'after-changes',
  template: '''
    <div *ngIf="hero != null" class="hero">
      <p>{{hero!.name}} can {{power}}</p>

      <h4>-- Change Log --</h4>
      <div *ngFor="let chg of changeLog">{{chg}}</div>
    </div>
    ''',
  styles: [
    '.hero {background: LightYellow; padding: 8px; margin-top: 8px}',
    'p {background: Yellow; padding: 8px; margin-top: 8px}'
  ],
  directives: [coreDirectives],
)
class AfterChangesComponent implements AfterChanges {
  // #docregion inputs
  @Input()
  Hero? hero;
  @Input()
  String power = '';
  // #enddocregion inputs

  List<String> changeLog = [];

  // #docregion ng-after-changes
  ngAfterChanges() {
    changeLog.add('Input property has changed. ($power)');
  }
  // #enddocregion ng-after-changes

  void reset() {
    changeLog.clear();
  }
}

@Component(
  selector: 'after-changes-parent',
  templateUrl: 'after_changes_parent_component.html',
  styles: ['.parent {background: Lavender}'],
  directives: [coreDirectives, formDirectives, AfterChangesComponent],
)
class AfterChangesParentComponent {
  late Hero hero;
  late String power;
  String title = 'AfterChanges';
  @ViewChild(AfterChangesComponent)
  AfterChangesComponent? childView;

  AfterChangesParentComponent() {
    reset();
  }

  void reset() {
    // new Hero object every time; triggers onChange
    hero = Hero('Windstorm');
    // setting power only triggers onChange if this value is different
    power = 'sing';
    childView?.reset();
  }
}
