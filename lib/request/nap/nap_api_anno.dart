// Package imports:
import 'package:dio/dio.dart';

// Project imports:
import '../../models/bbs/bbs_base_model.dart';
import '../../models/nap/anno/nap_anno_content_model.dart';
import '../../models/nap/anno/nap_anno_list_model.dart';
import '../core/client.dart';

const napAnnoRespParam = {
  "game": "nap",
  "game_biz": "nap_cn",
  "lang": "zh-cn",
  "bundle_id": "nap_cn",
  "channel_id": "1",
  "level": "59",
  "platform": "pc",
  "region": "prod_gf_cn",
  "uid": "10696024"
};

class SprNapApiAnno {
  /// 请求客户端
  final SprClient client = SprClient();

  /// base url
  final String baseUrl = 'https://announcement-api.mihoyo.com/';

  /// 构造函数
  SprNapApiAnno() {
    client.dio.options.baseUrl = baseUrl;
  }

  /// 获取公告列表
  Future<BBSResp> getAnnoList() async {
    try {
      var resp = await client.dio.get(
        'common/nap_cn/announcement/api/getAnnList',
        queryParameters: napAnnoRespParam,
      );
      if (resp.data['retcode'] == 0) {
        return NapAnnoListModelResp.fromJson(resp.data);
      }
      return BBSResp.error(
        retcode: resp.data['retcode'],
        message: resp.data['message'],
      );
    } on DioException catch (e) {
      return BBSResp.error(
        retcode: e.response?.statusCode ?? 666,
        message: '[DioException] Fail to get anno list ${e.message}',
      );
    } on Exception catch (e) {
      return BBSResp.error(
        retcode: 666,
        message: '[Exception] Fail to get anno list ${e.toString()}',
      );
    }
  }

  /// 获取公告内容
  Future<BBSResp> getAnnoContent(String t) async {
    try {
      var resp = await client.dio.get(
        'common/nap_cn/announcement/api/getAnnContent',
        queryParameters: {
          ...napAnnoRespParam,
          't': t,
        },
      );
      if (resp.data['retcode'] == 0) {
        return NapAnnoContentModelResp.fromJson(resp.data);
      }
      return BBSResp.error(
        retcode: resp.data['retcode'],
        message: resp.data['message'],
      );
    } on DioException catch (e) {
      return BBSResp.error(
        retcode: e.response?.statusCode ?? 666,
        message: '[DioException] Fail to get anno content ${e.message}',
      );
    } on Exception catch (e) {
      return BBSResp.error(
        retcode: 666,
        message: '[Exception] Fail to get anno content ${e.toString()}',
      );
    }
  }
}
