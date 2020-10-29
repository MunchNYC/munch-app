import 'package:munch/model/munch.dart';
import 'package:munch/service/util/super_state.dart';

class MunchState extends SuperState {
  MunchState({initial = true, loading = false, hasError = false, message = ""}):super(initial: initial, loading: loading, hasError: hasError, message: message);

  MunchState.ready({data}):super.ready(data: data);
  MunchState.loading({message = ""}):super.loading(message: message);
  MunchState.failed({message = ""}):super.failed(message: message);
}

class MunchesFetchingState extends MunchState {
  MunchesFetchingState.ready({data}):super.ready(data: data);
  MunchesFetchingState.loading({message = ""}):super.loading(message: message);
  MunchesFetchingState.failed({message = ""}):super.failed(message: message);
}

class MunchJoiningState extends MunchState {
  MunchJoiningState.ready({data}):super.ready(data: data);
  MunchJoiningState.loading({message = ""}):super.loading(message: message);
  MunchJoiningState.failed({message = ""}):super.failed(message: message);
}

class MunchCreatingState extends MunchState {
  MunchCreatingState.ready({data}):super.ready(data: data);
  MunchCreatingState.loading({message = ""}):super.loading(message: message);
  MunchCreatingState.failed({message = ""}):super.failed(message: message);
}

class DetailedMunchFetchingState extends MunchState {
  DetailedMunchFetchingState.ready({data}):super.ready(data: data);
  DetailedMunchFetchingState.loading({message = ""}):super.loading(message: message);
  DetailedMunchFetchingState.failed({message = ""}):super.failed(message: message);
}

class RestaurantsPageFetchingState extends MunchState {
  RestaurantsPageFetchingState.ready({data}):super.ready(data: data);
  RestaurantsPageFetchingState.loading({message = ""}):super.loading(message: message);
  RestaurantsPageFetchingState.failed({message = ""}):super.failed(message: message);
}

class RestaurantSwipeProcessingState extends MunchState{
  RestaurantSwipeProcessingState.ready({data}):super.ready(data: data);
  RestaurantSwipeProcessingState.loading({message = ""}):super.loading(message: message);
  RestaurantSwipeProcessingState.failed({message = ""}):super.failed(message: message);
}

class NoMoreCarouselImageState extends MunchState{
  NoMoreCarouselImageState.ready({data}):super.ready(data: data);
  NoMoreCarouselImageState.loading({message = ""}):super.loading(message: message);
  NoMoreCarouselImageState.failed({message = ""}):super.failed(message: message);
}

class MunchPreferencesSavingState extends MunchState{
  MunchPreferencesSavingState.ready({data}):super.ready(data: data);
  MunchPreferencesSavingState.loading({message = ""}):super.loading(message: message);
  MunchPreferencesSavingState.failed({message = ""}):super.failed(message: message);
}

class KickingMemberState extends MunchState{
  KickingMemberState.ready({data}):super.ready(data: data);
  KickingMemberState.loading({message = ""}):super.loading(message: message);
  KickingMemberState.failed({message = ""}):super.failed(message: message);
}

class MunchLeavingState extends MunchState{
  MunchLeavingState.ready({data}):super.ready(data: data);
  MunchLeavingState.loading({message = ""}):super.loading(message: message);
  MunchLeavingState.failed({message = ""}):super.failed(message: message);
}

class CancellingMunchDecisionState extends MunchState {
  CancellingMunchDecisionState.ready({data}) :super.ready(data: data);
  CancellingMunchDecisionState.loading({message = ""}) :super.loading(message: message);
  CancellingMunchDecisionState.failed({message = ""}) :super.failed(message: message);
}

class ReviewMunchState extends MunchState {
  MunchReviewValue munchReviewValue;

  ReviewMunchState.ready({data}) :super.ready(data: data);
  ReviewMunchState.loading({this.munchReviewValue, message = ""}) :super.loading(message: message);
  ReviewMunchState.failed({message = ""}) :super.failed(message: message);
}
