// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:windows_taskbar/windows_taskbar.dart';

class SpProgressController extends ChangeNotifier {
  /// 标题
  late String title;

  /// 文本
  late String text;

  /// 进度，百分比
  late double? progress;

  /// isShow
  bool isShow = false;

  /// close
  void Function()? close;

  /// 是否在任务栏显示
  late bool onTaskbar;

  /// onTaskbar的getter
  bool get taskbar => onTaskbar;

  /// onTaskbar的setter
  set taskbar(bool value) {
    if (value && defaultTargetPlatform == TargetPlatform.windows) {
      onTaskbar = value;
      update(title: title, text: text, progress: progress);
      return;
    }
    if (!value && defaultTargetPlatform == TargetPlatform.windows) {
      WindowsTaskbar.setProgressMode(TaskbarProgressMode.noProgress);
    }
    onTaskbar = value;
  }

  /// 更新
  void update({
    String? title,
    String? text,
    double? progress,
  }) {
    if (title != null) this.title = title;
    if (text != null) this.text = text;
    this.progress = progress;
    if (onTaskbar) {
      if (progress == null) {
        WindowsTaskbar.setProgressMode(TaskbarProgressMode.indeterminate);
      } else {
        WindowsTaskbar.setProgressMode(TaskbarProgressMode.normal);
        WindowsTaskbar.setProgress(progress.toInt(), 100);
      }
    }
    notifyListeners();
  }

  /// 结束
  void end() {
    if (onTaskbar) {
      WindowsTaskbar.setProgressMode(TaskbarProgressMode.noProgress);
    }
    if (close != null) close!();
    notifyListeners();
  }

  /// 构造
  SpProgressController({
    this.title = '加载中',
    this.text = '请稍后...',
    this.progress,
    this.onTaskbar = false,
  }) {
    if (onTaskbar && defaultTargetPlatform == TargetPlatform.windows) {
      WindowsTaskbar.setProgressMode(TaskbarProgressMode.indeterminate);
      return;
    }
    onTaskbar = false;
  }
}

class SpProgress extends StatefulWidget {
  /// 控制器
  final SpProgressController controller;

  const SpProgress(this.controller, {super.key});

  static SpProgressController show(
    BuildContext context, {
    String? title,
    String? text,
    double? progress,
    bool onTaskbar = false,
  }) {
    var controller = SpProgressController(
      title: title ?? '加载中',
      text: text ?? '请稍后...',
      progress: progress,
      onTaskbar: onTaskbar,
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => SpProgress(controller),
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
    controller.addListener(() {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Text(controller.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            controller.text,
            style: FluentTheme.of(context).typography.body,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          SizedBox(height: 10.h),
          SizedBox(
            width: double.infinity,
            child: ProgressBar(
              value: controller.progress,
              backgroundColor: FluentTheme.of(context).accentColor.darkest,
              activeColor: FluentTheme.of(context).accentColor,
            ),
          )
        ],
      ),
    );
  }
}
