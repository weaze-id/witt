abstract class WDisposable {
  WDisposable() {
    Future.delayed(Duration.zero, () {
      initialize();
    });
  }

  void initialize() {}
  void dispose() {}
}
