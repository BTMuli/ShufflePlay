// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

// Project imports:
import '../../models/nap/anno/nap_anno_content_model.dart';
import '../../models/nap/anno/nap_anno_list_model.dart';
import '../../request/nap/nap_api_anno.dart';
import '../../shared/ui/sp_infobar.dart';
import '../widgets/nap_anno_card.dart';

/// 公告页面
class NapAnnoPage extends StatefulWidget {
  const NapAnnoPage({super.key});

  @override
  State<NapAnnoPage> createState() => _NapAnnoPageState();
}

class _NapAnnoPageState extends State<NapAnnoPage>
    with AutomaticKeepAliveClientMixin {
  /// 公告列表
  List<NapAnnoListModel> annoList = [];

  /// 公告内容列表
  List<NapAnnoContentModel> annoContentList = [];

  /// t
  String t = '';

  /// api
  final SprNapApiAnno api = SprNapApiAnno();

  final controller = MacosTabController(initialIndex: 0, length: 2);

  /// todo 改为true
  @override
  bool get wantKeepAlive => false;

  @override
  void initState() {
    super.initState();
    Future.microtask(loadAnnoList);
  }

  /// 加载公告列表
  Future<void> loadAnnoList() async {
    annoList.clear();
    annoContentList.clear();
    if (mounted) setState(() {});
    var listResp = await api.getAnnoList();
    if (listResp.retcode != 0) {
      if (mounted) await SpInfobar.bbs(context, listResp);
      return;
    }
    var listData = listResp.data as NapAnnoListModelData;
    annoList = listData.list.map((e) => e.list).expand((e) => e).toList();
    t = listData.t;
    var contentResp = await api.getAnnoContent(t);
    if (contentResp.retcode != 0) {
      if (mounted) await SpInfobar.bbs(context, contentResp);
      return;
    }
    var contentData = contentResp.data as NapAnnoContentModelData;
    annoContentList = contentData.list;
    if (mounted) setState(() {});
    if (mounted) await SpInfobar.success(context, '公告加载成功');
  }

  /// 获取标题
  String getTitle(String title) {
    title = title.replaceAll('&amp;', '&');
    var reg = RegExp(r'<[^>]*>');
    if (reg.hasMatch(title)) return title.replaceAll(reg, '');
    return title;
  }

  /// 获取内容
  String getContent(String content) {
    content = content.replaceAll('&lt;', '<');
    content = content.replaceAll('&gt;', '>');
    return content;
  }

  /// 尝试打开链接
  Future<bool> tryLaunchUrl(String url) async {
    var reg = RegExp(
      r"javascript:miHoYoGameJSSDK.openIn(Browser|Webview)\('(.*)('|%27)\);",
    );
    var match = reg.firstMatch(url);
    if (match == null) return false;
    var target = match.group(2);
    if (target == null) return false;
    if (await canLaunchUrlString(target)) await launchUrlString(target);
    return true;
  }

  /// 显示公告
  Future<void> showAnno(BuildContext context, int annoId) async {
    try {
      var content = annoContentList.firstWhere((e) => e.annId == annoId);
      await showMacosSheet(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return MacosSheet(
            insetPadding: EdgeInsets.symmetric(
              horizontal: 60.w,
              vertical: 60.h,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  getTitle(content.title),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 500.h,
                    maxWidth: 1000.w,
                  ),
                  child: SingleChildScrollView(
                    child: HtmlWidget(
                      getContent(content.content),
                      textStyle: const TextStyle(fontFamily: 'SarasaGothic'),
                      onTapUrl: tryLaunchUrl,
                    ),
                  ),
                ),
                MacosIconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: MacosIcon(
                    MdiIcons.close,
                    color: MacosTheme.brightnessOf(context).resolve(
                      const Color.fromRGBO(0, 0, 0, 0.5),
                      const Color.fromRGBO(255, 255, 255, 0.5),
                    ),
                    size: 20.0,
                  ),
                ),
              ],
            ),
          );
        },
      );
    } on StateError {
      if (context.mounted) await SpInfobar.error(context, '公告内容不存在');
      return;
    }
  }

  Widget buildTopLeading(BuildContext context) {
    return MacosTooltip(
      message: '隐藏/显示侧边栏',
      useMousePosition: false,
      child: MacosIconButton(
        icon: MacosIcon(
          CupertinoIcons.sidebar_left,
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

  /// 构建列表
  Widget buildList(List<NapAnnoListModel> list, BuildContext context) {
    if (list.isEmpty) return const ProgressCircle();
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 36 / 16,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return NapAnnoCardWidget(
          anno: list[index],
          onPressed: () async => await showAnno(context, list[index].annId),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MacosScaffold(
      toolBar: ToolBar(
        title: const Text('游戏公告'),
        titleWidth: 150.w,
        leading: buildTopLeading(context),
      ),
      children: [
        ContentArea(
          builder: (context, _) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: MacosTabView(
              controller: controller,
              tabs: [
                MacosTab(label: '游戏公告'),
                MacosTab(label: '活动公告'),
              ],
              children: [
                buildList(annoList.where((e) => e.type == 3).toList(), context),
                buildList(annoList.where((e) => e.type == 4).toList(), context),
              ],
            ),
          ),
        )
      ],
    );
  }
}
