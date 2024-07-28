// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

// Project imports:
import '../widgets/app/app_infobar.dart';
import 'log_tool.dart';

/// 文件工具
class SPFileTool {
  SPFileTool._();

  static final SPFileTool _instance = SPFileTool._();

  /// 获取实例
  factory SPFileTool() => _instance;

  /// 获取应用数据目录
  Future<String> getAppDataDir() async {
    var dir = await getApplicationDocumentsDirectory();
    return path.join(dir.path, 'ShufflePlay');
  }

  /// 获取相对应用数据目录的路径
  Future<String> getAppDataPath(String relativePath) async {
    var dir = await getAppDataDir();
    return path.join(dir, relativePath);
  }

  /// 检测文件是否存在
  Future<bool> isFileExist(String path) async {
    return File(path).exists();
  }

  /// 创建文件
  Future<File> createFile(String path) async {
    return File(path).create(recursive: true);
  }

  /// 读取文件
  Future<String?> readFile(String path) async {
    if (await _instance.isFileExist(path)) {
      return File(path).readAsString();
    } else {
      return null;
    }
  }

  /// 写入文件
  Future<File> writeFile(String path, String content) async {
    return File(path).writeAsString(content);
  }

  /// 检测目录是否存在
  Future<bool> isDirExist(String defaultPath) {
    return Directory(defaultPath).exists();
  }

  /// 创建目录
  Future<Directory> createDir(String defaultPath) {
    return Directory(defaultPath).create(recursive: true);
  }

  /// 获取目录下的文件名（不包括子目录）
  Future<List<String>> getFileNames(String dirPath) async {
    var dir = Directory(dirPath);
    if (await dir.exists()) {
      return dir.list().map((e) => path.basename(e.path)).toList();
    } else {
      return [];
    }
  }

  /// 文件删除
  Future<bool> deleteFile(String path, {BuildContext? context}) async {
    var check = await isFileExist(path);
    if (!check) return true;
    try {
      await File(path).delete();
    } catch (e) {
      var errInfo = ['删除文件失败', '文件：$path', '错误：$e'];
      if (context != null && context.mounted) {
        SpInfobar.error(context, errInfo.join('\n'));
      }
      SPLogTool.error(errInfo);
      return false;
    }
    return true;
  }

  /// 获取文件大小-调用FileStat
  int getFileSize(String path) {
    var stat = FileStat.statSync(path);
    return stat.size;
  }

  /// 打开目录
  Future<bool> openDir(String dirPath) async {
    var check = await isDirExist(dirPath);
    if (!check) return false;
    await Process.run('explorer', [dirPath]);
    return true;
  }
}
