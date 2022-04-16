import 'package:angular/angular.dart';

import 'logger_service.dart';
import 'spy_directive.dart';

@Component(
  selector: 'my-counter',
  template: '''
    <div class="counter">
      Counter={{counter}}

      <h5>-- Counter Change Log --</h5>
      <div *ngFor="let chg of changeLog" mySpy>{{chg}}</div>
    </div>
    ''',
  styles: ['.counter {background: LightYellow; padding: 8px; margin-top: 8px}'],
  directives: [coreDirectives, SpyDirective],
)
class MyCounterComponent implements AfterChanges {
  @Input()
  num counter = 0;
  List<String> changeLog = [];

  ngAfterChanges() {
    // Empty the changeLog whenever counter goes to zero
    // hint: this is a way to respond programmatically to external value changes.
    if (this.counter == 0) {
      changeLog.clear();
    }

    // A change to `counter` is the only change we can get.
    changeLog.add('counter changed to $counter');
  }
}

@Component(
  selector: 'counter-parent',
  template: '''
    <div class="parent">
      <h2>Counter Spy</h2>

      <button (click)="updateCounter()">Update counter</button>
      <button (click)="reset()">Reset Counter</button>

      <my-counter [counter]="value"></my-counter>

      <h4>-- Spy Lifecycle Hook Log --</h4>
      <div *ngFor="let msg of logs">{{msg}}</div>
    </div>
    ''',
  styles: ['.parent {background: gold;}'],
  directives: [coreDirectives, MyCounterComponent],
  providers: [ClassProvider(LoggerService)],
)
class CounterParentComponent {
  final LoggerService _logger;
  num value = 0;

  CounterParentComponent(this._logger) {
    reset();
  }

  List<String> get logs => _logger.logs;

  void updateCounter() {
    value += 1;
    _logger.tick();
  }

  void reset() {
    _logger.log('-- reset --');
    value = 0;
    _logger.tick();
  }
}
