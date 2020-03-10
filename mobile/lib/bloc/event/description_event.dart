import 'package:flutter/cupertino.dart';

import '../../pages/description_page.dart';

abstract class DescriptionEvent {}

class DescriptionSubmitted extends DescriptionEvent {
  final issueId;
  final String description;
  final IssueRequestType type;
  final BuildContext context;

  DescriptionSubmitted(this.description, this.issueId, this.type, this.context);
}
