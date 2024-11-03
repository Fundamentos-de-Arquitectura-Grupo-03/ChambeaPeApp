import 'package:chambeape/domain/entities/posts_entity.dart';
import 'package:chambeape/infrastructure/models/post_model.dart';

class PostMapper {
  static Post postModelToEntity(PostModel postModel) {
    return Post(
      id: postModel.id,
      title: postModel.title,
      description: postModel.description,
      subtitle: postModel.subtitle,
      imgUrl: postModel.imgUrl,
      employerId: postModel.employerId,
    );
  }

  static PostModel entityToPostModel(Post post) {
    return PostModel(
      id: post.id,
      title: post.title,
      description: post.description,
      subtitle: post.subtitle,
      imgUrl: post.imgUrl,
      employerId: post.employerId,
    );
  }
}
