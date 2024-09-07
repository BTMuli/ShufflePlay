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

  @override
  Widget build(BuildContext context) {
    return Card(
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.circular(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Button(
            style: ButtonStyle(
              padding: WidgetStateProperty.all(EdgeInsets.zero),
            ),
            onPressed: onPressed,
            child: AspectRatio(
              aspectRatio: 36 / 13,
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
          ),
          Tooltip(
            message: getTitle(anno.title),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    anno.subtitle,
                    style: TextStyle(
                      fontSize: 16.spMin,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
