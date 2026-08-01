import 'package:flutter/cupertino.dart';

import '../../l10n/app_localizations.dart';

class RelationshipUtil {
  static String getRelationshipName({required BuildContext context, int relationshipCode = 0}) {
    final text = AppLocalizations.of(context)!;
    return switch (relationshipCode) {
      0 => text.relationshipDataFriend,
      1 => text.relationshipDataCoworker,
      2 => text.relationshipDataBoss,
      3 => text.relationshipDataClient,
      4 => text.relationshipDataFamily,
      5 => text.relationshipDataRecruiter,
      _ => text.relationshipDataFriend
    };
  }
}
