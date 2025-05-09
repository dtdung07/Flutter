import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(MaterialApp(home: MyApp(), debugShowCheckedModeBanner: false));
}

class Todo {
  int? id;
  String? tenCongViec;

  Todo(this.id, this.tenCongViec);
}

Todo themCongViec(int id, String tenCongViec) {
  Todo congViecMoi = Todo(id, tenCongViec);
  danhSachCongViec.add(congViecMoi);
  return congViecMoi;
}

void xoaCongViec(int? id) {
  if (id != null) danhSachCongViec.removeWhere((congViec) => congViec.id == id);
}

String inputText = "";
int demId = 0;
List<Todo> danhSachCongViec = [];

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Color(0xffF2F2F2),
        appBar: AppBar(
          title: Text(
            "Todo List",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xffFFFFFF),
              fontSize: 40,
            ),
          ),
          centerTitle: true,
          backgroundColor: Color(0xff2196F3),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ...danhSachCongViec.map((congViec){
              //   return CardBody(congViec.id, congViec.tenCongViec);
              // }).toList();
              for (var congViec in danhSachCongViec)
                CardBody(
                  congViec.id,
                  congViec.tenCongViec!,
                  onDelete: () {
                    xoaCongViec(congViec.id!);
                    setState(() {});
                  },
                ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Container(
                    height: 200,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color(0xffF2F2F2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          TextField(
                            onChanged: (value) {
                              inputText = value;
                              print(inputText);
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Color(0xff2196F3),
                                  width: 2,
                                ),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              hintText: "Input Name",
                              hintStyle: TextStyle(color: Color(0xffB0B0B0)),
                              prefixIcon: Icon(
                                Icons.task,
                                color: Color(0xff2196F3),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                demId++;
                                if (inputText != "") {
                                  themCongViec(demId, inputText);
                                  setState(() {});
                                }
                              },
                              child: Text(
                                "Add Task",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xffFFFFFF),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: Color(0xff2196F3),
                                padding: EdgeInsets.all(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
          child: Icon(Icons.add, size: 40, color: Colors.white),
          backgroundColor: Color(0xff2196F3),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
    );
  }
}

class CardBody extends StatelessWidget {
  final int? id;
  final String tenCongViec;
  final VoidCallback onDelete;

  CardBody(this.id, this.tenCongViec, {required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 27, vertical: 22),
      margin: EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: id! % 2 == 0 ? Color(0xffDFDFDF) : Color(0xffD6FFF8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            tenCongViec,
            style: TextStyle(
              color: Color(0xff4B4B4B),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: Icon(
              Icons.delete_outline,
              size: 30,
              color: Color(0xff5B5959),
            ),
          ),
        ],
      ),
    );
  }
}
