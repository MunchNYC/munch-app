import 'package:munch/service/util/super_state.dart';

class LocationState extends SuperState {
  LocationState({initial = true, loading = false, hasError = false, message = ""}):super(initial: initial, loading: loading, hasError: hasError, message: message);

  LocationState.ready({data}):super.ready(data: data);
  LocationState.loading({message = ""}):super.loading(message: message);
  LocationState.failed({message = ""}):super.failed(message: message);
}

class CurrentLocationFetchingState extends LocationState {
  CurrentLocationFetchingState.ready({data}):super.ready(data: data);
  CurrentLocationFetchingState.loading({message = ""}):super.loading(message: message);
  CurrentLocationFetchingState.failed({message = ""}):super.failed(message: message);
}