import 'package:meta/meta.dart';
import 'package:reddit_video_downloader/models/download.dart';

@immutable
class AppState {
  final Download download;

  AppState({this.download = const Download()});

  factory AppState.initial() => AppState(
      download: new Download(isDownloading: false, status: ''));

  AppState copyWith({Download download}) {
    return AppState(download: download ?? this.download);
  }
}
