import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_app/firebase_services/storage.dart';
import 'package:instagram_app/models/user_info.dart';
import 'package:instagram_app/shared/snackbar.dart';

class AuthMethods {
  register({
    required email,
    required password,
    required context,
    required title,
    required username,
    required imgName,
    required imgPath,
  }) async {
    String message = "ERROR => Not starting the code";

    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      message = "ERROR => Registered only";
      String url = await getImgURL(
          imgName: imgName, imgPath: imgPath, folderName: 'profileImg');

      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      UserDate userr = UserDate(
          email: email,
          password: password,
          title: title,
          username: username,
          profileImg: url,
          uid: credential.user!.uid,
          followers: [],
          following: []);

      users
          .doc(credential.user!.uid)
          .set(userr.convert2Map())
          .then((value) => showSnackBar(context, "User Added"))
          .catchError(
              (error) => showSnackBar(context, "Failed to add user: $error"));

      message = " Registered & User Added 2 DB ♥";
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, "ERROR :  ${e.code} ");
    } catch (e) {
      showSnackBar(context, "ERROR :  $e");
    }

    showSnackBar(context, message);
  }

  signIn({required email, required password, required context}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, "ERROR :  ${e.code} ");
    } catch (e) {
      showSnackBar(context, "ERROR :  $e");
    }
  }

  // functoin to get user details from Firestore (Database)
  Future<UserDate> getUserDetails() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    return UserDate.convertSnap2Model(snap);
  }
}
