import 'package:reddit_video_downloader/actions/actions.dart';
import 'package:reddit_video_downloader/models/download.dart';
import 'package:redux/redux.dart';

final downloadReducer = combineReducers<Download>([
  TypedReducer<Download, UpdateStatusAction>(_updateStatus),
  TypedReducer<Download, StartDownloadAction>(_startDownload),
  TypedReducer<Download, StopDownloadAction>(_stopDownload),
]);

Download _updateStatus(Download state, UpdateStatusAction action) {
  return state.copyWith(status: action.status);
}

Download _startDownload(Download state, StartDownloadAction action) {
  return state.copyWith(isDownloading: true);
}

Download _stopDownload(Download state, StopDownloadAction action) {
  return state.copyWith(isDownloading: false);
}
