import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// abstract class serviceListener {
mixin serviceListener {
  Future<void> onServiceEventRaised(dynamic service, dynamic event);
}

// 业务逻辑类
class Service {
  final List<serviceListener> _listeners = [];

  static T of<T extends Service>(BuildContext context) {
    return Provider.of<T>(context, listen: false);
  }

  Future<void> raiseServiceEvent({dynamic event}) async {
    final List<serviceListener> listeners =
        List<serviceListener>.from(_listeners);
    for (final listener in listeners) {
      if (_listeners.contains(listener)) {
        listener.onServiceEventRaised(this, event);
      }
    }
  }

  void addServiceListener(serviceListener listener) {
    _listeners.add(listener);
  }

  void removeServiceListener(serviceListener listener) {
    assert(_listeners.contains(listener));
    _listeners.remove(listener);
  }

  void clearServiceListener() {
    _listeners.clear();
  }
}
