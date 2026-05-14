import 'package:flutter/foundation.dart';

class DashboardProvider extends ChangeNotifier {
  // Stack of tab indices — supports back navigation between tabs.
  final List<int> _history = [0];

  int get currentIndex => _history.last;

  // Returns true if there is a previous tab to go back to.
  bool get canPopTab => _history.length > 1;

  void setIndex(int index) {
    if (_history.last == index) return;
    _history.add(index);
    notifyListeners();
  }

  // Pops the current tab and returns to the previous one.
  // Returns true if a pop happened, false if already at root tab.
  bool popTab() {
    if (_history.length <= 1) return false;
    _history.removeLast();
    notifyListeners();
    return true;
  }
}
