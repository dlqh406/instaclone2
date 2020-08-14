import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'create_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'detail_post_page.dart';

class SearchPage extends StatelessWidget {
  final FirebaseUser user;
  SearchPage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(
        'Instagram Clone',
        style: GoogleFonts.pacifico(),
      ),
    );
  }

  Widget _buildBody(context) {
    print('search_page created');
    return Scaffold(
      // firestore에서 특정하여 데이터를 가져올 경우, QuerySnapshot 을 가져옴
      body: StreamBuilder<QuerySnapshot>(
        // path('post')는 왼쪽에서 첫번째
        stream: Firestore.instance.collection('post').snapshots(),
        // stream을 통해서 path가 'post'인 데이터 전체가 아래 snapshot으로 들어감
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            // 데이터가 없으면 progressbar 반복
            return Center(child:  CircularProgressIndicator(),);
          }
          print("data: ");
          print(snapshot.data.documents.length);
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                // 가로 세로 비율
                childAspectRatio: 1.0,
                // grid간 간격
                mainAxisSpacing: 1.0,
                crossAxisSpacing: 1.0),
            // documents는 firestore 에서 왼쪽에서 3번째
            // 데이터가 다 들어가있는 리스트 [{text, greentea, test@test.com, asadsad},{...}]
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildListItem(context, snapshot.data.documents[index]);

            },
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.create),
        onPressed: () {
          print('눌림');
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => CreatePage()));
        },
      ),
    );

  }// snap.data.documents로 받아온 데이터를 파라미터로 쓸땐 DocumentSnapshot 데이터 타입을 붙여줘야함
  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return InkWell(
      onTap: (){
         Navigator.push(
         context, MaterialPageRoute(builder: (context) => DetailPostPage(document, user)),
         );
      },
      child: Image.network(document['photoUrl'],
        fit: BoxFit.cover,
      ),
    );
  }
}
