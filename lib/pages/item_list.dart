import 'package:flutter/material.dart';

class ItemList extends StatelessWidget {
  final String title;
  final String description;
  final void Function()? editPressed;
  final void Function()? deletePressed;
  const ItemList({
    super.key,
    required this.title,
    this.description = '',
    required this.editPressed,
    required this.deletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(description, overflow: TextOverflow.ellipsis),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: editPressed,
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: deletePressed,
            icon: const Icon(
              Icons.delete_forever,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
