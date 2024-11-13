// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import '../../models/database/user/user_gacha_model.dart';
import '../../plugins/UIGF/models/uigf_enum.dart';
import '../../shared/database/user_gacha.dart';
import '../../shared/utils/trans_time.dart';

class UserGachaList extends StatefulWidget {
  final String uid;
  final UigfNapPoolType pool;

  const UserGachaList(this.uid, this.pool, {super.key});

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
      gachaList = await sqlite.readUser(widget.uid, gachaType: widget.pool);
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
    if (gachaList.isEmpty) {
      return const Center(
        child: Text('暂无数据', style: TextStyle(color: Colors.white)),
      );
    }
    var timezone = DateTime.now().timeZoneOffset.inHours;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: gachaList.length,
        itemBuilder: (context, index) {
          var item = gachaList[index];
          return ListTile(
            title: Text(
              item.name != null ? '${item.name}' : item.itemId,
              style: TextStyle(color: getTextColor(item.rankType)),
            ),
            subtitle: Text(
              fromUtcTime(timezone, item.time).toString(),
              style: TextStyle(color: Colors.grey),
            ),
            trailing: Text(
              item.itemType ?? '',
              style: TextStyle(color: Colors.grey),
            ),
          );
        },
      ),
    );
  }
}
