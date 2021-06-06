import 'package:flutter/material.dart';
import 'package:flutter_commun_app/model/post/post_model.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:flutter_commun_app/ui/widget/circular_image.dart';

class PostHeader extends StatelessWidget {
  const PostHeader(
      {Key key,
      this.post,
      this.trailing,
      this.contentPadding = const EdgeInsets.only(left: 16, right: 16)})
      : super(key: key);
  final PostModel post;
  final Widget trailing;
  final EdgeInsetsGeometry contentPadding;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircularImage(),
      contentPadding: contentPadding,
      title: Text("Posted by", style: TextStyles.headline16(context)),
      subtitle: Text(post.createdAt.toPostTime,
          style: TextStyles.bodyText14(context)),
      trailing: trailing,
    );
  }
}
