import 'package:cloud_firestore/cloud_firestore.dart';

class PageInfo {
  final QueryDocumentSnapshot? lastSnapshot;
  final int? limit;
  final bool? hasMorePosts;

  PageInfo({this.lastSnapshot, this.limit = 10, this.hasMorePosts = true});

  PageInfo copyWith(
      {QueryDocumentSnapshot? lastSnapshot, int? limit, bool? hasMorePosts}) {
    return PageInfo(
        lastSnapshot: lastSnapshot ?? this.lastSnapshot,
        limit: limit ?? this.limit,
        hasMorePosts: hasMorePosts ?? this.hasMorePosts);
  }
}
