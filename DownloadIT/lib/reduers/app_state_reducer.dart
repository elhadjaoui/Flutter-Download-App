import 'package:reddit_video_downloader/models/app_state.dart';
import 'package:reddit_video_downloader/reduers/download_reducer.dart';

AppState appReducer(AppState state, action) {
  return AppState(
    download: downloadReducer(state.download, action)
  );
}
