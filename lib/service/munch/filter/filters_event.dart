import 'package:munch/model/filter.dart';

abstract class FiltersEvent {}

class GetFiltersEvent extends FiltersEvent {}

class UpdateFiltersEvent extends FiltersEvent {
  List<Filter> whitelistFilters;
  List<Filter> blacklistFilters;
  String munchId;

  UpdateFiltersEvent({this.whitelistFilters, this.blacklistFilters, this.munchId});
}
