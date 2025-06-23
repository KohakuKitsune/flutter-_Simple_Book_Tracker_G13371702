import 'package:flutter/material.dart';
import '../main.dart';

class BookTile extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;

  const BookTile({required this.book, required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.indigo[50],
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: book.imageUrl != null && book.imageUrl!.isNotEmpty
            ? ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            book.imageUrl!,
            width: 50,
            height: 70,
            fit: BoxFit.cover,
          ),
        )
            : Icon(Icons.menu_book_rounded, size: 40, color: Colors.indigo),
        title: Text(
          book.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.indigo[900],
            decoration: book.isRead ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          book.author,
          style: TextStyle(color: Colors.indigo[700]),
        ),
        trailing: Icon(
          book.isRead ? Icons.check_circle : Icons.radio_button_unchecked,
          color: book.isRead ? Colors.green : Colors.grey,
        ),
      ),
    );
  }
}
