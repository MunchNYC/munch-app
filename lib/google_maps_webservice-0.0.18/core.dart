class Location {
  final double lat;
  final double lng;

  Location(this.lat, this.lng);

  factory Location.fromJson(Map json) => json != null
      ? Location(
          (json['lat'] as num).toDouble(),
          (json['lng'] as num).toDouble(),
        )
      : null;

  Map<String, dynamic> toJson() {
    var map = {};
    map['lat'] = lat;
    map['lng'] = lng;
    return map;
  }

  @override
  String toString() => '$lat,$lng';
}

abstract class GoogleResponseStatus {
  static const okay = 'OK';
  static const zeroResults = 'ZERO_RESULTS';
  static const overQueryLimit = 'OVER_QUERY_LIMIT';
  static const requestDenied = 'REQUEST_DENIED';
  static const invalidRequest = 'INVALID_REQUEST';
  static const unknownErrorStatus = 'UNKNOWN_ERROR';
  static const notFound = 'NOT_FOUND';
  static const maxWaypointsExceeded = 'MAX_WAYPOINTS_EXCEEDED';
  static const maxRouteLengthExceeded = 'MAX_ROUTE_LENGTH_EXCEEDED';

  final String status;

  /// JSON error_message
  final String errorMessage;

  bool get isOkay => status == okay;
  bool get hasNoResults => status == zeroResults;
  bool get isOverQueryLimit => status == overQueryLimit;
  bool get isDenied => status == requestDenied;
  bool get isInvalid => status == invalidRequest;
  bool get unknownError => status == unknownErrorStatus;
  bool get isNotFound => status == notFound;

  GoogleResponseStatus(this.status, this.errorMessage);

  Map<String, dynamic> toJson() {
    var map = {};
    map['status'] = status;
    map['errorMessage'] = errorMessage;
    return map;
  }
}

abstract class GoogleResponseList<T> extends GoogleResponseStatus {
  final List<T> results;

  GoogleResponseList(String status, String errorMessage, this.results)
      : super(status, errorMessage);
}

abstract class GoogleResponse<T> extends GoogleResponseStatus {
  final T result;

  GoogleResponse(String status, String errorMessage, this.result)
      : super(status, errorMessage);
}