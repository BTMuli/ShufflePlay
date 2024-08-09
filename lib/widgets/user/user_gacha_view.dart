// Package imports:
import 'package:fluent_ui/fluent_ui.dart';

// Project imports:
import '../../plugins/UIGF/models/uigf_enum.dart';
import 'user_gacha_list.dart';

class UserGachaViewWidget extends StatefulWidget {
  /// 选中的uid
  final String selectedUid;

  const UserGachaViewWidget({super.key, required this.selectedUid});

  @override
  State<UserGachaViewWidget> createState() => _UserGachaViewWidgetState();
}

class _UserGachaViewWidgetState extends State<UserGachaViewWidget> {
  /// selectedTab
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    const tabList = [
      UigfNapPoolType.normal,
      UigfNapPoolType.upC,
      UigfNapPoolType.upW,
      UigfNapPoolType.bond,
    ];
    return TabView(
      closeButtonVisibility: CloseButtonVisibilityMode.never,
      tabWidthBehavior: TabWidthBehavior.sizeToContent,
      currentIndex: selectedTab,
      tabs: [
        for (var pool in tabList)
          Tab(
            text: Text(pool.label),
            body: UserGachaList(
              selectedUid: widget.selectedUid,
              poolType: pool,
            ),
            icon: selectedTab == tabList.indexOf(pool)
                ? const Icon(FluentIcons.giftbox_open)
                : const Icon(FluentIcons.giftbox),
          ),
      ],
      onChanged: (index) {
        setState(() {
          selectedTab = index;
        });
      },
    );
  }
}
