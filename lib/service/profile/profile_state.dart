import 'package:munch/service/util/super_state.dart';

class ProfileState extends SuperState {
  ProfileState({initial = true, loading = false, hasError = false, message = ""})
      : super(initial: initial, loading: loading, hasError: hasError, message: message);

  ProfileState.ready({data}) : super.ready(data: data);

  ProfileState.loading({message = ""}) : super.loading(message: message);

  ProfileState.failed({exception, message = ""}) : super.failed(exception: exception, message: message);
}

class UpdatePersonalInformationState extends ProfileState {
  UpdatePersonalInformationState.ready({data}) : super.ready(data: data);

  UpdatePersonalInformationState.loading({message = ""}) : super.loading(message: message);

  UpdatePersonalInformationState.failed({exception, message = ""})
      : super.failed(exception: exception, message: message);
}
