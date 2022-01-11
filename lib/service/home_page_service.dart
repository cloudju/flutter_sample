import 'package:flutter/material.dart';
import 'package:flutter_samples/service/service.dart';
import 'package:flutter_samples/utils/CustomNavigator.dart';
import 'package:flutter_samples/view/3d_animation_page.dart';
import 'package:flutter_samples/view/animation_samples_page.dart';
import 'package:flutter_samples/view/empty_page.dart';
import 'package:flutter_samples/view/ios_native_page.dart';
import 'package:flutter_samples/view/k_means_page.dart';
import 'package:flutter_samples/view/k_means_plus_page.dart';
import 'package:flutter_samples/view_model/3d_animation_view_model.dart';
import 'package:flutter_samples/view_model/animation_samples_view_model.dart';
import 'package:flutter_samples/view_model/empty_page_view_model.dart';
import 'package:flutter_samples/view_model/ios_native_page_view_model.dart';

class HomePageService extends Service {
  final Map<String, void Function(BuildContext)> menu = {
    '横向入场': (context) {
      CustomNavigator().push(
        context: context,
        nextPage: EmptyPage(),
        viewModelBuilder: (_) => EmptyPageViewModel(),
      );
    },
    'ios native': (context) {
      CustomNavigator().push(
        context: context,
        nextPage: IosNativePage(),
        viewModelBuilder: (_) => IosNativePageViewModel(),
      );
    },
    '动画演示': (context) {
      CustomNavigator().push(
        context: context,
        nextPage: AnimationSamplesPage(),
        viewModelBuilder: (_) => AnimationSamplesViewModel(),
      );
    },
    '3D动画演示': (context) {
      CustomNavigator().push(
        context: context,
        nextPage: Animation3dPage(),
        viewModelBuilder: (_) => Animation3dViewModel(),
      );
    },
    'K-means': KMeansPage.gotoPage,
    'K-means++': KMeansPlusPage.gotoPage,
  };
}
