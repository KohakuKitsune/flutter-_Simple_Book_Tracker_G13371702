import 'package:flutter/material.dart';
import '../main.dart';

class AddBookScreen extends StatefulWidget {
  final Book? book;

  const AddBookScreen({super.key, this.book});

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _imageUrlController = TextEditingController();
  bool _isRead = false;

  @override
  void initState() {
    super.initState();
    if (widget.book != null) {
      _titleController.text = widget.book!.title;
      _authorController.text = widget.book!.author;
      _imageUrlController.text = widget.book!.imageUrl ?? '';
      _isRead = widget.book!.isRead;
    }
  }

  void _submit() {
    final title = _titleController.text.trim();
    final author = _authorController.text.trim();
    final imageUrl = _imageUrlController.text.trim();

    if (title.isEmpty || author.isEmpty) {
      print("Title or Author is empty");
      return;
    }

    final book = Book(
      title: title,
      author: author,
      isRead: _isRead,
      imageUrl: imageUrl.isNotEmpty ? imageUrl : null,
    );

    print("Returning book: ${book.title}, ${book.author}");
    Navigator.pop(context, book);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(widget.book == null ? 'Add Book' : 'Edit Book'),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            //書本標題
            TextField(
              controller: _titleController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Book Title',
                hintText: 'Enter the title',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.indigo, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            //書本作者名字
            TextField(
              controller: _authorController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Author',
                hintText: 'Enter the author',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.indigo, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            //圖片鏈接
            TextField(
              controller: _imageUrlController,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: 'Cover Image URL (optional)',
                hintText: 'https://example.com/image.jpg',
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.indigo, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Mark as Read'),
              value: _isRead,
              onChanged: (val) => setState(() => _isRead = val),
              activeColor: Colors.indigo,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _submit,
                icon: Icon(widget.book == null ? Icons.add : Icons.save),
                label: Center(
                  child: Text(
                    widget.book == null ? 'Add Book' : 'Save Changes',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
