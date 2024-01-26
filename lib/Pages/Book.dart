// ignore_for_file: unnecessary_brace_in_string_interps, library_private_types_in_public_api, prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, no_leading_underscores_for_local_identifiers, avoid_print

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

class Book {
  final String title;
  final String description;
  final String imagePath;
  final String pdfPath;
  final String information;
  bool isExpanded;

  Book({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.pdfPath,
    required this.information,
    this.isExpanded = false,
  });
}

class BooksPage extends StatefulWidget {
  const BooksPage({super.key});

  @override
  _BooksPageState createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  List<Book> books = [
    Book(
        title: 'Book1',
        description: 'description1 ',
        imagePath: 'images/book1.png',
        pdfPath: 'books/book1.pdf',
        information: 'information of book 1'),
    Book(
        title: 'Book2',
        description: 'description2',
        imagePath: 'images/book1.png',
        pdfPath: 'books/book1.pdf',
        information: 'information of book 2'),
    Book(
        title: 'Book3',
        description: 'description3',
        imagePath: 'images/book1.png',
        pdfPath: 'books/book1.pdf',
        information: 'information of book 3'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Books'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: books.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ExpansionPanelList(
                expansionCallback: (int item, bool status) {
                  setState(() {
                    books[index].isExpanded = !books[index].isExpanded;
                  });
                },
                children: [
                  ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        leading: Image.asset(books[index].imagePath),
                        title: Text(books[index].title),
                        subtitle: Text(books[index].description),
                      );
                    },
                    body: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(books[index].information),
                        ),
                        TextButton(
                          child: Text('Read Book'),
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PDFScreen(books[index].pdfPath),
                              ),
                            );
                          },
                        ),
                        TextButton(
                          child: Text('Download Book'),
                          onPressed: () async {
                            final byteData =
                                await rootBundle.load(books[index].pdfPath);
                            final directory =
                                await getApplicationDocumentsDirectory();
                            final file = File(
                                '${directory.path}/${books[index].title}.pdf');
                            await file
                                .writeAsBytes(byteData.buffer.asUint8List());
                          },
                        ),
                      ],
                    ),
                    isExpanded: books[index].isExpanded,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class PDFScreen extends StatefulWidget {
  final String pathPDF;
  PDFScreen(this.pathPDF);

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  int? pages;
  bool isReady = false;
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();

  @override
  Widget build(BuildContext context) {
    return PDFView(
      filePath: widget.pathPDF,
      enableSwipe: true,
      swipeHorizontal: true,
      autoSpacing: false,
      pageFling: false,
      onRender: (_pages) {
        setState(() {
          pages = _pages;
          isReady = true;
        });
      },
      onError: (error) {
        print(error.toString());
      },
      onPageError: (page, error) {
        print('$page: ${error.toString()}');
      },
      onViewCreated: (PDFViewController pdfViewController) {
        _controller.complete(pdfViewController);
      },
      onPageChanged: (int? page, int? total) {
        print('page change: $page/$total');
      },
    );
  }
}
