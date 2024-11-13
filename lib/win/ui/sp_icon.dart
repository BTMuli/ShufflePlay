// Package imports:
import 'package:fluent_ui/fluent_ui.dart';

/// 对Icon进行简单封装，使其支持动态主题
class SPIcon extends StatefulWidget {
  /// 图标
  final IconData icon;

  /// 大小
  final double? size;

  /// 颜色
  final AccentColor? color;

  /// 构造函数
  const SPIcon(this.icon, {this.size, this.color, super.key});

  @override
  State<SPIcon> createState() => _SPIconState();
}

class _SPIconState extends State<SPIcon> {
  @override
  Widget build(BuildContext context) {
    return Icon(
      widget.icon,
      size: widget.size,
      color: widget.color?.normal ?? FluentTheme.of(context).accentColor,
    );
  }
}
