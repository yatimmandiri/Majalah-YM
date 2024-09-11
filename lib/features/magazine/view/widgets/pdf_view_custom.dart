import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:magazine/common/theme/app_text.dart';
import 'package:magazine/common/theme/color.dart';
import 'package:magazine/features/magazine/controller/magazine_controller.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PdfViewCustom extends StatefulWidget {
  const PdfViewCustom({super.key, this.path, this.header, this.magazineId});

  final String? header;
  final String? path;
  final int? magazineId;

  @override
  State<PdfViewCustom> createState() => _PdfViewCustomState();
}

class _PdfViewCustomState extends State<PdfViewCustom>
    with WidgetsBindingObserver {
  final MagazineController cMaga = Get.find();

  late File pFile;
  bool isLoading = true;
  PDFViewController? pdfViewController;
  int currentPage = 1;
  int totalPage = 0;
  bool swipe = false;
  GlobalKey pdfViewKey = GlobalKey();

  @override
  void initState() {
    loadNetwork();
    super.initState();
  }

  Future<void> loadNetwork() async {
    setState(() {
      isLoading = true;
    });
    var url = widget.path ?? 'http://www.pdf995.com/samples/pdf.pdf';
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final filename = basename(url);
    final dir = await getApplicationDocumentsDirectory();
    var file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);

    setState(() {
      pFile = file;
      isLoading = false;
    });

    await _loadLastReadPage();
  }

  void _toggleSwipeOrientation() {
    setState(() {
      swipe = !swipe;
      pdfViewKey = GlobalKey();
    });
  }

  Future<void> _loadLastReadPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentPage = (prefs.getInt('${widget.magazineId}_lastPage') ?? 0);
      totalPage = (prefs.getInt('${widget.magazineId}_totalPage') ?? 0);
    });
    if (pdfViewController != null) {
      await pdfViewController!.setPage(currentPage);
    }
  }

  Future<void> _saveLastReadPage(int page) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('${widget.magazineId}_lastPage', page);
  }

  Future<void> _saveTotalPages(int totalPages) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('${widget.magazineId}_totalPage', totalPages - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: BackButton(
          onPressed: () {
            cMaga.getMagazine();
            Get.back();
          },
        ),
        title: Text(
          widget.header ?? "Majalah Yatim Mandiri",
          style: fLg.copyWith(color: Colors.white),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: BaseColor.primary,
            ))
          : Stack(
              alignment: Alignment.center,
              children: [
                PDFView(
                  key: pdfViewKey,
                  filePath: pFile.path,
                  enableSwipe: true,
                  swipeHorizontal: swipe,
                  defaultPage: currentPage,
                  autoSpacing: false,
                  pageFling: true,
                  onRender: (pages) {
                    setState(() {
                      totalPage = pages!;
                      _saveTotalPages(totalPage);
                    });
                  },
                  onViewCreated: (controller) {
                    setState(() {
                      pdfViewController = controller;
                    });
                    pdfViewController!.setPage(currentPage);
                  },
                  onPageChanged: (page, total) {
                    setState(() {
                      currentPage = page!;
                      _saveLastReadPage(currentPage);
                    });
                  },
                  onError: (error) {
                    print(error.toString());
                  },
                  onPageError: (page, error) {
                    print('$page: ${error.toString()}');
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                        color: BaseColor.secondary, shape: BoxShape.circle),
                    child: IconButton(
                        onPressed: _toggleSwipeOrientation,
                        icon: Icon(
                          swipe ? Icons.swap_horiz : Icons.swap_vert,
                          size: 30,
                          color: Colors.white,
                        )),
                  ),
                )
              ],
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        shape: CircleBorder(),
        onPressed: () {},
        child: Text(
          currentPage.toString(),
          style: fsecMd,
        ),
      ),
    );
  }
}
