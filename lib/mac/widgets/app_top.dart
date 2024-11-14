// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:macos_ui/macos_ui.dart';

Widget buildTopLeading(BuildContext context) {
  return MacosTooltip(
    message: '隐藏/显示侧边栏',
    useMousePosition: false,
    child: MacosIconButton(
      icon: MacosIcon(
        Icons.table_chart,
        color: MacosTheme.brightnessOf(context).resolve(
          const Color.fromRGBO(0, 0, 0, 0.5),
          const Color.fromRGBO(255, 255, 255, 0.5),
        ),
        size: 20.0,
      ),
      boxConstraints: const BoxConstraints(
        minHeight: 20,
        minWidth: 20,
        maxWidth: 48,
        maxHeight: 38,
      ),
      onPressed: MacosWindowScope.of(context).toggleSidebar,
    ),
  );
}

ToolBarIconButton buildTopTrailing(BuildContext context) {
  return ToolBarIconButton(
    label: '设置',
    icon: MacosIcon(Icons.settings),
    onPressed: MacosWindowScope.of(context).toggleEndSidebar,
    showLabel: false,
    tooltipMessage: '隐藏/显示设置',
  );
}
