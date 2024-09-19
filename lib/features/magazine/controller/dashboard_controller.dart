import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:magazine/core/error/exceptions.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  var videoControllers = <YoutubePlayerController>[].obs;
  final _loading = false.obs;
  bool get loading => _loading.value;

  @override
  void onInit() {
    super.onInit();
    fetchVideoUrls();
  }

  Future<void> fetchVideoUrls() async {
    // AIzaSyAtfdK9jSpnk7xGDLgpSTUZJxCcRyaFq2Y
    const String apiKey = 'AIzaSyAtfdK9jSpnk7xGDLgpSTUZJxCcRyaFq2Y';
    const String channelId = 'UCc3rKFw9euF4aKfoJ-ynFeA';
    const String url =
        'https://www.googleapis.com/youtube/v3/search?key=$apiKey&channelId=$channelId&part=snippet,id&order=date&maxResults=3';
    _loading.value = true;

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (kDebugMode) {
          print(data);
        }
        final List videoIds =
            data['items'].map((item) => item['id']['videoId']).toList();

        videoControllers.assignAll(videoIds
            .map((videoId) => YoutubePlayerController.fromVideoId(
                  videoId: videoId,
                  autoPlay: false,
                  params: const YoutubePlayerParams(
                    enableCaption: true,
                    showControls: true,
                    showFullscreenButton: true,
                  ),
                ))
            .toList());
      }
    } on NotFoundException catch (e) {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        msg: e.message,
      );
    } on ServerException catch (e) {
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        msg: e.message,
      );
    } on Exception catch (e) {
      print(e);
      Fluttertoast.showToast(
        backgroundColor: Colors.red,
        msg: 'An unexpected error occurred: $e',
      );
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      _loading.value = false;
      update();
    });
  }

  @override
  void onClose() {
    for (var controller in videoControllers) {
      controller.close();
    }
    super.onClose();
  }
}
