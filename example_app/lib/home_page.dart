import 'package:flutter/material.dart';
import 'package:witt/witt.dart';

import 'home_page_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  void _navigate() {
    WRouter.pushMaterialPage(
      builder: (context) => WServiceBuilder(
        serviceBuilder: (context) =>
            WService.addLazySingleton(() => HomePageController()),
        child: const HomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final homePageC = WService.get<HomePageController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Example App"),
        actions: [
          IconButton(
            onPressed: _navigate,
            icon: const Icon(Icons.add_to_photos_outlined),
          )
        ],
      ),
      body: WListener(
        notifier: homePageC.counter,
        builder: (context) => Center(
          child: Text(homePageC.counter.value.toString()),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: homePageC.incrementCounter,
        child: const Icon(Icons.add),
      ),
    );
  }
}
