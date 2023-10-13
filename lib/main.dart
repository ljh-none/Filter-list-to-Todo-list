//Floated Button(+) 추가 -> Dialog를 사용하여 할일을 입력
//ListTile 삭제 버튼
//ListTile의 좌측에 체크를 표시하여 완료 여부를 선택
//- 완료가 되면 할일에 대한 텍스트를 10/19 오픈소스프로젝트 과제2(취소선) 처럼 표기
//AppBar에 버튼 추가 -> 완료된 것만 볼수있도록 토글 기능 추가

// main.dart
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, //디버그 배너 제거
        title: '~My Todo List~',
        home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //변수 정의
  // ignore: prefer_final_fields
  List<Map<String, dynamic>> _todoList = [
    {"todo": "과제하기", "isChecked": false},
  ];
  List<Map<String, dynamic>> _showList = []; //화면에 출력 중인 데이터

  //함수 정의
  void _runFilter(String enteredKeyword) {
    //텍스트필드가 변할 때 쓰는 함수
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      //검색창 비었을 때
      results = _todoList;
    } else {
      results = _todoList
          .where((todoList) => todoList["todo"]
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _showList = results;
    });
  }

  @override
  initState() {
    //시작 시 모든 유저 출력
    _showList = _todoList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('~~Todo List~~')),
        body: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(children: [
              const SizedBox(height: 20),
              TextField(
                onChanged: (value) => _runFilter(value),
                decoration: const InputDecoration(
                  labelText: 'Search',
                  suffixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                  child: _showList.isNotEmpty
                      ? ListView.builder(
                          itemCount: _showList.length,
                          itemBuilder: (context, index) => Card(
                            color: Colors.amberAccent,
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: CheckboxListTile(
                                title: Text(_showList[index]['todo']),
                                value: _showList[index]['isChecked'],
                                onChanged: (bool? value) {
                                  setState(() {
                                    _showList[index]['isChecked'] = value;
                                  });
                                }),
                          ),
                        )
                      : const Text('No results found', style: TextStyle(fontSize: 24)))
            ])),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const AlertDialog(
                      title: Text("dialog"),
                      content: Text("Alert!"),
                      actions: []);
                });
          },
        ));
  }
}
