import 'package:flutter/material.dart';
import 'package:flutter_samples/utils/CustomNavigator.dart';
import 'package:flutter_samples/view_model/k_means_view_model.dart';
import 'package:flutter_samples/widget/draw_point_widget.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class KMeansPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height -
        kToolbarHeight -
        MediaQuery.of(context).padding.vertical;
    return Column(
      children: [
        DrawPointWidget(
          size: Size(_width, _height * 0.9),
          drawOnly: false,
          onPointsUpdate: (points) {
            viewModel.points = points;
          },
        ),
        Container(
          child: Row(
            children: [
              Container(
                color: Colors.amber,
                child: TextButton(
                  onPressed: viewModel.run,
                  child: Text('start'),
                ),
              ),
            ],
          ),
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
