import 'package:flutter_modular/flutter_modular.dart';

import '../../features/home/data/repositories/mock_posts_repository_impl.dart';
import '../../features/home/data/repositories/posts_repository_impl.dart';
import '../../features/home/domain/usecases/get_post_comments_use_case.dart';
import '../../features/home/domain/usecases/get_posts_use_case.dart';
import '../../features/home/presentation/bloc/posts_bloc.dart';
import '../../features/home/presentation/screen/home_screen.dart';
import '../di/environments.dart';

class PinAppModule extends Module {
  PinAppModule({required this.environment});

  final Environment environment;

  @override
  void binds(Injector i) {
    i.addInstance(
      PostsBloc(
        GetPostsUseCase(
          environment == Environment.mock ? MockPostRepositoryImpl() : PostsRepositoryImpl(),
        ),
        GetPostCommentsUseCase(
          environment == Environment.mock ? MockPostRepositoryImpl() : PostsRepositoryImpl(),
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
  }
}
