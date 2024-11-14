// Package imports:
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class MiyousheController extends ChangeNotifier {
  late BuildContext context;
  late double height;
  late WidgetRef? ref;
  List<String> routeStack = [];
  late String title;
  late String url;
  late String userAgent;
  late double width;

  Future<void> initialize(
    String url, {
    String? title,
    double? width,
    double? height,
    String? userAgent,
  });

  Future<void> callbackNull(String cb);

  Future<void> callback(String cb, dynamic data);

  Future<void> executeScript(String script);

  Future<void> handleMessage(dynamic message);

  Future<void> loadJSBridge();

  Future<void> loadUrl(String url);

  Future<void> show(BuildContext context);

  Future<void> close();
}
