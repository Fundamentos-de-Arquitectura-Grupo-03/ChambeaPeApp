import 'package:chambeape/infrastructure/datasources/postsdb_datasource.dart';
import 'package:chambeape/infrastructure/repositories/post_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postsRepositoryProvider = Provider((ref) {
  return PostRepositoryImpl(PostsdbDatasource());
});