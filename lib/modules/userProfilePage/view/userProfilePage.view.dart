import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserProfilePageView extends StatefulWidget {
  @override
  _UserProfilePageViewState createState() => _UserProfilePageViewState();
}

class _UserProfilePageViewState extends State<UserProfilePageView> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  User? user;
  String? name, email, profilePicUrl;
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    _fetchUserData();
  }

  // Fetch user details from Firestore
  void _fetchUserData() async {
    if (user != null) {
      DocumentSnapshot userData = await _firestore.collection('userCreds').doc(user!.uid).get();
      if(userData.exists && userData.data()!=null){
        var data = userData.data() as Map<String, dynamic>;
        name=data.containsKey('name')?data['name']:"";
        email=data.containsKey('email')?data['email']:"";
        profilePicUrl = data.containsKey('profilePic') ? data['profilePic'] : "";
        print("Profile Picture URL: $profilePicUrl");
      }
    }
  }

  // Pick image from gallery or take a photo
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
      _uploadProfilePicture(_profileImage!);
    }
  }

  //Upload image to Firebase Storage and update Firestore
  Future<void> _uploadProfilePicture(File imageFile) async {
    try {
      File file = File(imageFile.path);
      Reference ref = _storage.ref().child('user_profiles/$user.jpg');
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      _updateProfilePic(downloadUrl);
    } catch (e) {
      print("Error uploading image: $e");
    }
  }



  // Update Firestore with the new profile picture URL
  Future<void> _updateProfilePic(String url) async {
    if (user != null) {
      await _firestore.collection('userCreds').doc(user!.uid).update({'profilePic': url});
      setState(() {
        profilePicUrl = url;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Choose Profile Picture'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: Text('Pick from Gallery'),
                            onTap: () {
                              Navigator.pop(context);
                              _pickImage(ImageSource.gallery);
                            },
                          ),
                          ListTile(
                            title: Text('Take a Photo'),
                            onTap: () {
                              Navigator.pop(context);
                              _pickImage(ImageSource.camera);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!)
                    : profilePicUrl != null
                    ? NetworkImage(profilePicUrl!) as ImageProvider
                    : AssetImage('assets/images/profilepic.webp'),
                child: _profileImage == null && profilePicUrl == null
                    ? Icon(Icons.camera_alt)
                    : Container(),
              ),
            ),
            SizedBox(height: 16),
            Text(name ?? 'Loading...', style: TextStyle(fontSize: 24)),
            Text(email ?? 'Loading...', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
