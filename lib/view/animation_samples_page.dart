import 'package:flutter/material.dart';
import 'package:flutter_samples/view_model/animation_samples_view_model.dart';
import 'package:provider/provider.dart';

class AnimationSamplesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Consumer<AnimationSamplesViewModel>(
          builder: (context, viewModel, child) => Column(
            children: viewModel.animations,
          ),
        ),
      ),
    );
  }
}
