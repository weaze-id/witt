import 'package:flutter/material.dart';

import 'package:witt/witt.dart';

import 'home_page_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  void _navigate(String routeName) {
    final homePageC = WService.get<HomePageController>();
    if (homePageC.currentRouteName != routeName) {
      WRouter.pushReplacementNamed(routeName, nestedKeyLabel: "main");
    }
  }

  @override
  Widget build(BuildContext context) {
    final homePageC = WService.get<HomePageController>();
    return Scaffold(
      appBar: AppBar(title: const Text("Example App")),
      body: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                ListTile(
                  title: const Text("Page 1"),
                  onTap: () => _navigate("/page-1"),
                ),
                ListTile(
                  title: const Text("Page 2"),
                  onTap: () => _navigate("/page-2"),
                ),
                ListTile(
                  title: const Text("Page 3"),
                  onTap: () => _navigate("/page-3"),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: WNestedNavigator(
              nestedKeyLabel: "main",
              initialRoute: "/page-1",
              onRouteChanged: (routeName) =>
                  homePageC.currentRouteName = routeName,
              onGenerateRoute: (settings) => WRouter.onGenerateMaterialRoute(
                settings: settings,
                pages: [
                  WPage(
                    path: "/page-1",
                    builder: (context, arguments) =>
                        const ContentPage(pageName: "Page 1"),
                  ),
                  WPage(
                    path: "/page-2",
                    builder: (context, arguments) =>
                        const ContentPage(pageName: "Page 2"),
                  ),
                  WPage(
                    path: "/page-3",
                    builder: (context, arguments) =>
                        const ContentPage(pageName: "Page 3"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ContentPage extends StatelessWidget {
  const ContentPage({
    Key? key,
    required this.pageName,
  }) : super(key: key);

  final String pageName;

  @override
  Widget build(BuildContext context) {
    final homePageC = WService.get<HomePageController>();
    return Scaffold(
      appBar: AppBar(title: Text(pageName)),
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
