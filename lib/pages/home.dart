import 'package:book_stash/pages/books.dart';
import 'package:book_stash/service/auth_service.dart';
import 'package:book_stash/service/database.dart';
import 'package:book_stash/utils/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController authorController = TextEditingController();

  Stream? booksStream;

  dynamic getInfoInit() async {
    booksStream = await DatabaseHelper().getAllBooksInfo();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getInfoInit();
  }

  Widget allBooksInfo() {
    return StreamBuilder(
      stream: booksStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
                  return Container(
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.only(bottom: 21),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.book_rounded,
                                  size: 40,
                                  color: Colors.white, // Changed from Colors.deepPurple to white for visibility
                                ),
                                const Spacer(), // Added spacer to push edit icon to the right
                                InkWell(
                                  onTap: () {
                                    titleController.text = documentSnapshot["Title"];
                                    priceController.text = documentSnapshot["Price"];
                                    authorController.text = documentSnapshot["Author"];
                                    editBook(context, documentSnapshot["Id"]); // Fixed: pass context
                                  },
                                  child: const Icon(
                                    Icons.edit_document,
                                    size: 40,
                                    color: Color.fromARGB(255, 195, 192, 243),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    showDeleteConfirmationDialog(context, documentSnapshot["Id"]);
                                  },
                                  child: Icon(Icons.delete_forever,size: 45,color: Colors.greenAccent,)),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Title: ${documentSnapshot["Title"]}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              'Price: ${documentSnapshot["Price"]}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              'Author: ${documentSnapshot["Author"]}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            : const Center(child: CircularProgressIndicator());
      },
    );
  }

  Future editBook(BuildContext context, String id) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: SingleChildScrollView( // Added to prevent overflow
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Added to prevent overflow
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Edit a book',
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.cancel_outlined,
                            size: 35,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Title',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.only(left: 12.0),
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(20)),
                      child: TextField(
                        controller: titleController,
                        decoration: const InputDecoration(border: InputBorder.none),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Price',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.only(left: 12.0),
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(20)),
                      child: TextField(
                        controller: priceController,
                        decoration: const InputDecoration(border: InputBorder.none),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Author',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.only(left: 12.0),
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(20)),
                      child: TextField(
                        controller: authorController,
                        decoration: const InputDecoration(border: InputBorder.none),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                            onPressed: () async {
                              Map<String, dynamic> updateDetails = {
                                "Title": titleController.text,
                                "Price": priceController.text,
                                "Author": authorController.text,
                                "Id": id,
                              };

                              await DatabaseHelper()
                                  .updateBook(id, updateDetails)
                                  .then((value) {
                                Message.show(message: 'Successfully updated!');
                                Navigator.pop(context);
                              });
                            },
                            child: const Text('Update')),
                        OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'))
                      ],
                    )
                  ],
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Stash'),
      actions: [
        IconButton(onPressed: () async {
        await AuthServiceHelper.logout();
        Navigator.pushReplacementNamed(context, "/login");


        }, icon: Icon(Icons.logout_rounded))
      ],),
      body: Container(
        child: Column(
          children: [
            Expanded(child: allBooksInfo()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Books()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
void showDeleteConfirmationDialog(BuildContext context, String id){
  showDialog(context: context, builder: (BuildContext context){
    return AlertDialog(
      title: Text('Confirm Deletion'),
      content: Text('Are you sure you want to delete the book?'),
      actions: [TextButton(onPressed: () async {
        await DatabaseHelper().deleteBook(id);
        Navigator.pop(context);
      }, child: Text('Yes'),
      ),
      TextButton(onPressed: (){
        Navigator.of(context).pop(false);
      }, child: Text('No'),)
      ],
    );
  });
}