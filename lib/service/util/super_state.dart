abstract class SuperState {
  bool initial;
  bool loading;
  bool hasError;
  String message;
  Exception exception;
  dynamic data;

  bool get hasData => (data != null);

  SuperState(
      {this.loading = false,
      this.hasError = false,
      this.initial = true,
      this.message = ""});

  SuperState.ready({this.data}) {
    initial = false;
    loading = false;
    hasError = false;
    message = "";
  }

  SuperState.loading({this.message = ""}) {
    initial = false;
    loading = true;
    hasError = false;
  }

  SuperState.failed({this.message = "", this.exception}) {
    initial = false;
    loading = false;
    hasError = true;
  }

  bool get ready {
    return !initial && !loading && !hasError;
  }

  @override
  String toString() {
    if (initial) return "State: initial";
    if (loading) return "State: loading";
    if (hasError) return "State: error";
    if (ready) return "State: ready";
  }
}
