import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'comment_page.dart';

class FeedWidget extends StatefulWidget {
  final DocumentSnapshot document;
  final FirebaseUser user;

  FeedWidget(this.document, this.user);

  @override
  _FeedWidgetState createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var comment = widget.document['comment'] ?? 0;
    return Column(
      children: <Widget>[
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(widget.document['userPhotoUrl']),
          ),
          title: Text(
            widget.document['email'],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          trailing: Icon(Icons.more_vert),
        ),
        Image.network(
          widget.document['photoUrl'],
          height: 300,
          // double.infinity : 화면을 꽉채운다
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        ListTile(
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // ?. 오류뜨면 null로 ??null이면 false로
              widget.document['likedUser']?.contains(widget.user.email)?? false
              // true면 이쪽
              ? GestureDetector(
              onTap: _unlike,
              child: Icon(Icons.favorite,color: Colors.red,))

              // false면 이쪽으로감
              : GestureDetector(
                  onTap: _like,
                  child: Icon(Icons.favorite_border,)),


              SizedBox(
                width: 8.0,
              ),
              Icon(Icons.comment),
              SizedBox(
                width: 8.0,
              ),
              Icon(Icons.send),
            ],
          ),
          trailing: Icon(Icons.bookmark_border),
        ),
        Row(
          children: <Widget>[
            SizedBox(
              width: 16.0,
            ),
            Text(
              // ?. -> 오류가 뜨면 null을 반환하고 ?? null이면 0개를 반환해라
              '좋아요 ${widget.document['likedUser']?.length ?? 0}개',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
            ),
          ],
        ),
        SizedBox(
          height: 8.0,
        ),
        Row(
          children: <Widget>[
            SizedBox(
              width: 16.0,
            ),
            Text(
              widget.document['email'],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 8.0,
            ),
            Text(widget.document['contents']),
          ],
        ),
        SizedBox(
          height: 8.0,
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CommentPage(widget.document),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      '댓글 $comment개 모두 보기',
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ],
                ),
                Text(widget.document['lastComment'] ?? ''),
              ],
            ),
          ),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: TextField(
                  controller: _commentController,
                  onSubmitted: (text) {
                    _writeComment(text);
                    _commentController.text = '';
                  },
                  decoration: InputDecoration(
                    hintText: '댓글 달기',
                  ),
                ),
              ),
            ),
          ],
        ),
        Divider(),
      ],
    );
  }

  // 좋아요
  void _like() {
    // 기존 좋아요 array(리스트) 가져오기
    final List likedUsers =
        List<String>.from(widget.document['likedUser'] ?? []);
    // 나를 추가, 내가 좋아요를 눌러야 이 메소드가 호출되니깐
    likedUsers.add(widget.user.email);

    // 업데이트할 항목 문서로
    final _updateData = {
      'likedUser': likedUsers,
    };

    Firestore.instance
        .collection('post')
        .document(widget.document.documentID)
        //setdata를 하면 다 날아감.. -> updataData는 "그 부분만" 업데이트를 하겠다라는 메소드
        .updateData(_updateData);
  }

  // 좋아요 취소
  void _unlike() {
    // 기존 좋아요 array(리스트) 가져오기
    final List likedUsers =
    List<String>.from(widget.document['likedUser'] ?? []);
    // 나를 추가, 내가 좋아요를 눌러야 이 메소드가 호출되니깐
    likedUsers.remove(widget.user.email);

    // 업데이트할 항목 문서로
    final _updateData = {
      'likedUser': likedUsers,
    };

    Firestore.instance
        .collection('post')
        .document(widget.document.documentID)
    //setdata를 하면 다 날아감.. -> updataData는 "그 부분만" 업데이트를 하겠다라는 메소드
        .updateData(_updateData);

  }

  // 댓글 작성
  void _writeComment(String text) {}
}
