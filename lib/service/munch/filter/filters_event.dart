import 'package:munch/model/filter.dart';
import 'package:munch/model/secondary_filters.dart';

abstract class FiltersEvent {}

class GetFiltersEvent extends FiltersEvent {}

class UpdateFiltersEvent extends FiltersEvent {
  List<Filter> whitelistFilters;
  List<Filter> blacklistFilters;
  String munchId;

  UpdateFiltersEvent({this.whitelistFilters, this.blacklistFilters, this.munchId});
}

class UpdateAllFiltersEvent extends FiltersEvent {
  SecondaryFilters oldFilters;
  SecondaryFilters newFilters;

  List<Filter> whitelistFilters;
  List<Filter> blacklistFilters;
  String munchId;

  UpdateAllFiltersEvent({this.oldFilters, this.newFilters, this.whitelistFilters, this.blacklistFilters, this.munchId});
}