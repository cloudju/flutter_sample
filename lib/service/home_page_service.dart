import 'package:flutter/material.dart';
import 'package:flutter_samples/service/service.dart';
import 'package:flutter_samples/utils/CustomNavigator.dart';
import 'package:flutter_samples/view/animation_samples_page.dart';
import 'package:flutter_samples/view/empty_page.dart';
import 'package:flutter_samples/view_model/animation_samples_view_model.dart';
import 'package:flutter_samples/view_model/empty_page_view_model.dart';

class HomePageService extends Service {
  final List<SimpleNavigator> menu = [
    SimpleNavigator<EmptyPageViewModel>(
      pageName: '横向入场',
      page: EmptyPage(),
      viewModelBuilder: (_) => EmptyPageViewModel(),
    ),
    SimpleNavigator<EmptyPageViewModel>(
      pageName: '纵向入场',
      page: EmptyPage(),
      viewModelBuilder: (_) => EmptyPageViewModel(),
    ),
    SimpleNavigator<AnimationSamplesViewModel>(
      pageName: '纵向入场',
      page: AnimationSamplesPage(),
      viewModelBuilder: (_) => AnimationSamplesViewModel(),
    ),
  ];
}
