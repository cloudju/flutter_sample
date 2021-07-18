import 'package:flutter/material.dart';
import 'package:flutter_samples/service/home_page_service.dart';
import 'package:flutter_samples/service/service.dart';
import 'package:flutter_samples/utils/CustomNavigator.dart';
import 'package:flutter_samples/view/empty_page.dart';
import 'package:flutter_samples/view_model/empty_page_view_model.dart';
import 'package:flutter_samples/view_model/view_model.dart';

class HomePageViewModel extends ViewModel {
  HomePageViewModel({List<Service>? services}) : super(services: services);

  Widget listView(BuildContext context) {
    final homeService = findService<HomePageService>();
    final datas = homeService?.menu ?? [];
    return Container(
      color: Colors.green,
      child: Column(
        children: datas
            .map(
              (e) => Center(
                child: Container(
                  child: ElevatedButton(
                    child: Text(e),
                    onPressed: () {
                      CustomNavigator().push(
                        context: context,
                        nextPage: EmptyPage(),
                        viewModelBuilder: (_) => EmptyPageViewModel(),
                      );
                    },
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
