import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ***************** Sign Up *****************
  Future<User?> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // إنشاء مستخدم جديد
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // نخزن الاسم (اختياري)
      await cred.user?.updateDisplayName(name);

      return cred.user;
    } on FirebaseAuthException catch (e) {
      // نطبع الخطأ الحقيقي عالكونسول
      print('🔥 [AuthService.signUp] code: ${e.code}');
      print('🔥 [AuthService.signUp] message: ${e.message}');
      rethrow; // نرجع الخطأ عشان الكود فوق يقدر يعرضه
    } catch (e) {
      print('🔥 [AuthService.signUp] unexpected error: $e');
      rethrow;
    }
  }

  // ***************** Sign In *****************
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user;
    } on FirebaseAuthException catch (e) {
      print('🔥 [AuthService.signIn] code: ${e.code}');
      print('🔥 [AuthService.signIn] message: ${e.message}');
      rethrow;
    } catch (e) {
      print('🔥 [AuthService.signIn] unexpected error: $e');
      rethrow;
    }
  }

  // *************** Reset Password ***************
  Future<void> sendResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      print('🔥 [AuthService.sendResetEmail] code: ${e.code}');
      print('🔥 [AuthService.sendResetEmail] message: ${e.message}');
      rethrow;
    } catch (e) {
      print('🔥 [AuthService.sendResetEmail] unexpected error: $e');
      rethrow;
    }
  }
}
