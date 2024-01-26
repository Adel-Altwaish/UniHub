// ignore_for_file: unnecessary_brace_in_string_interps, library_private_types_in_public_api, prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, no_leading_underscores_for_local_identifiers, avoid_print, use_build_context_synchronously, sized_box_for_whitespace

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uni_hub/categories/books_list.dart';
import 'package:uni_hub/widgets/pdf_viewer.dart';

class BooksPage extends StatefulWidget {
  const BooksPage({super.key});

  @override
  _BooksPageState createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  List<Book> books = booksList;

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
                  setState(
                    () {
                      books[index].isExpanded = !books[index].isExpanded;
                    },
                  );
                },
                children: [
                  ExpansionPanel(
                    headerBuilder: (BuildContext context, bool isExpanded) {
                      return ListTile(
                        contentPadding: EdgeInsets.all(16),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            books[index].imagePath,
                            width: 70,
                            height: 150,
                          ),
                        ),
                        title: Text(
                          books[index].title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 6),
                            Text(
                              books[index].description,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    body: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(books[index].information),
                        ),
                        Container(
                          height: 100,
                          width: double.infinity,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned.fill(
                                child: ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                      Colors.white.withOpacity(0.8),
                                      BlendMode.srcATop),
                                  child: Image.asset(
                                    'images/logo.png',
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                                final byteData = await rootBundle
                                    .load(books[index].pdfPathDownload);
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