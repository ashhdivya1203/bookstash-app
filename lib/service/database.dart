import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseHelper{
  Future addBookDetails(Map<String,dynamic>bookInfoMap, String Id) async {
    return await FirebaseFirestore.instance.collection("Books").doc(Id).set(bookInfoMap);
  }

Future<Stream<QuerySnapshot>>getAllBooksInfo() async{
  return FirebaseFirestore.instance.collection("Books").snapshots();
}

Future updateBook(String id,Map<String,dynamic>updateDetails) async {
  return await FirebaseFirestore.instance.collection("Books").doc(id).update(updateDetails);
}

Future deleteBook(String id) async{
  return await FirebaseFirestore.instance.collection("Books").doc(id).delete();
}

}