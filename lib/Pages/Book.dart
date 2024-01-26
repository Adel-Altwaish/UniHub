// ignore_for_file: unnecessary_brace_in_string_interps, library_private_types_in_public_api, prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, no_leading_underscores_for_local_identifiers, avoid_print, use_build_context_synchronously

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
  final String pdfPathDownload;
  final String information;
  final String pdfAfterDownload;
  bool isExpanded;

  Book({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.pdfPathDownload,
    required this.information,
    required this.pdfAfterDownload,
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
      title: 'Flutter',
      description: 'Learn Flutter Basics',
      imagePath: 'images/book1.png',
      pdfPathDownload: 'assets/Flutter.pdf',
      pdfAfterDownload: '/data/user/0/com.example.uni_hub/app_flutter/flutter.pdf',
      information:
          "Author: Adel Abobaker\nSection: Programming languages [edit]\nPages: 163\nFile size: 12.0 MB",
    ),
    Book(
      title: 'English Made Easy',
      description: 'Learn English Through Pictures',
      imagePath: 'images/book2.png',
      pdfPathDownload: 'assets/English.pdf',
      pdfAfterDownload: '/data/user/0/com.example.uni_hub/app_flutter/ُenglish made easy.pdf',
      information:
          "Author: Jonathan Crichton\nSection: English language learning\nPages: 193\nFile size: 34.1 MB",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Books'),
        backgroundColor: Colors.grey,
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
                        leading: Image.asset(books[index].imagePath,width: 70),
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
                            try {
                              final file = File(books[index].pdfAfterDownload);
                              if (await file.exists()) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PDFScreen(file.path),
                                  ),
                                );
                              } else {
                                print('File does not exist: ${file.path}');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'File does not exist. Please download the book.'),
                                  ),
                                );
                              }
                            } catch (e, stackTrace) {
                              print('Error opening PDF: $e');
                              print('Stack trace: $stackTrace');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Error opening PDF. Please try again.'),
                                ),
                              );
                            }
                          },
                        ),
                        TextButton(
                          child: Text('Download Book'),
                          onPressed: () async {
                            final directory =
                                await getApplicationDocumentsDirectory();
                            final file = File(
                                '${directory.path}/${books[index].title.toLowerCase()}.pdf');
                            if (!await file.exists()) {
                              try {
                                final byteData =
                                    await rootBundle.load(books[index].pdfPathDownload);
                                await file.writeAsBytes(
                                    byteData.buffer.asUint8List());
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Download complete.'),
                                  ),
                                );
                              } catch (e, stackTrace) {
                                print('Error downloading PDF: $e');
                                print('Stack trace: $stackTrace');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Error downloading PDF. Please try again.'),
                                  ),
                                );
                              }
                            } else {
                              print('File already exists: ${file.path}');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('File already downloaded.'),
                                ),
                              );
                            }
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
