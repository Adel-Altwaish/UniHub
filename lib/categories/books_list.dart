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

List<Book> booksList = [
    Book(
      title: 'Flutter',
      description: 'Learn Flutter Basics',
      imagePath: 'images/book1.png',
      pdfPathDownload: 'assets/Flutter.pdf',
      pdfAfterDownload:
          '/data/user/0/com.example.uni_hub/app_flutter/flutter.pdf',
      information:
          "Author: Adel Abo baker\nSection: Programming languages [edit]\nPages: 163\nFile size: 12.0 MB",
    ),
    Book(
      title: 'English Made Easy',
      description: 'Learn English Through Pictures',
      imagePath: 'images/book2.png',
      pdfPathDownload: 'assets/English.pdf',
      pdfAfterDownload:
          '/data/user/0/com.example.uni_hub/app_flutter/ُenglish made easy.pdf',
      information:
          "Author: Jonathan Crichton\nSection: English language learning\nPages: 193\nFile size: 34.1 MB",
    ),
  ];