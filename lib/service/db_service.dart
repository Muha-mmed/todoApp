import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supa_todo/model/todo.dart';

class DataBaseService {
  final CollectionReference _todosCollection =
      FirebaseFirestore.instance.collection('todos');

  Future<void> addTodo(Todo todo) {
    return _todosCollection.add(todo.toMap());
  }

  Stream<List<Todo>> getAllTodo() {
    return _todosCollection.snapshots().map((snapShot) => snapShot.docs
        .map((doc) => Todo.fromMap(doc.data() as Map<String, dynamic>)
            .copyWith(id: doc.id))
        .toList());
  }

  Future<void> updateTodo(Todo todo) {
    return _todosCollection.doc(todo.id.toString()).update(todo.toMap());
  }

  Future<void> deleteTodo(Todo todo) {
    return _todosCollection.doc(todo.id.toString()).delete();
  }
}
