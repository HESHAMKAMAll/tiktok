import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok/models/user.dart' as model;
import '../constants.dart';

class AuthController extends ChangeNotifier {
  bool isLoading = false;

// pickImage
  pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      return await _file.readAsBytes();
    }
    print("No image selected");
  }

  // upload to storage
  Future<String> _uploadToStorage(Uint8List image) async {
    Reference reference = await firebaseStorage.ref().child("profilePics").child(firebaseAuth.currentUser!.uid);
    UploadTask uploadTask = reference.putData(image);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  //signUp
  signUp(String username, String email, String password, Uint8List image, BuildContext context) async {
    try {
      isLoading = true;
      if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty && image != null) {
        UserCredential credential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
        String downloadUrl = await _uploadToStorage(image);
        model.User user = model.User(name: username, profilePhoto: downloadUrl, email: email, uid: credential.user!.uid);
        await firestore.collection("users").doc(credential.user!.uid).set(user.toJson());
        // Get.snackbar('Creating Account', 'Creating Account Success');
        isLoading = false;
      } else {
        isLoading = false;
        Get.snackbar('Error Creating Account', 'Please enter all the fields');
      }
    } catch (e) {
      isLoading = false;
      Get.snackbar('Error Creating Account', e.toString());
    }
    notifyListeners();
  }

  //signIn
  signIn(String email, String password, BuildContext context) async {
    try {
      isLoading = true;
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
        // Get.snackbar('Sign In', 'Sign In Success');
        isLoading = false;
      } else {
        isLoading = false;
        Get.snackbar('Error Sign In', 'Please enter all the fields');
      }
    } catch (e) {
      isLoading = false;
      Get.snackbar('Error Sign In', e.toString());
    }
    notifyListeners();
  }

  //Google singIn
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    final cred = await FirebaseAuth.instance.signInWithCredential(credential);
    await firestore.collection("users").doc(cred.user!.uid).set({
      "name": cred.user!.displayName,
      "profilePhoto": cred.user!.photoURL,
      "email": cred.user!.email,
      "uid": cred.user!.uid,
    });

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
