import 'package:flutter/material.dart';
import 'package:flutter_samples/utils/CustomNavigator.dart';
import 'package:flutter_samples/utils/k_means_albe.dart';
import 'package:flutter_samples/view_model/k_means_plus_view_model.dart';
import 'package:flutter_samples/view_model/view_model.dart';
import 'package:flutter_samples/widget/draw_point_widget.dart';
import 'package:flutter_samples/widget/draw_widget.dart';
import 'package:provider/provider.dart';

class KMeansPlusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: Consumer<KMeansPlusViewModel>(
            builder: _body,
          ),
        ),
      ),
    );
  }

  Widget _body(
    BuildContext context,
    KMeansPlusViewModel viewModel,
    Widget? child,
  ) {
    final _width = MediaQuery.of(context).size.width;
    final _height =
        MediaQuery.of(context).size.height - kToolbarHeight - kTextTabBarHeight;
    switch (viewModel.status) {
      case KmeansPlusStatus.input:
        return inpute(viewModel, Size(_width, _height));
      case KmeansPlusStatus.result:
        return DrawWidget(
          origin: Offset.zero,
          points: viewModel.points
              .map(
                (e) => KMeansItem(
                  e.dx,
                  e.dy,
                  color: Colors.red,
                  sharp: Sharp.rect,
                ),
              )
              .toList(),
          size: Size(_width, _height),
        );
    }
  }

  Widget inpute(KMeansPlusViewModel vm, Size size) => Column(
        children: [
          DrawPointWidget(
            size: Size(size.width, size.height * 0.9),
            drawOnly: false,
            onPointsUpdate: (points) {
              vm.points = points;
            },
          ),
          TextButton(
            onPressed: vm.caculate,
            child: Text('计算'),
          ),
        ],
      );

  static void gotoPage(BuildContext context) {
    CustomNavigator().push(
      context: context,
      nextPage: KMeansPlusPage(),
      viewModelBuilder: (_) => KMeansPlusViewModel(),
    );
  }
}
