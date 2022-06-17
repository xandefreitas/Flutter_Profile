import 'package:flutter/material.dart';
import 'package:flutter_profile/common/models/skill.dart';
import 'package:flutter_profile/core/app_colors.dart';
import 'package:flutter_profile/core/app_text_styles.dart';
import 'package:flutter_profile/data/skills_data.dart';

import 'components/skills_custom_chip.dart';

const String _profilePhoto =
    'https://media-exp2.licdn.com/dms/image/C5603AQHlAkM0n6T-ww/profile-displayphoto-shrink_200_200/0/1600175926661?e=1660176000&v=beta&t=s4jJWz16wkOgtdAAhpUfM5-WHs80ivb6iao2yNwA6VM';

class ProfileScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const ProfileScreen({Key? key, required this.scaffoldKey}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  bool _appBarCollapsed = false;
  final ScrollController _scrollController = ScrollController();
  AnimationController? _animationController;
  Animation<double>? _opacityAnimation;
  Animation<double>? _opacityAnimationReverse;
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      curvedAnimation(),
    );
    _opacityAnimationReverse = Tween(begin: 1.0, end: 0.0).animate(
      curvedAnimation(),
    );
    _scrollController.addListener(() {
      if (_scrollController.position.pixels > 304) {
        setState(() {
          _appBarCollapsed = true;
          _animationController?.forward();
        });
      } else {
        setState(() {
          _appBarCollapsed = false;
          _animationController?.reverse();
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        profileAppBar(context, _appBarCollapsed),
        profileBody(),
      ],
    );
  }

  CurvedAnimation curvedAnimation() {
    return CurvedAnimation(
      parent: _animationController!,
      curve: Curves.linear,
    );
  }

  SliverAppBar profileAppBar(BuildContext context, bool isCollapsed) {
    return SliverAppBar(
      backgroundColor: AppColors.profilePrimary,
      automaticallyImplyLeading: false,
      pinned: true,
      expandedHeight: 400,
      collapsedHeight: 96,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              _profilePhoto,
              fit: BoxFit.cover,
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black12,
                    Colors.transparent,
                    Colors.black12,
                  ],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
            ),
          ],
        ),
        title: Stack(
          children: [
            expandedAppBar(isCollapsed, context),
            collapsedAppBar(isCollapsed),
          ],
        ),
        titlePadding: const EdgeInsets.only(bottom: 8),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            onPressed: () {
              widget.scaffoldKey.currentState?.openDrawer();
            },
            icon: const Icon(
              Icons.contact_mail,
              size: 32,
            ),
          ),
        ),
      ],
    );
  }

  FadeTransition collapsedAppBar(bool isCollapsed) {
    return FadeTransition(
      opacity: _opacityAnimation!,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: isCollapsed
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      height: 72,
                      child: Image.network(
                        _profilePhoto,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Alexandre Freitas',
                    style: AppTextStyles.textMediumWhite24,
                  ),
                ],
              )
            : const SizedBox(),
      ),
    );
  }

  FadeTransition expandedAppBar(bool isCollapsed, BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimationReverse!,
      child: !isCollapsed
          ? SizedBox(
              height: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 8.0),
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.5,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      color: AppColors.white.withOpacity(0.8),
                    ),
                    child: Text(
                      'Alexandre Gazar Libório de Freitas',
                      style: AppTextStyles.textMediumWhite16.copyWith(
                        color: AppColors.profilePrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.only(left: 8.0),
                    height: 12,
                    child: const Text(
                      'Mobile Software Developer',
                      style: AppTextStyles.textNormal12,
                    ),
                  ),
                ],
              ),
            )
          : const SizedBox(),
    );
  }

  Widget profileBody() {
    final skills = SkillsData;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24),
            Text(
              'Sobre Mim:',
              style: AppTextStyles.textRegular16.copyWith(color: AppColors.profilePrimary),
            ),
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: AppColors.profilePrimary,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(8),
              child: Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Purus faucibus ornare suspendisse sed. Egestas maecenas pharetra convallis posuere morbi leo. Cras tincidunt lobortis feugiat vivamus at. Nulla malesuada pellentesque elit eget gravida cum. In nulla posuere sollicitudin aliquam. Nec feugiat in fermentum posuere urna. Orci porta non pulvinar neque laoreet. Ac odio tempor orci dapibus ultrices in iaculis. Urna neque viverra justo nec ultrices dui sapien eget. Bibendum arcu vitae elementum curabitur. Enim facilisis gravida neque convallis. Odio ut enim blandit volutpat maecenas.',
                style: AppTextStyles.textWhite.copyWith(color: AppColors.profilePrimary),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Habilidades:',
              style: AppTextStyles.textRegular16.copyWith(color: AppColors.profilePrimary),
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: skills.map((e) => SkillsCustomChip(skill: e)).toList(),
            ),
            SizedBox(height: 24),
            Text(
              'Idiomas:',
              style: AppTextStyles.textRegular16.copyWith(color: AppColors.profilePrimary),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 500,
              child: Center(
                child: Text('Languages Placeholder'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
