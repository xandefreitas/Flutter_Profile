import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RelationshipUtil {
  static String getRelationshipName({required BuildContext context, int relationshipCode = 0}) {
    final text = AppLocalizations.of(context)!;
    switch (relationshipCode) {
      case 0:
        return text.relationshipDataFriend;
      case 1:
        return text.relationshipDataCoworker;
      case 2:
        return text.relationshipDataBoss;
      case 3:
        return text.relationshipDataClient;
      case 4:
        return text.relationshipDataFamily;
      case 5:
        return text.relationshipDataRecruiter;
      default:
        return text.relationshipDataFriend;
    }
  }
}
