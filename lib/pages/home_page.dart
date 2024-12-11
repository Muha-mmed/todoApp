import 'package:flutter/material.dart';
import 'package:supa_todo/model/todo.dart';
import 'package:supa_todo/pages/item_list.dart';
import 'package:supa_todo/service/db_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final DataBaseService _dbService = DataBaseService();
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    void addPost() {
      showDialog(
          context: context,
          builder: (context) => AlertDialog.adaptive(
                title: const Text("Add New To-Do"),
                content: Column(
                  children: [
                    TextField(
                      controller: titleController,
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: descriptionController,
                    ),
                  ],
                ),
                actions: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          titleController.clear();
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          if (titleController.value != '') {
                            await _dbService.addTodo(Todo(
                                title: titleController.text,
                                description: descriptionController.text));
                            Navigator.pop(context);
                            titleController.clear();
                          }
                        },
                        child: const Text(
                          "Add",
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
                  )
                ],
              ));
    }

    void update(Todo todo) {
      // Pre-fill the controllers with the existing values of the Todo
      titleController.text = todo.title;
      descriptionController.text = todo.description ?? '';
      showDialog(
          context: context,
          builder: (context) => AlertDialog.adaptive(
                title: const Text("Add New To-Do"),
                content: Column(
                  children: [
                    TextField(
                      controller: titleController,
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: descriptionController,
                    ),
                  ],
                ),
                actions: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          titleController.clear();
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          if (todo.id != null) {
                            _dbService.updateTodo(Todo(
                              id: todo.id, // Pass the existing document ID
                              title: titleController.text,
                              description: descriptionController.text,
                            ));
                            Navigator.pop(context);
                            titleController.clear();
                            descriptionController
                                .clear(); // Clear description as well
                          } else {
                            // Handle the case where the ID is missing
                            print(
                                "Error: Document ID is required to update a todo.");
                          }
                        },
                        child: const Text(
                          "Update",
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
                  )
                ],
              ));
    }

    void delete(Todo todo) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog.adaptive(
                title: const Text("Delete To-Do"),
                content: const Text("Do you want to delete the To-Do"),
                actions: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _dbService.deleteTodo(todo);
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Delete",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  )
                ],
              ));
    }

    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade300,
        title: const Text("SupaBase Todo App"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.amber.shade800,
          onPressed: addPost,
          child: const Icon(Icons.add)),
      body: StreamBuilder<List<Todo>>(
        stream: _dbService.getAllTodo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting for data
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            // Handle errors from the stream
            return Center(
              child: Text('Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red)),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Handle case where there is no data
            return const Center(child: Text("No todos available"));
          }

          final todos = snapshot.data!;
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return ItemList(
                  title: todo.title,
                  description: todo.description!,
                  editPressed: () => update(todo),
                  deletePressed: () => delete(todo));
            },
          );
        },
      ),
    );
  }
}
