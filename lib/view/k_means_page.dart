import 'package:flutter/material.dart';
import 'package:flutter_samples/utils/CustomNavigator.dart';
import 'package:flutter_samples/view_model/k_means_view_model.dart';
import 'package:flutter_samples/widget/draw_point_widget.dart';
import 'package:provider/provider.dart';

class KMeansPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Consumer<KMeansViewModel>(
          builder: (context, viewModel, child) => DrawPointWidget(
            drawOnly: false,
            onPointsUpdate: (points) {
              print(points.length);
            },
          ),
        ),
      ),
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
