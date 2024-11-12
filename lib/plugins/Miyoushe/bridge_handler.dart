// Project imports:
import '../../database/app/app_config.dart';
import '../../models/bbs/bbs_constant_enum.dart';
import '../../models/bbs/bridge/bbs_bridge_model.dart';
import '../../request/bbs/bbs_api_token.dart';
import '../../request/core/gen_ds_header.dart';
import '../../store/user/user_bbs.dart';
import '../../tools/log_tool.dart';
import '../../ui/sp_infobar.dart';
import 'miyoushe_client.dart';

/// 处理JSBridge的消息
Future<void> handleBridgeMessage(
  BbsBridgeModel data,
  MiyousheController controller,
) async {
  switch (data.method) {
    case 'closePage':
      await handleClosePage(data, controller);
      break;
    case 'eventTrack':
      await handleEventTrack(data, controller);
      break;
    case 'getActionTicket':
      await handleGetActionTicket(data, controller);
      break;
    case 'getCookieInfo':
      await handleGetCookieInfo(data, controller);
      break;
    case 'getCookieToken':
      await handleGetCookieToken(data, controller);
      break;
    case 'getCurrentLocale':
      await handleGetCurrentLocale(data, controller);
      break;
    case 'getDS':
      await handleGetDS(data, controller);
      break;
    case 'getDS2':
      await handleGetDS2(data, controller);
      break;
    case 'getHTTPRequestHeaders':
      await handleGetHTTPRequestHeaders(data, controller);
      break;
    case 'getStatusBarHeight':
      await handleGetStatusBarHeight(data, controller);
      break;
    case "hideLoading":
      await controller.loadJSBridge();
      break;
    case 'pushPage':
      await handlePushPage(data, controller);
      break;
    case 'setPresentationStyle':
      await handleSetPresentationStyle(data, controller);
      break;
    case 'share':
      await handleShare(data, controller);
      break;
    default:
      SPLogTool.warn(
        '[Miyoushe] Unknown method: ${data.method}\n'
        'payload: ${data.payload}',
      );
      await SpInfobar.warn(
        controller.context,
        'Unknown method: ${data.method}',
      );
      break;
  }
}

/// 处理消息-closePage
Future<void> handleClosePage(
  BbsBridgeModel arg,
  MiyousheController controller,
) async {
  SPLogTool.debug('[Miyoushe] Close page');
  var canGoback = controller.routeStack.length > 1;
  if (canGoback) {
    controller.routeStack.removeLast();
    await controller.webview.loadUrl(controller.routeStack.last);
    await controller.loadJSBridge();
  } else {
    await controller.close();
  }
}

/// 处理消息-eventTrack
Future<void> handleEventTrack(
  BbsBridgeModel arg,
  MiyousheController controller,
) async {
  SPLogTool.debug('[Miyoushe] Event track: ${arg.payload}');
  await controller.loadJSBridge();
}

/// 处理消息-getActionTicket
Future<void> handleGetActionTicket(
  BbsBridgeModel arg,
  MiyousheController controller,
) async {
  BbsBridgeGetActionTicket data = BbsBridgeGetActionTicket.fromJson(
    arg.toJson((value) => value),
  );
  if (controller.ref == null) return;
  var user = controller.ref!.read(userBbsStoreProvider).user;
  if (user == null || user.cookie == null) return;
  SPLogTool.debug('[Miyoushe] Get action ticket: ${data.payload?.actionType}');
  var api = SprBbsApiToken();
  var resp = await api.getActionTicket(user.cookie!, data.payload!.actionType);
  await controller.callback(arg.callback!, resp.data);
}

/// 处理消息-getCookieInfo
Future<void> handleGetCookieInfo(
  BbsBridgeModel arg,
  MiyousheController controller,
) async {
  if (controller.ref == null) return;
  var user = controller.ref!.read(userBbsStoreProvider).user;
  if (user == null || user.cookie == null) return;
  var data = {
    "ltoken": user.cookie!.ltoken,
    "ltuid": user.cookie!.ltuid,
    "login_ticket": "",
  };
  SPLogTool.debug('[Miyoushe] Get cookie info: $data');
  await controller.callback(arg.callback!, data);
}

