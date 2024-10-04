// Package imports:
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 启动游戏页面
class AppGamePage extends ConsumerStatefulWidget {
  /// 构造函数
  const AppGamePage({super.key});

  @override
  ConsumerState<AppGamePage> createState() => _AppGamePageState();
}

/// 启动游戏页面状态
class _AppGamePageState extends ConsumerState<AppGamePage> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('游戏页面'),
    );
  }
}
