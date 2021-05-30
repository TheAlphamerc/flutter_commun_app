import 'package:flutter/material.dart';
import 'package:flutter_commun_app/ui/pages/home/feed/widget/post_image.dart';
import 'package:flutter_commun_app/ui/theme/theme.dart';
import 'package:flutter_commun_app/model/post/post_model.dart';
import 'package:flutter_commun_app/ui/widget/circular_image.dart';

class Post extends StatelessWidget {
  final PostModel post;
  const Post({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.onPrimary,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
              leading: const CircularImage(),
              contentPadding: const EdgeInsets.only(left: 16, right: 16),
              title: Text("Posted by", style: TextStyles.headline16(context)),
              subtitle: Text(post.createdAt.toPostTime,
                  style: TextStyles.bodyText14(context))),
          Text(post.description).hP16,
          PostImages(
            list: post.images,
          )
        ],
      ),
    );
  }
}
