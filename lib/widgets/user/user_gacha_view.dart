// Package imports:
import 'package:fluent_ui/fluent_ui.dart';

// Project imports:
import '../../database/user/user_gacha.dart';
import '../../models/database/user/user_gacha_model.dart';
import '../../models/plugins/UIGF/uigf_enum.dart';

class UserGachaViewWidget extends StatefulWidget {
  /// 选中的uid
  final String? selectedUid;

  const UserGachaViewWidget({super.key, this.selectedUid});

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
        if (widget.selectedUid != null) {
          gachaList = await sqlite.readUser(widget.selectedUid!);
        }
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
      if (widget.selectedUid != null) {
        gachaList = await sqlite.readUser(widget.selectedUid!);
      }
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
    return SingleChildScrollView(
      child: Column(
        children: gachaList.map((e) {
          return ListTile(
            title: Text(e.name != null ? '${e.name}(${e.itemId})' : e.itemId),
            subtitle: Text(e.time),
            trailing: Text(e.gachaType.label),
          );
        }).toList(),
      ),
    );
  }
}
