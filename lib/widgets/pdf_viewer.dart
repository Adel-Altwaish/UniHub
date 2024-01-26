// ignore_for_file: avoid_print, no_leading_underscores_for_local_identifiers, prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, library_private_types_in_public_api

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFScreen extends StatefulWidget {
  final String pathPDF;
  PDFScreen(this.pathPDF);

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  int? pages;
  int? currentPage;
  bool isReady = false;
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  late PDFViewController _pdfViewController;
  final pageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text('PDF Viewer'),
        actions: <Widget>[
          Text('page   '),
          Container(
            width: 40,
            alignment: Alignment.center,
            child: TextField(
              controller: pageController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              onSubmitted: (value) async {
                int? pageNumber = int.tryParse(value);
                if (pageNumber != null) {
                  await _pdfViewController.setPage(pageNumber - 1);
                }
              },
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: isReady ? Text(" of $pages") : Container(),
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.grey,
        child: PDFView(
          fitEachPage: true,
          filePath: widget.pathPDF,
          enableSwipe: true,
          swipeHorizontal: false,
          autoSpacing: false,
          pageFling: true,
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
            _pdfViewController = pdfViewController;
          },
          onPageChanged: (int? page, int? total) {
            print('page change: $page/$total');
            setState(() {
              currentPage = page;
              pageController.text = (currentPage! + 1).toString();
            });
          },
        ),
      ),
    );
  }
}
