import 'allpackages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: 'AIzaSyAoTEzShnfARBXt6oss8cGuoQZlpPBfkmU',
        projectId: 'videoplayer-7dce8',
        messagingSenderId: '14214273551',
        appId: '1:14214273551:android:9124ea032deeb4fdeb617a',
        storageBucket: 'videoplayer-7dce8.appspot.com'),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: BlocProviders().provider,
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: LandingPage()));
  }
}
