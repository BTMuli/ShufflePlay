// Package imports:
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher_string.dart';

// Project imports:
import '../../models/database/user/user_bbs_model.dart';
import '../../models/database/user/user_nap_model.dart';
import '../../models/nap/anno/nap_anno_content_model.dart';
import '../../models/nap/anno/nap_anno_list_model.dart';
import '../../request/nap/nap_api_anno.dart';
import '../../shared/store/user_bbs.dart';
import '../plugins/miyoushe_webview.dart';
import '../ui/sp_icon.dart';
import '../ui/sp_infobar.dart';
import '../widgets/nap_anno_card.dart';

/// 公告页面
class NapAnnoPage extends ConsumerStatefulWidget {
  /// 构造函数
  const NapAnnoPage({super.key});

  @override
  ConsumerState<NapAnnoPage> createState() => _NapAnnoPageState();
}

/// 公告页面状态
class _NapAnnoPageState extends ConsumerState<NapAnnoPage>
    with AutomaticKeepAliveClientMixin {
  /// 公告列表
  List<NapAnnoListModel> annoList = [];

  /// 公告内容列表
  List<NapAnnoContentModel> annoContentList = [];

  /// t
  String t = '';

  /// api
  final SprNapApiAnno api = SprNapApiAnno();

  UserBBSModel? get user => ref.watch(userBbsStoreProvider).user;

  UserNapModel? get account => ref.watch(userBbsStoreProvider).account;

  MysControllerWin controller = MysControllerWin();

  /// tabIndex
  int currentIndex = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    Future.microtask(loadAnnoList);
  }

  @override
  void dispose() {
    controller.webview.dispose();
    super.dispose();
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
    if (await canLaunchUrlString(target)) {
      if (user != null && account != null && mounted) {
        controller = await MysClientWin.create(context, target);
        if (mounted) await controller.show(context);
      } else {
        await launchUrlString(target);
      }
    }
    return true;
  }

  /// 显示公告
  Future<void> showAnno(BuildContext context, int annoId) async {
    try {
      var content = annoContentList.firstWhere((e) => e.annId == annoId);
      await showDialog(
        barrierDismissible: true,
        dismissWithEsc: true,
        context: context,
        builder: (context) {
          return ContentDialog(
            constraints: BoxConstraints(
              maxHeight: 480.h,
              maxWidth: 800.w,
              minHeight: 120.h,
              minWidth: 240.w,
            ),
            title: Text(getTitle(content.title)),
            content: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
              child: HtmlWidget(
                getContent(content.content),
                textStyle: const TextStyle(fontFamily: 'SarasaGothic'),
                onTapUrl: tryLaunchUrl,
              ),
            ),
            actions: [
              Button(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('关闭'),
              ),
            ],
          );
        },
      );
    } on StateError {
      if (context.mounted) await SpInfobar.error(context, '公告内容不存在');
      return;
    }
  }

  /// 构建头部
  Widget buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Row(
        children: [
          Text('公告', style: FluentTheme.of(context).typography.title),
          SizedBox(width: 8.w),
          Tooltip(
            message: '点击刷新',
            child: IconButton(
              onPressed: loadAnnoList,
              icon: SPIcon(FluentIcons.refresh),
            ),
          )
        ],
      ),
    );
  }

  /// 构建列表
  Widget buildList(
    List<NapAnnoListModel> list,
    BuildContext context,
    bool isGame,
  ) {
    if (list.isEmpty) return const Center(child: ProgressRing());
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: isGame ? 10 / 3 : 36 / 16,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return NapAnnoCardWidget(
          anno: list[index],
          onPressed: () async => await showAnno(context, list[index].annId),
          isGame: isGame,
        );
      },
    );
  }

  /// 构建tab
  Tab buildTab(BuildContext context, bool isGame) {
    return Tab(
      icon: currentIndex == (isGame ? 0 : 1)
          ? Icon(FluentIcons.game)
          : Icon(FluentIcons.calendar),
      text: Text(isGame ? '游戏公告' : '活动公告'),
      body: buildList(
        annoList.where((e) => e.type == (isGame ? 3 : 4)).toList(),
        context,
        isGame,
      ),
      selectedBackgroundColor: FluentTheme.of(context).accentColor,
      backgroundColor: FluentTheme.of(context).accentColor.withAlpha(50),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ScaffoldPage(
      header: buildHeader(context),
      content: TabView(
        currentIndex: currentIndex,
        closeButtonVisibility: CloseButtonVisibilityMode.never,
        tabWidthBehavior: TabWidthBehavior.sizeToContent,
        tabs: [buildTab(context, true), buildTab(context, false)],
        onChanged: (index) {
          currentIndex = index;
          setState(() {});
        },
      ),
    );
  }
}
