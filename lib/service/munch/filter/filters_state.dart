import 'package:munch/service/util/super_state.dart';

class FiltersState extends SuperState {
  FiltersState({initial = true, loading = false, hasError = false, message = ""}):super(initial: initial, loading: loading, hasError: hasError, message: message);

  FiltersState.ready({data}):super.ready(data: data);
  FiltersState.loading({message = ""}):super.loading(message: message);
  FiltersState.failed({message = ""}):super.failed(message: message);
}

class FiltersFetchingState extends FiltersState {
  FiltersFetchingState.ready({data}):super.ready(data: data);
  FiltersFetchingState.loading({message = ""}):super.loading(message: message);
  FiltersFetchingState.failed({message = ""}):super.failed(message: message);
}

class FiltersUpdatingState extends FiltersState {
  FiltersUpdatingState.ready({data}):super.ready(data: data);
  FiltersUpdatingState.loading({message = ""}):super.loading(message: message);
  FiltersUpdatingState.failed({message = ""}):super.failed(message: message);
}