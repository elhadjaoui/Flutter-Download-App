import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reddit_video_downloader/actions/actions.dart';
import 'package:reddit_video_downloader/models/app_state.dart';
import 'package:reddit_video_downloader/utils.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:http/http.dart' as http;

Future<String> _getDash(String redditUrl) async {

  redditUrl = Utils.removeQueryParams(redditUrl);

  Future<String> fetch(String url) async {
    redditUrl = Utils.parseThreadUrl(url);

    try {
      final response = await http.get(redditUrl);
      debugPrint(response.statusCode.toString());
      if (response.statusCode == 302) {
        debugPrint('Location: ' + response.headers['Location']);
        return await fetch(response.headers['Location']);
      }

      return response.body;
    } catch (e) {
      return '{}';
    }
  }

  RedditUrls urlType = Utils.getUrlType(redditUrl);
  switch (urlType) {

    case RedditUrls.THREAD:
      dynamic data = jsonDecode(await fetch(redditUrl));

      try {
        String dashUrl = data[0]['data']['children'][0]['data']['secure_media']
        ['reddit_video']['dash_url'];
        return dashUrl;
      } catch (e) {
        return null;
      }
      break;
    case RedditUrls.VIDEO:
    case RedditUrls.VIDEO2:
      String threadUrl = await Utils.getThreadUrlFromVideoUrl(redditUrl);
      if (threadUrl == null) {
        return null;
      }

      String jsonData = await fetch(threadUrl);
      debugPrint('final url ' + threadUrl);
      debugPrint(jsonData);
      dynamic data = jsonDecode(jsonData);

      try {
        String dashUrl = data[0]['data']['children'][0]['data']['secure_media']
        ['reddit_video']['dash_url'];
        return dashUrl;
      } catch (e) {
        return null;
      }
      break;
    case RedditUrls.DASH:
      return redditUrl;
      break;
    case RedditUrls.INVALID:
      return null;
      break;
  }



}

Stream<dynamic> _startDownload(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  return actions
      .where((action) => action is StartDownloadAction)
      .asyncMap((action) async {
    void updateStatus(String status) {
      StoreProvider.of<AppState>(action.context)
          .dispatch(new UpdateStatusAction(status));
    }

    void openDialog(String title, String body) {
      StoreProvider.of<AppState>(action.context).dispatch(new OpenDialogAction(
          title: title, body: body, context: action.context));
    }

    debugPrint('download');
    updateStatus('Starting download');
    String url = action.url;

    if (url.isEmpty) {
      openDialog('Failure', 'Empty URL.');
      return new StopDownloadAction();
    }

    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);

    if (permission != PermissionStatus.granted) {
      Map<PermissionGroup, PermissionStatus> permissions =
          await PermissionHandler()
              .requestPermissions([PermissionGroup.storage]);
      debugPrint(permissions.toString());
      var status = permissions[PermissionGroup.storage];

      if (status != PermissionStatus.granted) {
        openDialog('Insufficient permissions',
            'We need the storage permission to be able to save your video.');
        debugPrint('access denied');
        return new StopDownloadAction();
      }
    }

    updateStatus('Getting DASH information');
    String dashUrl = await _getDash(url);
    if (dashUrl == null) {
      openDialog(
          'Failure', 'The URL might be invalid.');
      return new StopDownloadAction();
    }

    debugPrint(dashUrl);

    updateStatus('In progress...');
    final FlutterFFmpeg ffmpeg = new FlutterFFmpeg();
    final FlutterFFmpegConfig ffmpegConfig = new FlutterFFmpegConfig();
    final Directory directory = await getApplicationDocumentsDirectory();

    String path = directory.path;

    String fileName = 'temp.mp4';

    debugPrint('Path: ' + path);
    updateStatus('In progress....');

    ffmpegConfig.resetStatistics();
    ffmpegConfig.disableLogs();
    ffmpegConfig.enableStatisticsCallback((int time,
        int size,
        double bitrate,
        double speed,
        int videoFrameNumber,
        double videoQuality,
        double videoFps) {
      updateStatus(
          'time: $time, size: $size, bitrate: $bitrate, speed: $speed, videoFrameNumber: $videoFrameNumber, videoQuality: $videoQuality, videoFps: $videoFps');
    });

    int code =
        await ffmpeg.execute('-y -i $dashUrl -codec copy $path/$fileName');
    if (code == 0) {
      debugPrint('success');
      debugPrint('saving to $path/$fileName');

      final result = await ImageGallerySaver.saveFile('$path/$fileName');
      new File('$path/$fileName').delete();
      debugPrint(result);
      updateStatus('Success');
      await Future.delayed(Duration(seconds: 1));
     openDialog('Success', 'Your video was downloaded.\nSaved to gallery.');
      return new StopDownloadAction();
    } else {
      debugPrint('failure');
      updateStatus('Error');
      debugPrint(code.toString());
      openDialog('Failure', 'Something happened when downloading the video.');
      return new StopDownloadAction();
    }
  });
}

Stream<dynamic> _openDialog(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  return actions
      .where((action) => action is OpenDialogAction)
      .asyncMap((action) async {
    showDialog(
        context: action.context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(action.title),
            content: SingleChildScrollView(
              child: Text(action.body),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Close'),
                onPressed: Navigator.of(context).pop,
              )
            ],
          );
        });
  });
}

final epic = combineEpics<AppState>([_startDownload, _openDialog]);