/// 处理消息-getCookieToken
Future<void> handleGetCookieToken(
  BbsBridgeModel arg,
  MiyousheController controller,
) async {
  if (controller.ref == null) return;
  var user = controller.ref!.read(userBbsStoreProvider).user;
  if (user == null || user.cookie == null) return;
  var js = '''javascript:(function(){
  let domainCur = window.location.hostname;
  if (domainCur.endsWith('.miyoushe.com')) domainCur = '.miyoushe.com';
  else domainCur = '.mihoyo.com';
  document.cookie = 'account_id=${user.cookie!.accountId}; domain=' + domainCur + '; path=/; max-age=31536000';
  document.cookie = 'account_id_v2=${user.cookie!.accountId}; domain=' + domainCur + '; path=/; max-age=31536000';
  document.cookie = 'account_mid_v2=${user.cookie!.mid}; domain=' + domainCur + '; path=/; max-age=31536000';
  document.cookie = 'cookie_token=${user.cookie!.cookieToken}; domain=' + domainCur + '; path=/; max-age=31536000';
  document.cookie = 'ltmid_v2=${user.cookie!.mid}; domain=' + domainCur + '; path=/; max-age=31536000';
  document.cookie = 'ltoken=${user.cookie!.ltoken}; domain=' + domainCur + '; path=/; max-age=31536000';
  document.cookie = 'ltuid_v2=${user.cookie!.ltuid}; domain=' + domainCur + '; path=/; max-age=31536000';
  })();''';
  SPLogTool.debug('[Miyoushe] Get cookie token');
  await controller.webview.executeScript(js);
  var data = {"cookie_token": user.cookie!.cookieToken};
  await controller.callback(arg.callback!, data);
}

/// 处理消息-getCurrentLocale
Future<void> handleGetCurrentLocale(
  BbsBridgeModel arg,
  MiyousheController controller,
) async {
  SPLogTool.debug('[Miyoushe] Get current locale');
  var data = {"mi18nLang": "zh-cn"};
  await controller.callback(arg.callback!, data);
}

/// 处理消息-getDS
Future<void> handleGetDS(
  BbsBridgeModel arg,
  MiyousheController controller,
) async {
  var data = {"DS": getDsJsVersion(BbsConstantSalt.lk2, true, null, null)};
  SPLogTool.debug('[Miyoushe] Get DS: $data');
  await controller.callback(arg.callback!, data);
}

/// 处理消息-getDS2
Future<void> handleGetDS2(
  BbsBridgeModel arg,
  MiyousheController controller,
) async {
  BbsBridgeGetDS2 data = BbsBridgeGetDS2.fromJson(
    arg.toJson((value) => value),
  );
  var res = {
    "DS": getDsJsVersion(
      BbsConstantSalt.x4,
      false,
      data.payload?.query,
      data.payload?.body,
    )
  };
  SPLogTool.debug('[Miyoushe] Get DS2: $res');
  await controller.callback(arg.callback!, res);
}

/// 处理消息-getHTTPRequestHeaders
Future<void> handleGetHTTPRequestHeaders(
  BbsBridgeModel arg,
  MiyousheController controller,
) async {
  var sqlite = SpsAppConfig();
  var device = await sqlite.readDevice();
  var data = {
    "user-agent": bbsUaMobile,
    "x-rpc-client_type": "2",
    "x-rpc-device_id": device.deviceId,
    "x-rpc-app_version": bbsVersion,
    "x-rpc-device_fp": device.deviceFp,
    "x-rpc-device_name": device.deviceName,
  };
  SPLogTool.debug('[Miyoushe] Get HTTP request headers: $data');
  await controller.callback(arg.callback!, data);
}

/// 处理消息-getStatusBarHeight
Future<void> handleGetStatusBarHeight(
  BbsBridgeModel arg,
  MiyousheController controller,
) async {
  var data = {"statusBarHeight": 0};
  SPLogTool.debug('[Miyoushe] Get status bar height: $data');
  await controller.callback(arg.callback!, data);
}

/// 处理消息-pushPage
Future<void> handlePushPage(
  BbsBridgeModel arg,
  MiyousheController controller,
) async {
  var data = BbsBridgePayloadPushPage.fromJson(
    arg.payload as Map<String, dynamic>,
  );
  if (!data.page.startsWith('http')) {
    await SpInfobar.warn(controller.context, 'Invalid page: ${data.page}');
    return;
  }
  SPLogTool.debug('[Miyoushe] Push page: ${data.page}');
  controller.routeStack.add(data.page);
  await controller.webview.loadUrl(data.page);
  await controller.loadJSBridge();
}

/// 处理消息-setPresentationStyle
Future<void> handleSetPresentationStyle(
  BbsBridgeModel arg,
  MiyousheController controller,
) async {
  BbsBridgeSetPresentationStyle data = BbsBridgeSetPresentationStyle.fromJson(
    arg.toJson((value) => value),
  );
  SPLogTool.debug(
    '[Miyoushe] Set presentation style: ${data.payload?.toJson().toString()}',
  );
  await controller.loadJSBridge();
}

/// 处理消息-share
/// todo: share
Future<void> handleShare(
  BbsBridgeModel arg,
  MiyousheController controller,
) async {
  SPLogTool.debug('[Miyoushe] Share: ${arg.payload}');
  if (arg.callback != null) {
    await controller.callbackNull(arg.callback!);
  }
}
