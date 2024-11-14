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

  Tab buildTab(UigfNapPoolType pool) {
    return Tab(
      text: Text(pool.label),
      body: UserGachaList(
        selectedUid: widget.selectedUid,
        poolType: pool,
      ),
      icon: selectedTab == pool.index
          ? const Icon(FluentIcons.giftbox_open)
          : const Icon(FluentIcons.giftbox),
      selectedBackgroundColor: FluentTheme.of(context).accentColor,
      backgroundColor: FluentTheme.of(context).accentColor.withOpacity(0.2),
      semanticLabel: pool.label,
    );
  }

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
      tabs: tabList.map(buildTab).toList(),
      onChanged: (index) {
        selectedTab = index;
        if (context.mounted) setState(() {});
      },
    );
  }
}
