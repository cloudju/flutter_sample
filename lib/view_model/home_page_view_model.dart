import 'package:flutter_samples/service/home_page_service.dart';
import 'package:flutter_samples/service/service.dart';
import 'package:flutter_samples/view_model/view_model.dart';

class HomePageViewModel extends ViewModel {
  HomePageViewModel({List<Service>? services})
      : datas = [],
        super(services: services) {
    final homeService = findService<HomePageService>();
    datas = homeService?.menu ?? [];
  }

  List<String> datas;
}
