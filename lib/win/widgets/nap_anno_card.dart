// Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Project imports:
import '../../models/nap/anno/nap_anno_list_model.dart';

class NapAnnoCardWidget extends StatelessWidget {
  /// 卡片内容
  final NapAnnoListModel anno;

  /// onPressed
  final VoidCallback? onPressed;

  /// 构造函数
  const NapAnnoCardWidget({super.key, required this.anno, this.onPressed});

  /// 获取标题
  String getTitle(String title) {
    var reg = RegExp(r'<[^>]*>');
    if (reg.hasMatch(title)) {
      return title.replaceAll(reg, '');
    }
    return title;
  }

  /// 构建封面
  Widget buildCover() {
    return AspectRatio(
      aspectRatio: 36 / 13,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4.sp),
          topRight: Radius.circular(4.sp),
        ),
        child: CachedNetworkImage(
          imageUrl: anno.banner,
          progressIndicatorBuilder: (context, url, progress) => Center(
            child: ProgressRing(value: progress.progress),
          ),
          fit: BoxFit.contain,
          errorWidget: (context, url, error) => const Center(
            child: Icon(FluentIcons.error),
          ),
        ),
      ),
    );
  }

  /// 构建标题栏，当标题过长时，省略号显示
  Widget buildTitle() {
    return Tooltip(
      message: getTitle(anno.title),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Text(
              ' ${getTitle(anno.subtitle)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(4.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Button(
            style: ButtonStyle(
              padding: WidgetStateProperty.all(EdgeInsets.zero),
            ),
            onPressed: onPressed,
            child: buildCover(),
          ),
          Flexible(
            fit: FlexFit.tight,
            child: Center(child: buildTitle()),
          ),
        ],
      ),
    );
  }
}
