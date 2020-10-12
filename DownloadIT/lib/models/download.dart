import 'package:meta/meta.dart';

@immutable
class Download {
  final bool isDownloading;
  final String status;

  const Download({this.isDownloading, this.status});

  Download copyWith({bool isDownloading, String status}) {
    return Download(
      isDownloading: isDownloading ?? this.isDownloading,
      status: status ?? this.status,
    );
  }
}
