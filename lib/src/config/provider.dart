import '../../allpackages.dart';

class BlocProviders {
  List<BlocProvider> provider = [
    BlocProvider<LoginBloc>(
      create: (context) => LoginBloc(),
    ),
  ];
}
