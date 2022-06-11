import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/subjects.dart';
import '../constants.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TutorsPage extends StatefulWidget {
  const TutorsPage({Key? key}) : super(key: key);

  @override
  State<TutorsPage> createState() => _TutorsPageState();
}

class _TutorsPageState extends State<TutorsPage> {
   List<Tutors>? tutorList = <Tutors>[];
  String titlecenter = "No Tutors Available";
  late double screenHeight, screenWidth;
  var numofpage, curpage = 1;
  
  @override
  void initState() {
    super.initState();
    _loadTutors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutors'),
      ),
      body: tutorList.isEmpty
      ? Center(
        child: Text(titlecenter,
          style: const TextStyle(
            fontSize: 22, fontWeight: FontWeight.bold,)))
      : Column(),
        children: const [
          const Padding(
            padding: EdgeInsets.fromLTRB(0,10,0,0),
            child: Text("Tutors Available",
              style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
            ),
            Expanded(
              child: GridView.count(
                child: GridView.count(
                  crossAxisCount: 2,
                  children: List.generate(tutorList!.length,(index){
                    return Card(
                      child: Column(
                        children: [
                          Flexible(flex: 6,
                          child: CachedNetworkImage(),
                          )
                          Flexible(child: 4,
                          child: CachedNetworkImage(imageUrl: CONSTANTS.server + "/mytutor2/mobile/assets/tutors" + 
                          tutorList![index]
                          .subjectId
                          .toString()+ '.jpg' ),
                          )
                          fit: BoxFit.cover,
                          width: resWidth,
                          placeholder: (context, url) => 
                            const LinearProgressIndicator(),
                          errorWidget: (context, url, error),
                            const Icon(Icons.error),

                          const SizedBox(height: 10),  
                          Flexible(
                            flex: 4,
                            child: Column(
                              chuldren: [
                                const Text("Name:",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(fontSize: 14)),
                          
                                const SizedBox(height: 10),   
                                const Text("Email:",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(fontSize: 14)),   
                                Text(
                                  tutorList![index]
                                  .tutorEmail
                                  .toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                                  ),

                                const SizedBox(height: 10),   
                                const Text("Phone: ",
                                            textAlign: TextAlign.left,
                                            style: TextStyle(fontSize: 14)),   
                                Text(
                                  tutorList![index]
                                  .tutorPhone
                                  .toString(),
                                  style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                                  ),
                                  ],       
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
            ))))
        ]
      );
  }
}
      

  void _loadTutors(int pageno) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(
        Uri.parse(CONSTANTS.server + "/mytutor2/mobile/php/load_tutors.php"),
        body: {'pageno': pageno.toString()}).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        numofpage = int.parse(jsondata['numofpage']);
        if (extractdata['tutors'] != null) {
          tutorList = <Tutors>[];
          extractdata['tutors'].forEach((v) {
            tutorList!.add(Tutors.fromJson(v));
          });
        }
      }
    });
  }


