// Package imports:
import 'package:fluent_ui/fluent_ui.dart';

// Project imports:
import '../../database/user/user_gacha.dart';
import '../../models/database/user/user_gacha_model.dart';
import '../../models/plugins/UIGF/uigf_enum.dart';
import '../../utils/trans_time.dart';

class UserGachaList extends StatefulWidget {
  /// 选中的uid
  final String selectedUid;

  /// 池子类型
  final UigfNapPoolType poolType;

  const UserGachaList({
    super.key,
    required this.selectedUid,
    required this.poolType,
  });

  @override
  State<UserGachaList> createState() => _UserGachaListState();
}

class _UserGachaListState extends State<UserGachaList> {
  final sqlite = SpsUserGacha();

  List<UserGachaModel> gachaList = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      gachaList = await sqlite.readUser(
        widget.selectedUid,
        gachaType: widget.poolType,
      );
      if (mounted) setState(() {});
    });
  }

  Color getTextColor(String? rankType) {
    switch (rankType) {
      case '2':
        return Colors.blue;
      case '3':
        return Colors.purple;
      case '4':
        return Colors.orange;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (gachaList.isEmpty) return const Center(child: Text('暂无数据'));
    var timezone = DateTime.now().timeZoneOffset.inHours;
    return SingleChildScrollView(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: gachaList.length,
        itemBuilder: (context, index) {
          var item = gachaList[index];
          return ListTile(
            title: Text(
              item.name != null ? '${item.name}' : item.itemId,
              style: TextStyle(color: getTextColor(item.rankType)),
            ),
            subtitle: Text(fromUtcTime(timezone, item.time).toString()),
            trailing: Text(item.itemType ?? ''),
          );
        },
      ),
    );
  }
}
