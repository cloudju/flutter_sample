import 'package:flutter/material.dart';
import 'package:flutter_samples/utils/CustomNavigator.dart';
import 'package:flutter_samples/view_model/k_means_view_model.dart';
import 'package:flutter_samples/widget/draw_point_widget.dart';
import 'package:provider/provider.dart';

class KMeansPage extends StatelessWidget {
  late final double _height;
  late final double _width;
  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height -
        kToolbarHeight -
        MediaQuery.of(context).padding.vertical;
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        top: false,
        child: Center(
          child: Consumer<KMeansViewModel>(
            builder: _body,
          ),
        ),
      ),
    );
  }

  Widget _body(BuildContext context, KMeansViewModel viewModel, Widget? child) {
    return Column(
      children: [
        DrawPointWidget(
          size: Size(_width, _height * 0.9),
          drawOnly: false,
          onPointsUpdate: (points) {
            print(points.length);
          },
        ),
        Container(
          height: _height * 0.1,
        ),
      ],
    );
  }

  static void gotoPage(BuildContext context) {
    CustomNavigator().push(
      context: context,
      nextPage: KMeansPage(),
      viewModelBuilder: (_) => KMeansViewModel(),
    );
  }
}
