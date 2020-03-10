import '../../models/fix_info.dart';

abstract class FixesState {}

class FixesLoading extends FixesState {}

class FixesList extends FixesState {
  final List<FixInfo> fixes;

  FixesList(this.fixes);

  FixesList copyWithExpand(int index, bool isExpanded) {
    return FixesList(this.fixes)..fixes[index].isExpanded = isExpanded;
  }
}

class FixDone extends FixesState {
  final String message;

  FixDone(this.message);
}

class FixError extends FixesState {}
