import 'package:flutter/material.dart';
import 'package:flutter_samples/service/home_page_service.dart';
import 'package:flutter_samples/view_model/home_page_view_model.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Consumer<HomePageViewModel>(
          builder: (context, viewModel, child) => viewModel.listView(context),
        ),
      ),
    );
  }
}
