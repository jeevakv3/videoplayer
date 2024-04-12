import '../../allpackages.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return user == null ? Login() : Login();
  }
}
