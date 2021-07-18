import 'package:flutter/material.dart';
import 'package:flutter_samples/service/service.dart';
import 'package:provider/provider.dart';

abstract class ViewModel extends ChangeNotifier with serviceListener {
  ViewModel({
    List<Service>? services,
  }) {
    _services = services ?? [];
    for (Service s in _services!) {
      s.addServiceListener(this);
    }
  }

  List<Service>? _services;
  List<Service> get services => List<Service>.from(_services ?? []);

  bool _disposed = false;

  @override
  @mustCallSuper
  void dispose() {
    final List<Service> list = services;
    for (Service service in list) {
      service.removeServiceListener(this);
    }
    _services?.clear();

    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (_disposed) {
      return;
    }
    super.notifyListeners();
  }

  static T of<T extends ViewModel>(BuildContext context) {
    return Provider.of<T>(context, listen: false);
  }

  void addServie(Service service) {
    // 如果和findService()对照，会发现此处有个错误（应该检测不能添加相同类型的Serviece）。
    assert(_services != null && !_services!.contains(service));
    if (!_services!.contains(service)) {
      _services!.add(service);
      service.addServiceListener(this);
    }
  }

  void removeServices(Service service) {
    //用到时在写
  }

  T? findService<T extends Service>() {
    for (Service service in _services!) {
      if (service is T) {
        return service;
      }
    }

    return null;
  }

  @override
  Future<void> onServiceEventRaised(dynamic service, dynamic event) async {
    notifyListeners();
  }
}
