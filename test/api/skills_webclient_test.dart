import 'package:flutter_profile/common/api/skills_webclient.dart';
import 'package:flutter_profile/common/models/skill.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_skills_database.dart';
import 'webclient_test_helpers.dart';

void main() {
  late FakeSkillsDatabase database;

  setUp(() {
    database = FakeSkillsDatabase();
  });

  test(
    'watchSkills merges the skills node with the current user\'s recommendations',
    () async {
      database
        ..seedSkill('s1', title: 'Dart', likesQuantity: 5)
        ..seedSkill('s2', title: 'Flutter', likesQuantity: 2)
        ..seedUserRecommendation('uid1', 's1', true);
      final webClient = SkillsWebClient(
        database: database,
        auth: buildSignedInAuth(),
      );

      final skills = await webClient.watchSkills().first;

      expect(skills, [
        Skill(id: 's1', title: 'Dart', likesQuantity: 5, isRecommended: true),
        Skill(
          id: 's2',
          title: 'Flutter',
          likesQuantity: 2,
          isRecommended: false,
        ),
      ]);
    },
  );

  test('watchSkills re-emits when a skill changes', () async {
    database.seedSkill('s1', title: 'Dart', likesQuantity: 5);
    final webClient = SkillsWebClient(
      database: database,
      auth: buildSignedInAuth(),
    );
    final emissions = <List<Skill>>[];
    final subscription = webClient.watchSkills().listen(emissions.add);
    await Future<void>.delayed(Duration.zero);

    await database.setRecommendation(
      userId: 'uid1',
      skillId: 's1',
      recommended: true,
      delta: 1,
    );
    await Future<void>.delayed(Duration.zero);
    await subscription.cancel();

    expect(emissions.last, [
      Skill(id: 's1', title: 'Dart', likesQuantity: 6, isRecommended: true),
    ]);
  });

  test('addNewSkill adds a skill node with likesQuantity 0', () async {
    final webClient = SkillsWebClient(
      database: database,
      auth: buildSignedInAuth(),
    );

    await webClient.addNewSkill('Dart');

    expect(database.skillsSnapshot.values, [
      {'title': 'Dart', 'likesQuantity': 0},
    ]);
  });

  test('removeSkill deletes the skill node', () async {
    database.seedSkill('s1', title: 'Dart', likesQuantity: 5);
    final webClient = SkillsWebClient(
      database: database,
      auth: buildSignedInAuth(),
    );

    await webClient.removeSkill('s1');

    expect(database.skillsSnapshot, isEmpty);
  });

  group('recommendSkill', () {
    test(
      'flips isRecommended and adjusts likesQuantity by exactly one',
      () async {
        database.seedSkill('s1', title: 'Dart', likesQuantity: 5);
        final webClient = SkillsWebClient(
          database: database,
          auth: buildSignedInAuth(),
        );
        final skill = Skill(
          id: 's1',
          title: 'Dart',
          likesQuantity: 5,
          isRecommended: false,
        );

        await webClient.recommendSkill('uid1', skill);

        expect(database.skillsSnapshot['s1']!['likesQuantity'], 6);
        expect(await database.watchUserRecommendations('uid1').first, {'s1': true});
      },
    );

    test('decrements when un-recommending', () async {
      database.seedSkill('s1', title: 'Dart', likesQuantity: 5);
      final webClient = SkillsWebClient(
        database: database,
        auth: buildSignedInAuth(),
      );
      final skill = Skill(
        id: 's1',
        title: 'Dart',
        likesQuantity: 5,
        isRecommended: true,
      );

      await webClient.recommendSkill('uid1', skill);

      expect(database.skillsSnapshot['s1']!['likesQuantity'], 4);
      expect(await database.watchUserRecommendations('uid1').first, {'s1': false});
    });

    test(
      'two users recommending the same stale skill snapshot concurrently both land, instead of one overwriting the other',
      () async {
        database.seedSkill('s1', title: 'Dart', likesQuantity: 5);
        final webClient = SkillsWebClient(
          database: database,
          auth: buildSignedInAuth(),
        );
        // Both callers hold the exact same pre-vote snapshot, as if they'd
        // both fetched the list before either voted — the historical bug
        // was computing the new count from this stale local value instead
        // of incrementing the server's current value.
        final staleSnapshot = Skill(
          id: 's1',
          title: 'Dart',
          likesQuantity: 5,
          isRecommended: false,
        );

        await Future.wait([
          webClient.recommendSkill('uidA', staleSnapshot),
          webClient.recommendSkill('uidB', staleSnapshot),
        ]);

        expect(database.skillsSnapshot['s1']!['likesQuantity'], 7);
      },
    );
  });
}
