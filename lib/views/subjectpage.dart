import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/subjects.dart';
import '../constants.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SubjectPage extends StatefulWidget {
  const SubjectPage({Key? key}) : super(key: key);

  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  List<Subjects>? SubjectList = <Subjects>[];
  String titlecenter = "No Subject Available";
  late double screenHeight, screenWidth;
  var numofpage, curpage = 1;
  
  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Subjects'),
      ),
      body: SubjectList.isEmpty
      ? Center(
        child: Text(titlecenter,
          style: const TextStyle(
            fontSize: 22, fontWeight: FontWeight.bold,)))
      : Column(),
        children: const [
          const Padding(
            padding: EdgeInsets.fromLTRB(0,10,0,0),
            child: Text("Subjects Available",
              style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
            ),
            Expanded(
              child: GridView.count(
                child: GridView.count(
                  crossAxisCount: 2,
                  children: List.generate(scrollcount, (index){
                    return Card(
                      child: Column(
                        children: [
                          Flexible(flex: 6,
                          child: CachedNetworkImage(),
                          )
                          Flexible(child: 4,
                          child: CachedNetworkImage(imageUrl: "http://10.31.127.203/mytutor2/mobile/assets/courses" + 
                          SubjectList[index]
                          .subjectId
                          .toString()+ '.jpg' ),
                          )
                          fit: BoxFit.cover,
                          width: resWidth,
                          placeholder: (context, url) => 
                            const LinearProgressIndicator(),
                          errorWidget: (context, url, error),
                            const Icon(Icons.error),
                            
                          Flexible(
                            flex: 4,
                            child: Column(
                              chuldren: [
                                Text(
                                  SubjectList![index]
                                  .subjectName
                                  .toString() + 
                                  "Name",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                                  ),

                                Text(
                                  SubjectList![index]
                                  .subjectSessions
                                  .toString() + 
                                  "Sessions",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                                  ),

                                Text("RM " +
                                  double.parse(SubjectList[index]
                                    .subjectPrice
                                    .toString())
                                    .toStringAsFixed(2)
                                  style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                                  ),
                                Text(
                                  SubjectList![index]
                                  .subjectRating
                                  .toString() + 
                                  "Rating",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                                  ),
                                  ]       
                                ),
                              ),
                            ],
                          )
                        );
                }))),
            SizedBox(
                  height: 30,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: numofpage,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      if ((curpage - 1) == index) {
                        color = Colors.amber;
                      } else {
                        color = Colors.white;
                      }
                      return SizedBox(
                        width: 40,
                        child: TextButton(
                            onPressed: () => {_loadTutors(index + 1)},
                            child: Text(
                              (index + 1).toString(),
                              style: TextStyle(color: color),
                                    )),  
                           )}
                    ))
            )
          )
        ]
      );
  }
}
      

  void _loadSubjects(int pageno) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(
        Uri.parse(CONSTANTS.server + "/mytutor2/mobile/php/load_subjects.php"),
        body: {'pageno': pageno.toString()}).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        numofpage = int.parse(jsondata['numofpage']);
        if (extractdata['subjects'] != null) {
          SubjectList = <Subjects>[];
          extractdata['subjects'].forEach((v) {
            SubjectList!.add(Subjects.fromJson(v));
          });
        }
      }
    });
  }

