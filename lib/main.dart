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
      title: 'Kindacode.com',
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
  List<Map<String, dynamic>> _todoList = [
    {"todo": "Andy", "bool": false},
    {"todo": "Aragon", "bool": false},
    {"todo": "Bob", "bool": false},
    {"todo": "Barbara", "bool": false},
    {"todo": "Candy", "bool": false},
    {"todo": "Colin", "bool": false},
    {"todo": "Audra", "bool": false},
    {"todo": "Banana", "bool": false},
    {"todo": "Caversky", "bool": false},
    {"todo": "Becky", "bool": false},
  ];

  List<Map<String, dynamic>> _showList = [];

  final txtcon = TextEditingController();

  @override
  initState() {
    _showList = _todoList;
    super.initState();
  }

  void _runFilter(String enteredKeyword) {
    //필터 동작 함수
    List<Map<String, dynamic>> results = [];
    results = enteredKeyword.isEmpty
        ? _todoList
        : _todoList
            .where((value) => value["todo"]
                .toLowerCase()
                .contains(enteredKeyword.toLowerCase()))
            .toList();

    setState(() => _showList = results);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kindacode.com'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
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
                        //key: ValueKey(_showList[index]["id"]),
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
                          title: Text(_showList[index]['todo']),
                          trailing: ElevatedButton(
                            child: const Text("X"),
                            onPressed: () {
                              _showList.removeAt(index);
                              setState(() => _todoList = _showList);
                            },
                          ),
                        ),
                      ),
                    )
                  : const Text('No results found',
                      style: TextStyle(fontSize: 24)),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Text("+"),
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Insert Todo"),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextField(controller: txtcon),
                    ElevatedButton(
                      child: const Text("Input Todo"),
                      onPressed: () {
                        Map<String, dynamic> item = {
                          "todo": txtcon.text,
                          "bool": false,
                        };
                        _showList.add(item);
                        _todoList = _showList;
                        txtcon.clear();
                      },
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    child: const Text("Close"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}
