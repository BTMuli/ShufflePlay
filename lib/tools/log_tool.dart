// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:logger/logger.dart';
import 'package:path/path.dart' as path;

// Project imports:
import 'file_tool.dart';

class SPLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    if (kDebugMode) {
      return true;
    }
    return event.level.index > Level.debug.index;
  }
}

/// 日志工具
class SPLogTool {
  SPLogTool._();

  /// 实例
  static final SPLogTool instance = SPLogTool._();

  /// 日志
  late Logger logger;

  /// 日志目录
  late String _logDir;

  /// 获取实例
  factory SPLogTool() => instance;

  /// 文件工具
  final SPFileTool fileTool = SPFileTool();

  /// 获取日志目录
  String get logDir => _logDir;

  /// 获取文件名称 yyyy-MM-dd.log
  static String _getFileName() {
    var now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}.log';
  }

  /// 获取日志文件
  Future<File> _getLogFile() async {
    var file = path.join(logDir, _getFileName());
    if (!await instance.fileTool.isFileExist(file)) {
      return await instance.fileTool.createFile(file);
    }
    return File(file);
  }

  /// 初始化
  Future<void> init() async {
    var outputC = ConsoleOutput();
    var outputs = <LogOutput>[outputC];
    _logDir = await instance.fileTool.getAppDataPath('log');
    PrettyPrinter printer;
    if (!kDebugMode) {
      outputs.add(FileOutput(file: await _getLogFile()));
      printer = PrettyPrinter(
        methodCount: 0,
        errorMethodCount: 5,
        lineLength: 100,
        colors: false,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.dateAndTime,
      );
    } else {
      printer = PrettyPrinter(
        dateTimeFormat: DateTimeFormat.dateAndTime,
        methodCount: 5,
      );
    }
    logger = Logger(
      filter: SPLogFilter(),
      level: Level.all,
      output: MultiOutput(outputs),
      printer: printer,
    );
  }

  /// 打开日志目录
  Future<void> openLogDir() async {
    await fileTool.openDir(logDir);
  }

  /// 打印信息日志
  static void info(dynamic message) {
    var str = message.toString();
    if (message is List<String>) {
      str = message.join('\n');
    }
    instance.logger.log(Level.info, str);
  }

  /// 打印警告日志
  static void warn(dynamic message) {
    var str = message.toString();
    if (message is List<String>) {
      str = message.join('\n');
    }
    instance.logger.log(Level.warning, str);
  }

  /// 打印错误日志
  static void error(dynamic message) {
    var str = message.toString();
    if (message is List<String>) {
      str = message.join('\n');
    }
    instance.logger.log(Level.error, str);
  }

  static void debug(dynamic message) {
    var str = message.toString();
    if (message is List<String>) {
      str = message.join('\n');
    }
    instance.logger.log(Level.debug, str);
  }
}
