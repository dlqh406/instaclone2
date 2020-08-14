import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'loading_page.dart';
import 'login_page.dart';
import 'tab_page.dart';

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('root_page created');
    return _handleCurrentScreen();
  }

  Widget _handleCurrentScreen() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          // 로딩시 progress bar 보이게됨 +1.0 에서 업그레이드됨
          if(snapshot.connectionState == ConnectionState.waiting){
           return LoadingPage();
          }else{
            if(snapshot.hasData){
              //snapshot.data에 오류가 뜬다면 TabPage가 데이터를 받을 객체가 없다는 것
              return TabPage(snapshot.data);
            }
            return LoginPage();
          }
      }
    );
  }
}
