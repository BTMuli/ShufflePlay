// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:macos_ui/macos_ui.dart';

// Project imports:
import '../models/ui_model.dart';
import 'sp_icon.dart';

class SpProgressController extends ChangeNotifier {
  /// 标题
  late String title;

  /// 文本
  late String text;

  /// 进度，百分比
  late double? progress;

  /// isShow
  bool isShow = false;

  /// 构造函数
  SpProgressController({
    this.title = '加载中',
    this.text = '请稍后...',
    this.progress,
  });

  /// close
  void Function()? close;

  /// 更新
  void update({
    String? title,
    String? text,
    double? progress,
  }) {
    if (title != null) this.title = title;
    if (text != null) this.text = text;
    this.progress = progress;
    notifyListeners();
  }

  /// 结束
  void end() {
    if (close != null) close!();
    notifyListeners();
  }
}

class SpProgress extends StatefulWidget {
  final SpProgressController controller;

  const SpProgress(this.controller, {super.key});

  static SpProgressController show(
    BuildContext context, {
    String? title,
    String? text,
    double? progress,
  }) {
    var controller = SpProgressController(
      title: title ?? '加载中',
      text: text ?? '请稍后...',
      progress: progress,
    );
    showMacosAlertDialog(
      context: context,
      builder: (_) => SpProgress(controller),
    );
    controller.isShow = true;
    return controller;
  }

  @override
  State<SpProgress> createState() => _SpProgressWidget();
}

class _SpProgressWidget extends State<SpProgress> {
  /// controller
  SpProgressController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    controller.close = () {
      if (controller.isShow) {
        Navigator.of(context).pop();
        controller.isShow = false;
      }
    };
    controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    controller.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MacosAlertDialog(
      appIcon: const SpAppIcon(),
      title: Text(controller.title),
      message: Text(controller.text),
      primaryButton: PushButton(
        controlSize: ControlSize.large,
        child: ProgressCircle(
          value: controller.progress,
          innerColor: MacosTheme.of(context).accentColor?.color,
          borderColor: MacosTheme.of(context).accentColor?.color,
        ),
      ),
    );
  }
}
