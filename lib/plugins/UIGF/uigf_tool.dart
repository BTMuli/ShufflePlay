// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/services.dart';

// Package imports:
import 'package:json_schema/json_schema.dart';

class SppUigfTool {
  SppUigfTool._();

  static final SppUigfTool _instance = SppUigfTool._();

  factory SppUigfTool() => _instance;

  static JsonSchema? schema;

  Future<void> loadSchema() async {
    var schemaFile = await rootBundle.loadString('assets/schema/uigf_v4.json');
    schema = JsonSchema.create(jsonDecode(schemaFile));
  }

  Future<ValidationResults> validate(Map<String, dynamic> data) async {
    if (schema == null) await loadSchema();
    return schema!.validate(data);
  }
}
