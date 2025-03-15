import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../../core/modules/data_state.dart';
import '../../../../core/utils/colors.dart';
import '../../../../core/utils/dimensions.dart';
import '../../domain/models/comment.dart';
import '../../domain/models/post.dart';
import '../bloc/favorites_bloc.dart';
import '../bloc/posts_bloc.dart';
import '../widget/like_icon.dart';

class PostCommentsScreen extends StatefulWidget {
  const PostCommentsScreen({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  State<PostCommentsScreen> createState() => _PostCommentsScreenState();
}

class _PostCommentsScreenState extends State<PostCommentsScreen> {
  static const noCommentsImageRoute = 'assets/images/no_comments_image.png';
  static const noCommentsMsg = 'El post no contiene comentarios';

  late PostsBloc postsBloc;
  late FavoritesBloc favoritesBloc;

  @override
  void initState() {
    super.initState();
    postsBloc = context.read<PostsBloc>();
    favoritesBloc = context.read<FavoritesBloc>();

    postsBloc.getPostComments(id: widget.post.id);
    favoritesBloc.isFavorite(id: widget.post.id);
  }

  Widget _buildCommentList({required List<Comment> comments}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: CustomPadding.paddingMedium),
      child: ListView.separated(
        itemCount: comments.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(CustomBorderRadius.borderRadiusSmall),
              border: Border.all(color: ColorTheme.primaryColor),
              boxShadow: [
                BoxShadow(
                  color: ColorTheme.primaryColor.withOpacity(0.4),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(
                    comments[index].name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ColorTheme.primaryColor,
                    ),
                  ),
                  subtitle: Text(
                    comments[index].email,
                    style: const TextStyle(color: Colors.black38),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: CustomPadding.paddingXMedium,
                    right: CustomPadding.paddingXMedium,
                    bottom: CustomPadding.paddingXXMedium,
                  ),
                  child: Text(
                    comments[index].body,
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: CustomPadding.paddingXXMedium);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            noCommentsImageRoute,
            scale: 2.0,
          ),
          const Text(
            noCommentsMsg,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: ColorTheme.primaryColor,
              fontSize: 18.0,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorTheme.primaryColor.withOpacity(0.2),
          leading: InkWell(
            onTap: () => Modular.to.pop(),
            child: const Icon(
              Icons.arrow_back_ios,
              color: ColorTheme.primaryColor,
              size: 20.0,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: CustomPadding.paddingXXMedium),
              child: StreamBuilder<bool>(
                stream: favoritesBloc.favoritesStream,
                builder: (context, snapshot) {
                  return LikeIcon(
                    onTap: (enabled) => favoritesBloc.toggleFavorite(id: widget.post.id),
                    isEnabled: snapshot.hasData ? snapshot.data! : false,
                  );
                },
              ),
            )
          ],
          title: Text(
            widget.post.title.toUpperCase(),
            maxLines: 3,
            style: const TextStyle(
              color: ColorTheme.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 12.0,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(CustomPadding.paddingXXMedium),
          child: StreamBuilder(
            stream: postsBloc.postCommentStream,
            builder: (
              BuildContext context,
              AsyncSnapshot<DataState<List<Comment>>> snapshot,
            ) {
              if (snapshot.data is DataLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: ColorTheme.primaryColor,
                  ),
                );
              }

              if (snapshot.data is DataSuccess<List<Comment>>) {
                var data = snapshot.data as DataSuccess<List<Comment>>;
                return data.data!.isNotEmpty ? _buildCommentList(comments: data.data!) : _buildEmptyState();
              }

              if (snapshot.data is DataFailed) {
                return _buildEmptyState();
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
