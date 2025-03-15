import 'package:flutter_modular/flutter_modular.dart';

import '../../features/home/data/datasources/local/favorites_local_datasource_impl.dart';
import '../../features/home/data/repositories/impl/favorite_repository_impl.dart';
import '../../features/home/data/repositories/impl/mock_posts_repository_impl.dart';
import '../../features/home/data/repositories/impl/posts_repository_impl.dart';
import '../../features/home/domain/usecases/get_post_comments_use_case.dart';
import '../../features/home/domain/usecases/get_posts_use_case.dart';
import '../../features/home/presentation/bloc/favorites_bloc.dart';
import '../../features/home/presentation/bloc/posts_bloc.dart';
import '../../features/home/presentation/screen/home_screen.dart';
import '../../features/home/presentation/screen/post_comments_screen.dart';
import '../di/environments.dart';

class PinAppModule extends Module {
  PinAppModule({required this.environment});

  final Environment environment;

  @override
  void binds(Injector i) {
    var mockPostRepository = MockPostRepositoryImpl();
    var latestPostRepository = PostsRepositoryImpl(baseUrl: Environment.latest.url);

    i.addInstance(
      FavoritesBloc(
        FavoriteRepositoryImpl(
          favoriteDatasource: FavoritesLocalDatasourceImpl(),
        ),
      )..initialize(),
    );
    i.addInstance(
      PostsBloc(
        GetPostsUseCase(
          environment == Environment.mock ? mockPostRepository : latestPostRepository,
        ),
        GetPostCommentsUseCase(
          environment == Environment.mock ? mockPostRepository : latestPostRepository,
        ),
      ),
      config: BindConfig<PostsBloc>(
        onDispose: (bloc) => bloc.dispose(),
      ),
    );
  }

  @override
  void routes(RouteManager r) {
    r.child(
      '/',
      child: (context) => const HomeScreen(),
    );
    r.child(
      '/post',
      child: (context) => PostCommentsScreen(post: r.args.data),
    );
  }
}
