// #docregion lc-imports
import 'package:angular/angular.dart';

import 'logger_service.dart';

int _nextId = 1;

// #docregion ngOnInit
class PeekABoo implements OnInit {
  final LoggerService _logger;

  PeekABoo(this._logger);

  // implement OnInit's `ngOnInit` method
  void ngOnInit() {
    _logIt('OnInit');
  }

  void _logIt(String msg) {
    // Don't tick or else
    // the AfterContentChecked and AfterViewChecked recurse.
    // Let parent call tick()
    _logger.log("#${_nextId++} $msg");
  }
}
// #enddocregion ngOnInit

@Component(
    selector: 'peek-a-boo',
    template: '<p>Now you see my hero, {{name}}</p>',
    styles: ['p {background: LightYellow; padding: 8px}'])
// Don't HAVE to mention the Lifecycle Hook interfaces
// unless we want typing and tool support.
class PeekABooComponent extends PeekABoo
    implements
        AfterChanges,
        OnInit,
        DoCheck,
        AfterContentInit,
        AfterContentChecked,
        AfterViewInit,
        AfterViewChecked,
        OnDestroy {
  @Input()
  String? name;

  int _afterContentCheckedCounter = 1;
  int _afterViewCheckedCounter = 1;
  int _afterChangesCounter = 1;

  PeekABooComponent(LoggerService logger) : super(logger) {
    var _is = name != null ? 'is' : 'is not';
    _logIt('name $_is known at construction');
  }

  // Only called if there is an @input variable set by parent.
  void ngAfterChanges() {
    _logIt('AfterChanges (${_afterChangesCounter++})');
  }

  // Beware! Called frequently!
  // Called in every change detection cycle anywhere on the page
  void ngDoCheck() => _logIt('DoCheck');

  void ngAfterContentInit() => _logIt('AfterContentInit');

  // Beware! Called frequently!
  // Called in every change detection cycle anywhere on the page
  void ngAfterContentChecked() {
    _logIt('AfterContentChecked (${_afterContentCheckedCounter++})');
  }

  void ngAfterViewInit() => _logIt('AfterViewInit');

  // Beware! Called frequently!
  // Called in every change detection cycle anywhere on the page
  void ngAfterViewChecked() {
    _logIt('AfterViewChecked (${_afterViewCheckedCounter++})');
  }

  void ngOnDestroy() => _logIt('OnDestroy');
}
