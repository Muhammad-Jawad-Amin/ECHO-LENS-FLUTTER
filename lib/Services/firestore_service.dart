import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:echo_lens/Models/user_model.dart';
import 'package:echo_lens/services/auth_service.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _auth = AuthService();

  // Store image URL and caption in Firestore
  Future<void> saveCaption(String imageUrl, String caption) async {
    await _firestore
        .collection('users')
        .doc(_auth.getuserId())
        .collection('captions')
        .add({
      'image_url': imageUrl,
      'caption': caption,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Fetch captions for a user
  Stream<QuerySnapshot> getCaptions() {
    return _firestore
        .collection('users')
        .doc(_auth.getuserId())
        .collection('captions')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> saveUserData(
    Map<String, dynamic> userdata,
  ) async {
    DocumentReference userDoc =
        _firestore.collection('users').doc(_auth.getuserId());
    await userDoc.set(userdata, SetOptions(merge: true));
  }

  Future<UserModel> getuserData() async {
    DocumentSnapshot docSnapshot =
        await _firestore.collection('users').doc(_auth.getuserId()).get();
    var userdata = docSnapshot.data() as Map<String, dynamic>;
    UserModel usermodeldata = UserModel.fromFirestore(userdata);
    return usermodeldata;
  }

  Future<bool> isUserDataExists(String userId) async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      return docSnapshot.exists;
    } catch (e) {
      return false;
    }
  }
}
