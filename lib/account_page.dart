import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AccountPage extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseUser user;
  AccountPage(this.user);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          _buildProfile(),
        ],
      ),
    );
  }

  Widget _buildProfile() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                SizedBox(
                  width: 80.0,
                  height: 80.0,
                  child: GestureDetector(
                    onTap: () => print('이미지 클릭'),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(user.photoUrl),
                    ),
                  ),
                ),
                Container(
                  width: 80.0,
                  height: 80.0,
                  alignment: Alignment.bottomRight,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 28.0,
                        height: 28.0,
                        child: FloatingActionButton(
                          onPressed: null,
                          backgroundColor: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 25.0,
                        height: 25.0,
                        child: FloatingActionButton(
                          backgroundColor: Colors.blue,
                          onPressed: null,
                          child: Icon(Icons.add),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Text(
              user.displayName,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            '0\n게시물',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18.0),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            '0\n팔로워',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18.0),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            '0\n팔로잉',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.exit_to_app),
          color: Colors.black,
          onPressed: () {
            // 로그아웃
            FirebaseAuth.instance.signOut();
            _googleSignIn.signOut();
          },
        )
      ],
      backgroundColor: Colors.white,
      title: Text(
        'Instagram Clone',
        style: GoogleFonts.pacifico(),
      ),
    );
  }

  // 내 게시물 가져오기,
  // 한개의 데이터를 가져올때는 DocumentSnapshot
  // 여러개의 데이터를 가져올떄는 QuerySnapshot
//Stream<QuerySnapshot>

  // 팔로잉 가져오기

  // 팔로워 가져오기
}
