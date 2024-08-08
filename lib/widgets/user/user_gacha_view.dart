// Package imports:
import 'package:fluent_ui/fluent_ui.dart';

// Project imports:
import '../../database/user/user_gacha.dart';
import '../../models/database/user/user_gacha_model.dart';
import '../../models/plugins/UIGF/uigf_enum.dart';
import '../../utils/trans_time.dart';

class UserGachaViewWidget extends StatefulWidget {
  /// 选中的uid
  final String selectedUid;

  const UserGachaViewWidget({super.key, required this.selectedUid});

  @override
  State<UserGachaViewWidget> createState() => _UserGachaViewWidgetState();
}

class _UserGachaViewWidgetState extends State<UserGachaViewWidget> {
  /// 用户祈愿数据库
  final sqlite = SpsUserGacha();

  /// 祈愿数据
  List<UserGachaModel> gachaList = [];

  /// 监听selectedUid更改
  @override
  void didUpdateWidget(UserGachaViewWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedUid != widget.selectedUid) {
      Future.microtask(() async {
        gachaList = await sqlite.readUser(widget.selectedUid);
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      gachaList = await sqlite.readUser(widget.selectedUid);
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (gachaList.isEmpty) {
      return const Center(
        child: Text('暂无数据'),
      );
    }
    var timezone = DateTime.now().timeZoneOffset.inHours;
    return SingleChildScrollView(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: gachaList.length,
        itemBuilder: (context, index) {
          var item = gachaList[index];
          return ListTile(
            title: Text(item.name != null
                ? '${item.name}(${item.itemId})'
                : item.itemId),
            subtitle: Text(fromUtcTime(timezone, item.time).toString()),
            trailing: Text(item.gachaType.label),
          );
        },
      ),
    );
  }
}
