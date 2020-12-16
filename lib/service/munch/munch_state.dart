import 'package:munch/model/munch.dart';
import 'package:munch/service/util/super_state.dart';

class MunchState extends SuperState {
  MunchState({initial = true, loading = false, hasError = false, message = ""})
      : super(initial: initial, loading: loading, hasError: hasError, message: message);

  MunchState.ready({data}) : super.ready(data: data);

  MunchState.loading({message = ""}) : super.loading(message: message);

  MunchState.failed({exception, message = ""}) : super.failed(exception: exception, message: message);
}

class MunchesFetchingState extends MunchState {
  MunchesFetchingState.ready({data}) : super.ready(data: data);

  MunchesFetchingState.loading({message = ""}) : super.loading(message: message);

  MunchesFetchingState.failed({exception, message = ""}) : super.failed(exception: exception, message: message);
}

class HistoricalMunchesPageFetchingState extends MunchState {
  HistoricalMunchesPageFetchingState.ready({data}) : super.ready(data: data);

  HistoricalMunchesPageFetchingState.loading({message = ""}) : super.loading(message: message);

  HistoricalMunchesPageFetchingState.failed({exception, message = ""})
      : super.failed(exception: exception, message: message);
}

class MunchJoiningState extends MunchState {
  MunchJoiningState.ready({data}) : super.ready(data: data);

  MunchJoiningState.loading({message = ""}) : super.loading(message: message);

  MunchJoiningState.failed({exception, message = ""}) : super.failed(exception: exception, message: message);
}

class MunchCreatingState extends MunchState {
  MunchCreatingState.ready({data}) : super.ready(data: data);

  MunchCreatingState.loading({message = ""}) : super.loading(message: message);

  MunchCreatingState.failed({exception, message = ""}) : super.failed(exception: exception, message: message);
}

class DetailedMunchFetchingState extends MunchState {
  DetailedMunchFetchingState.ready({data}) : super.ready(data: data);

  DetailedMunchFetchingState.loading({message = ""}) : super.loading(message: message);

  DetailedMunchFetchingState.failed({exception, message = ""}) : super.failed(exception: exception, message: message);
}

class RestaurantsPageFetchingState extends MunchState {
  RestaurantsPageFetchingState.ready({data}) : super.ready(data: data);

  RestaurantsPageFetchingState.loading({message = ""}) : super.loading(message: message);

  RestaurantsPageFetchingState.failed({exception, message = ""}) : super.failed(exception: exception, message: message);
}

class RestaurantSwipeProcessingState extends MunchState {
  RestaurantSwipeProcessingState.ready({data}) : super.ready(data: data);

  RestaurantSwipeProcessingState.loading({message = ""}) : super.loading(message: message);

  RestaurantSwipeProcessingState.failed({exception, message = ""})
      : super.failed(exception: exception, message: message);
}

class NoMoreCarouselImageState extends MunchState {
  NoMoreCarouselImageState.ready({data}) : super.ready(data: data);

  NoMoreCarouselImageState.loading({message = ""}) : super.loading(message: message);

  NoMoreCarouselImageState.failed({exception, message = ""}) : super.failed(exception: exception, message: message);
}

class MunchPreferencesSavingState extends MunchState {
  MunchPreferencesSavingState.ready({data}) : super.ready(data: data);

  MunchPreferencesSavingState.loading({message = ""}) : super.loading(message: message);

  MunchPreferencesSavingState.failed({exception, message = ""}) : super.failed(exception: exception, message: message);
}

class KickingMemberState extends MunchState {
  KickingMemberState.ready({data}) : super.ready(data: data);

  KickingMemberState.loading({message = ""}) : super.loading(message: message);

  KickingMemberState.failed({exception, message = ""}) : super.failed(exception: exception, message: message);
}

class MunchLeavingState extends MunchState {
  MunchLeavingState.ready({data}) : super.ready(data: data);

  MunchLeavingState.loading({message = ""}) : super.loading(message: message);

  MunchLeavingState.failed({exception, message = ""}) : super.failed(exception: exception, message: message);
}

class CancellingMunchDecisionState extends MunchState {
  CancellingMunchDecisionState.ready({data}) : super.ready(data: data);

  CancellingMunchDecisionState.loading({message = ""}) : super.loading(message: message);

  CancellingMunchDecisionState.failed({exception, message = ""}) : super.failed(exception: exception, message: message);
}

class ReviewMunchState extends MunchState {
  // if review is requested on app opened
  bool forcedReview;
  MunchReviewValue munchReviewValue;

  ReviewMunchState.ready({data}) : super.ready(data: data);

  ReviewMunchState.loading({this.munchReviewValue, message = ""}) : super.loading(message: message);

  ReviewMunchState.failed({exception, message = ""}) : super.failed(exception: exception, message: message);
}
