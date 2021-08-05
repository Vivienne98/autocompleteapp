import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:substring_highlight/substring_highlight.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

 class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  late List<String> autoCompleteData;
  late TextEditingController controller;

  Future fetchAutoCompleteData() async {
    setState(() {
      isLoading = true;
    });
    final String stringData = await rootBundle.loadString("assets/data.json");

    final List<dynamic> json = jsonDecode(stringData);
    final List<String> jsonStringData = json.cast<String>();
    setState(() {
      isLoading = false;
      autoCompleteData = jsonStringData;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAutoCompleteData();
    //this fetches the  "AutoComplete"
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        backgroundColor: Colors.green[300],
        title: Text(
          'AUTO COMPLETER APP',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      backgroundColor: Colors.black12,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Autocomplete(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<String>.empty();
                    } else {
                      return autoCompleteData.where((word) => word
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase()));
                    }
                  }, optionsViewBuilder: (context, Function(String) onSelected, options) {
                    return Material(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(8.0),
                        elevation: 4.0,
                        child: ListView.separated(
                            padding: const EdgeInsets.symmetric(),
                            //this is used used to iterate a list and work with the variable index
                            //of the list.
                            itemBuilder: (context, index) {
                              final option = options.elementAt(index);

                              return ListTile(
                                //title: Text(option.toString()
                                title: SubstringHighlight(text: option.toString(),
                                term: controller.text,
                                      textStyleHighlight: TextStyle(color: Colors.greenAccent, 
                                      fontWeight: FontWeight.w700)),
                                subtitle: Text(
                                     'Subtitle',
                                      style: TextStyle(
                                      color: Colors.yellowAccent[100]),
                                ),
                                onTap: () {
                                     onSelected(option.toString());
                                },
                                // here we convert the list of data.json file toString();
                              );
                            },
                            separatorBuilder: (context, index) =>
                                Divider(), // this divides and separates
                            //the list of elements in a list.
                               itemCount: options.length));
                             }, 
                            onSelected: (selectedString) {
                          print(selectedString);
                          //this helps us print out  selected texts!
                            }, 
                 fieldViewBuilder:
                  (context, controller, focusNode, onEditingcomplete) {
                    //onEditingComplete is just  avoid call back that you just have to pass in
                    //you textstring to ... nothing more!
                       this.controller = controller; 

                    return TextField(
                       controller: controller,
                       focusNode: focusNode,
                       onEditingComplete: onEditingcomplete,
                       decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.black38),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.black38),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.black38),
                        ),
                        hintText: ('Search Word'),
                        hintStyle: (TextStyle(
                        color: Colors.white, fontStyle: FontStyle.italic)),
                        prefixIcon: Icon(
                          Icons.search_sharp,
                          color: Colors.black,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
    );
  }
}
