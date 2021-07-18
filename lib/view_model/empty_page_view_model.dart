import 'package:flutter_samples/view_model/view_model.dart';

class EmptyPageViewModel extends ViewModel {
  int count = 0;
  void onClick() {
    count++;
    notifyListeners();
  }
}
