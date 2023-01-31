import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_app/firebase_services/storage.dart';
import 'package:instagram_app/models/post.dart';
import 'package:instagram_app/shared/snackbar.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  uploadPost(
      {required imgName,
      required imgPath,
      required description,
      required profileImg,
      required username,
      required context}) async {
    try {
      String url = await getImgURL(
          imgName: imgName,
          imgPath: imgPath,
          folderName: 'imgPosts/${FirebaseAuth.instance.currentUser!.uid}');
      CollectionReference posts =
          FirebaseFirestore.instance.collection('posts');

      String newId = const Uuid().v1();

      PostData postt = PostData(
          datePublished: DateTime.now(),
          description: description,
          imgPost: url,
          likes: [],
          profileImg: profileImg,
          postId: newId,
          uid: FirebaseAuth.instance.currentUser!.uid,
          username: username);

      posts
          .doc(newId)
          .set(postt.convert2Map())
          .then((value) => showSnackBar(context, "Done"))
          .catchError(
              (error) => showSnackBar(context, "Failed to post: $error"));
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, "ERROR :  ${e.code} ");
    } catch (e) {
      showSnackBar(context, "$e");
    }
  }
}
