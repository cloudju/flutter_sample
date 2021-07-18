import 'package:flutter/material.dart';
import 'package:flutter_samples/view_model/empty_page_view_model.dart';
import 'package:flutter_samples/view_model/view_model.dart';
import 'package:provider/provider.dart';

class EmptyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 用ViewModel.of<T>(context)取得的ViewModel并不会响应notifyListeners()
    // 应该是ChangeNotifierProvider<T>()时，并没有把viewmodel添加到ChangeNotifier()._listeners中去
    // ignore: todo
    // TODO: 调查到底是何时将viewmodel添加到ChangeNotifier()._listeners中去的呢？
    // ignore: unused_local_variable
    final viewModelNotFromConsumer = ViewModel.of<EmptyPageViewModel>(context);
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        // child: ElevatedButton(
        //   child: Text('count: ${viewModelNotFromConsumer.count}'),
        //   onPressed: viewModelNotFromConsumer.onClick,
        // ),
        child: Consumer<EmptyPageViewModel>(
          builder: (context, viewModel, child) => ElevatedButton(
            child: Text('count: ${viewModel.count}'),
            onPressed: viewModel.onClick,
          ),
        ),
      ),
    );
  }
}
