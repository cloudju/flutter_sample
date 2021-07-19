import 'package:flutter/material.dart';
import 'package:flutter_samples/view_model/view_model.dart';
import 'package:provider/provider.dart';

typedef ValueBuilder<T> = T Function(BuildContext context);

class SimpleNavigator<T extends ViewModel> {
  SimpleNavigator({
    required this.pageName,
    required this.page,
    required this.viewModelBuilder,
  });

  final String pageName;
  final Widget page;
  final ValueBuilder<T> viewModelBuilder;
}

class CustomNavigator {
  Future<void> push<T extends ViewModel>({
    required BuildContext context,
    required Widget nextPage,
    required ValueBuilder<T> viewModelBuilder,
  }) async {
    Navigator.of(context).push(
      _createRoute(
        ChangeNotifierProvider<T>(
          create: viewModelBuilder,
          child: nextPage,
        ),
      ),
    );
  }

  Route _createRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: Duration(seconds: 3),
      reverseTransitionDuration: Duration(seconds: 5),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
