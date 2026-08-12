import 'package:flutter_profile/common/api/skills_webclient.dart';
import 'package:flutter_profile/common/models/skill.dart';
import 'package:flutter_test/flutter_test.dart';

import 'webclient_test_helpers.dart';

void main() {
  test('getSkills cross-references isRecommended from the userRecommended response', () async {
    final (:dio, :adapter) = buildMockDio();
    adapter
      ..onGet('skills.json', (server) => server.reply(200, {
            's1': {'title': 'Dart', 'likesQuantity': 5},
            's2': {'title': 'Flutter', 'likesQuantity': 2},
          }))
      ..onGet(RegExp(r'^userRecommended/uid1\.json'), (server) => server.reply(200, {'s1': true}));
    final webClient = SkillsWebClient(dio: dio, auth: buildSignedInAuth());

    final skills = await webClient.getSkills();

    expect(skills, [
      Skill(id: 's1', title: 'Dart', likesQuantity: 5, isRecommended: true),
      Skill(id: 's2', title: 'Flutter', likesQuantity: 2, isRecommended: false),
    ]);
  });

  test('addNewSkill posts to skills.json', () async {
    final (:dio, :adapter) = buildMockDio();
    adapter.onPost(RegExp(r'^skills\.json'), (server) => server.reply(200, 'ok', statusMessage: 'Created'));
    final webClient = SkillsWebClient(dio: dio, auth: buildSignedInAuth());

    expect(await webClient.addNewSkill('Dart'), 'Created');
  });

  test('removeSkill deletes skills/{id}.json', () async {
    final (:dio, :adapter) = buildMockDio();
    adapter.onDelete(RegExp(r'^skills/s1\.json'), (server) => server.reply(200, 'ok', statusMessage: 'Deleted'));
    final webClient = SkillsWebClient(dio: dio, auth: buildSignedInAuth());

    expect(await webClient.removeSkill('s1'), 'Deleted');
  });

  group('recommendSkill', () {
    test('success: flips isRecommended, adjusts likesQuantity and persists via updateSkill', () async {
      final (:dio, :adapter) = buildMockDio();
      adapter
        ..onPut(RegExp(r'^userRecommended/uid1/s1\.json'), (server) => server.reply(200, 'ok', statusMessage: 'Recommended'))
        ..onPut(RegExp(r'^skills/s1\.json'), (server) => server.reply(200, 'ok', statusMessage: 'Updated'));
      final webClient = SkillsWebClient(dio: dio, auth: buildSignedInAuth());
      final skill = Skill(id: 's1', title: 'Dart', likesQuantity: 5, isRecommended: false);

      // recommendSkill returns the userRecommended PUT's status message, not
      // updateSkill's — the latter's result is awaited but discarded.
      final result = await webClient.recommendSkill('uid1', skill);

      expect(skill.isRecommended, true);
      expect(skill.likesQuantity, 6);
      expect(result, 'Recommended');
    });

    test(
      'BUG: when the userRecommended PUT fails, BaseInterceptor turns the >=400 response into a thrown '
      'exception before recommendSkill ever reaches its own `if (response.statusCode! >= 400)` rollback check, '
      'so the optimistic isRecommended flip is never rolled back and likesQuantity/updateSkill never run',
      () async {
        final (:dio, :adapter) = buildMockDio();
        adapter.onPut(RegExp(r'^userRecommended/uid1/s1\.json'), (server) => server.reply(400, {'Message': 'failed'}));
        final webClient = SkillsWebClient(dio: dio, auth: buildSignedInAuth());
        final skill = Skill(id: 's1', title: 'Dart', likesQuantity: 5, isRecommended: false);

        await expectLater(webClient.recommendSkill('uid1', skill), throwsA(anything));

        // The optimistic flip from the start of recommendSkill survives uncorrected.
        expect(skill.isRecommended, true);
        expect(skill.likesQuantity, 5);
      },
    );
  });
}
