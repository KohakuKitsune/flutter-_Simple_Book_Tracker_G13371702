import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../main.dart';
import '../widgets/book_tile.dart';
import 'add_book_screen.dart';

//主頁狀態更新
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

//主頁狀態内容
class _HomeScreenState extends State<HomeScreen> {
  List<Book> books = [];
  bool isSelectionMode = false;
  Set<int> selectedIndexes = {};

  @override
  //初始化
  void initState() {
    super.initState();
    _loadBooks();
  }

  //讀取本地存檔來獲得書單
  void _loadBooks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? booksJson = prefs.getString('books');
    if (booksJson != null) {
      List<dynamic> decoded = jsonDecode(booksJson);
      setState(() {
        books = decoded.map((json) => Book.fromJson(json)).toList();
      });
    }
  }

  //將書本資料存進書單裏面
  void _saveBooks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> jsonBooks =
    books.map((book) => book.toJson()).toList();
    prefs.setString('books', jsonEncode(jsonBooks));
  }

  //新增書本進入書單
  void _addBook(Book book) {
    setState(() {
      books.add(book);
      _saveBooks();
    });
  }

  //將書本設置爲已閲讀狀態
  void _toggleRead(int index) {
    setState(() {
      books[index].isRead = !books[index].isRead;
      _saveBooks();
    });
  }

  //將書本刪除
  void _deleteBook(int index) {
    setState(() {
      books.removeAt(index);
      _saveBooks();
    });
  }

  //刪除選擇書本
  void _deleteSelectedBooks() {
    if (selectedIndexes.isEmpty) return;

    final deletedCount = selectedIndexes.length;

    setState(() {
      books = books
          .asMap()
          .entries
          .where((entry) => !selectedIndexes.contains(entry.key))
          .map((e) => e.value)
          .toList();
      selectedIndexes.clear();
      isSelectionMode = false;
      _saveBooks();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$deletedCount book(s) deleted.')),
    );
  }

  //提示是否確認刪除已閲讀書本
  void _confirmDeleteReadBooks() {
    final readBooksCount = books.where((book) => book.isRead).length;

    if (readBooksCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No read books to delete.')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Read Books?'),
        content: Text('Are you sure you want to delete $readBooksCount read book(s)?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text('Delete'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              _deleteReadBooks();
            },
          ),
        ],
      ),
    );
  }

  //刪除已閲讀書本
  void _deleteReadBooks() {
    setState(() {
      books.removeWhere((book) => book.isRead);
      _saveBooks();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('All read books deleted.')),
    );
  }

  //根據書名後者是否已閲讀的狀態來排序
  void _sortBooks(String sortType) {
    setState(() {
      if (sortType == 'title') {
        books.sort((a, b) => a.title.compareTo(b.title));
      } else if (sortType == 'read') {
        books.sort((a, b) => a.isRead ? 1 : -1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int readCount = books.where((book) => book.isRead).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(isSelectionMode
            ? '${selectedIndexes.length} Selected'
            : 'Simple Book Tracker'),
        leading: isSelectionMode
            ? IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            setState(() {
              isSelectionMode = false;
              selectedIndexes.clear();
            });
          },
        )
            : null,
        actions: isSelectionMode
            ? [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deleteSelectedBooks,
          ),
        ]
            : [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'title' || value == 'read') {
                _sortBooks(value);
              } else if (value == 'deleteRead') {
                _confirmDeleteReadBooks();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                  value: 'title', child: Text('Sort by Title')),
              PopupMenuItem(
                  value: 'read', child: Text('Sort by Read Status')),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'deleteRead',
                child: Text('Delete All Read Books'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Read: $readCount / ${books.length}'),
          ),
          Expanded(
            child: books.isEmpty
                ? Center(child: Text('No books added yet.'))
                : ListView.separated(
              padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: books.length,
              separatorBuilder: (_, __) => SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final book = books[index];
                  final isSelected = selectedIndexes.contains(index);

                  return GestureDetector(
                    onLongPress: () {
                      setState(() {
                        isSelectionMode = true;
                        selectedIndexes.add(index);
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.indigo.withOpacity(0.2) : null,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Dismissible(
                        key: Key(book.title + index.toString()),
                        background: Container(
                          padding: EdgeInsets.only(left: 20),
                          alignment: Alignment.centerLeft,
                          color: Colors.red,
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        direction: isSelectionMode
                            ? DismissDirection.none
                            : DismissDirection.startToEnd,
                        onDismissed: (_) => _deleteBook(index),
                        child: BookTile(
                          book: book,
                          onTap: () async {
                            if (isSelectionMode) {
                              setState(() {
                                if (isSelected) {
                                  selectedIndexes.remove(index);
                                  if (selectedIndexes.isEmpty) isSelectionMode = false;
                                } else {
                                  selectedIndexes.add(index);
                                }
                              });
                            } else {
                              final edited = await Navigator.push<Book>(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddBookScreen(book: books[index]),
                                ),
                              );

                              if (edited != null && edited is Book) {
                                setState(() {
                                  books[index] = edited;
                                  _saveBooks();
                                });
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  );
                }
            ),
          ),
        ],
      ),
      floatingActionButton: isSelectionMode //漂浮按鈕
          ? null
          : Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          //新增一本書
          FloatingActionButton(
            heroTag: 'addReal',
            onPressed: () async {
              final newBook = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddBookScreen()),
              );
              if (newBook != null && newBook is Book) {
                _addBook(newBook);
              }
            },
            child: const Icon(Icons.add, color: Colors.white),
            backgroundColor: Colors.indigo,
          ),
          SizedBox(height: 10),
          //新增一個測試書本（測試按鈕）
          FloatingActionButton(
            heroTag: 'addDummy',
            onPressed: () {
              _addBook(Book(title: "Test Book", author: "Tester"));
            },
            child: const Icon(Icons.bug_report, color: Colors.white),
            backgroundColor: Colors.orange,
          ),
        ],
      ),
    );
  }
}
