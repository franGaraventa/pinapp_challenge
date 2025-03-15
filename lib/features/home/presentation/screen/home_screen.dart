import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/modules/data_state.dart';
import '../../../../core/utils/colors.dart';
import '../../../../core/utils/dimensions.dart';
import '../../domain/models/post.dart';
import '../bloc/posts_bloc.dart';
import '../widget/like_icon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PostsBloc postsBloc;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    postsBloc = context.read<PostsBloc>();
    postsBloc.getAllPosts();
  }

  Widget _buildLikeIcon({required int id}) {
    return LikeIcon(onTap: (isEnabled) {});
  }

  Widget _buildPostList({required List<Post> posts}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: CustomPadding.paddingMedium),
      child: ListView.separated(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => Modular.to.pushNamed('/post', arguments: posts[index]),
            child: Container(
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
              child: ListTile(
                title: Text(
                  posts[index].title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ColorTheme.primaryColor,
                  ),
                ),
                subtitle: Text(posts[index].body),
                trailing: _buildLikeIcon(id: posts[index].id),
              ),
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
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorTheme.primaryColor.withOpacity(0.2),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(
                'assets/images/pin_app.svg',
                semanticsLabel: 'PinApp Logo',
              ),
              const Text(
                'Desafio Tecnico',
                style: TextStyle(color: ColorTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 24.0),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            left: CustomPadding.paddingSmall,
            right: CustomPadding.paddingSmall,
            top: CustomPadding.paddingSmall,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(CustomPadding.paddingXSmall),
                child: TextField(
                  controller: _searchController,
                  onChanged: (query) {
                    postsBloc.filter(query: query.toLowerCase());
                  },
                  decoration: const InputDecoration(
                    labelText: 'Buscar Publicacion',
                    prefixIcon: Icon(Icons.search),
                    prefixIconColor: ColorTheme.secondaryColor,
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ColorTheme.primaryColor,
                        width: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: postsBloc.postsStream,
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<DataState<List<Post>>> snapshot,
                  ) {
                    if (snapshot.data is DataLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: ColorTheme.primaryColor,
                        ),
                      );
                    }

                    if (snapshot.data is DataSuccess<List<Post>>) {
                      var data = snapshot.data as DataSuccess<List<Post>>;
                      return data.data!.isNotEmpty ? _buildPostList(posts: data.data!) : _buildEmptyState();
                    }

                    return const SizedBox.shrink();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
