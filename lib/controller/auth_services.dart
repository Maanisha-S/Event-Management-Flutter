import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  static Future<String> createAccountWithEmail(
      String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return 'Account Created';
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

  static Future<String> loginWithEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return 'login Successfully';
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

  static  Future logout() async {
    await FirebaseAuth.instance.signOut();
  }
  static Future<String?> getCurrentUserId() async {
    final User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

}