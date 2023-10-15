// 교안의 Filterd List View를 사용하여 다음과 같은 Todo List를 완성
// Floated Button(+)를 추가할 것- Dialog를 사용하여 할일을 입력
// ListTile에 삭제 버튼을 추가. ListTile의 좌측에 체크를 표시하여 완료 여부를 선택
// 완료가 되면 할일에 대한 텍스트에 취소선
// AppBar에 버튼을 추가하여 완료된 것만 볼수있도록 토글 기능을 추가

// main.dart
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, //디버그 배너 제거
      title: 'myTodoList',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //할 일 저장 리스트, bool값은 체크리스트 상태 저장용
  List<Map<String, dynamic>> _todoList = [
    {"todo": "과제 제출", "bool": false},
    {"todo": "술 약속", "bool": false},
    {"todo": "분리수거 하기", "bool": false},
  ];

  List<Map<String, dynamic>> _showList = []; //필터를 위한 출력 전용 리스트

  final txtcon = TextEditingController(); //Dialog의 텍스트필드 컨트롤러
  List<bool> isSelected = [false, false, false]; //Appbar의 토글버튼 상태
  
  @override
  initState() {
    //초기화
    _showList = _todoList;
    super.initState();
  }

  void _runFilter(String enteredKeyword) {
    //필터 동작 함수
    List<Map<String, dynamic>> results = [];
    results = enteredKeyword.isEmpty
        ? _todoList //textfield가 비었을 때 동작
        : _todoList //textfield에 값이 입력되었을 때 동작
            .where((value) => value["todo"]
                .toLowerCase()
                .contains(enteredKeyword.toLowerCase()))
            .toList();

    setState(() => _showList = results);
  }

  void _toggleFilter(var tog, bool check) {
    //토글버튼 클릭 시 동작 함수
    List<Map<String, dynamic>> results = [];
    //check 검사 이유 : 같은 토글버튼 2번 클릭시 동작을 else에 정의하기 위해
    if (tog == 0 && check == true) {
      //전체
      results = _todoList;
    } else if (tog == 1 && check == true) {
      //완료
      results = _todoList.where((value) => value["bool"] == true).toList();
    } else if (tog == 2 && check == true) {
      //미완료
      results = _todoList.where((value) => value["bool"] == false).toList();
    } else {
      results = _todoList;
    }
    setState(() => _showList = results);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Todo List'),
        actions: [
          ToggleButtons(
            isSelected: isSelected,
            selectedColor: Colors.white,
            children: const [
              Text("전체"),
              Text("완료"),
              Text("미완료"),
            ],
            onPressed: (index) {
              //index=눌린 버튼의 인덱스
              for (int i = 0; i < 3; i++) {
                if (i == index) {
                  //눌린 버튼에 해당되는 filter 작동
                  isSelected[i] = !isSelected[i];
                  _toggleFilter(i, isSelected[i]);
                } else {
                  //나머지 버튼은 선택상태 해제
                  isSelected[i] = false;
                }
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(height: 20),
            TextField(
              //검색 필터
              onChanged: (value) => _runFilter(value),
              decoration: const InputDecoration(
                labelText: 'Search',
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _showList.isNotEmpty
                  //출력용 리스트가 비어있지 않으면
                  ? ListView.builder(
                      itemCount: _showList.length,
                      itemBuilder: (context, index) => Card(
                        color: Colors.amberAccent,
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          leading: Checkbox(
                            value: _showList[index]['bool'],
                            onChanged: (value) {
                              _showList[index]['bool'] = value;
                              setState(() => _todoList = _showList);
                            },
                          ),
                          title: _showList[index]['bool'] //체크 시 취소선 추가
                              //체크 상태(true)라면
                              ? Text(
                                  _showList[index]['todo'],
                                  style: const TextStyle(
                                      decoration: TextDecoration.lineThrough),
                                )
                              //체크 해제 상태(false)라면
                              : Text(_showList[index]['todo']),
                          trailing: ElevatedButton(
                            //삭제 버튼
                            child: const Text("X"),
                            onPressed: () {
                              _showList.removeAt(index);
                              setState(() => _todoList = _showList);
                            },
                          ),
                        ),
                      ),
                    )
                  //출력용 리스트가 비어있으면
                  : const Text('No results found',
                      style: TextStyle(fontSize: 24)),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Text("+"),
        onPressed: () {
          //클릭 시 다이얼로그 출력
          showDialog(
            context: context,
            barrierDismissible: false, //다이얼로그 바깥 클릭 시 탈출 방지
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("할 일 입력"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(controller: txtcon),
                    ElevatedButton(
                      //추가 버튼
                      child: const Text("추가하기"),
                      onPressed: () {
                        Map<String, dynamic> item = {
                          "todo": txtcon.text,
                          "bool": false
                        };
                        _showList.add(item);
                        txtcon.clear();
                        setState(() => _todoList = _showList);
                      },
                    ),
                  ],
                ),
                actions: [
                  //닫기 버튼
                  ElevatedButton(
                    child: const Text("닫기"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
