import 'package:flutter/material.dart';
import 'package:flutter_samples/utils/CustomNavigator.dart';
import 'package:flutter_samples/view_model/k_means_plus_view_model.dart';
import 'package:flutter_samples/widget/draw_point_widget.dart';
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
    return Column(
      children: [
        Stack(
          children: [
            DrawPointWidget(
              size: Size(_width, _height * 0.9),
              drawOnly: false,
              onPointsUpdate: (points) {
                viewModel.points = points;
              },
            ),
          ],
        ),
      ],
    );
  }

  static void gotoPage(BuildContext context) {
    CustomNavigator().push(
      context: context,
      nextPage: KMeansPlusPage(),
      viewModelBuilder: (_) => KMeansPlusViewModel(),
    );
  }
}
