import 'package:flutter/material.dart';
import 'package:flutter_profile/core/app_colors.dart';
import 'package:flutter_profile/core/app_text_styles.dart';
import 'package:flutter_profile/data/skills_data.dart';
import 'package:flutter_profile/common/widgets/custom_form.dart';

import 'components/language_progress_bar.dart';
import 'components/skills_custom_chip.dart';

const String _profilePhoto =
    'https://media-exp2.licdn.com/dms/image/C5603AQHlAkM0n6T-ww/profile-displayphoto-shrink_200_200/0/1600175926661?e=1660176000&v=beta&t=s4jJWz16wkOgtdAAhpUfM5-WHs80ivb6iao2yNwA6VM';

class ProfileScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const ProfileScreen({
    Key? key,
    required this.scaffoldKey,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  bool _appBarCollapsed = false;
  bool isLogged = false;
  bool _languageBarIsVisible = false;
  final _formKey = GlobalKey<FormState>();
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
      if (_scrollController.position.pixels > 305) {
        setState(() {
          _languageBarIsVisible = true;
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

  curvedAnimation() {
    return CurvedAnimation(
      parent: _animationController!,
      curve: Curves.linear,
    );
  }

  profileAppBar(BuildContext context, bool isCollapsed) {
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
            FadeInImage(
              placeholder: const AssetImage('assets/images/person_placeholder.png'),
              placeholderFit: BoxFit.cover,
              imageErrorBuilder: (context, error, stackTrace) => Image.asset(
                'assets/images/person_placeholder.png',
                fit: BoxFit.cover,
              ),
              image: const NetworkImage(_profilePhoto),
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
          padding: const EdgeInsets.only(
            top: 8.0,
            right: 16,
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  widget.scaffoldKey.currentState?.openDrawer();
                },
                icon: const Icon(
                  Icons.contact_mail,
                  size: 24,
                ),
              ),
              if (!isLogged)
                IconButton(
                  onPressed: () {
                    showDialog(
                      // barrierColor: AppColors.lightGrey.withOpacity(0.4),
                      context: context,
                      builder: (context) => Dialog(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: AppColors.profilePrimary, width: 4),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 0,
                              child: Image.asset('assets/images/login_background.png'),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Entre com seu Nome e E-mail para acessar algumas funções do aplicativo!',
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.textSize16.copyWith(color: AppColors.profilePrimary),
                                  ),
                                  const SizedBox(height: 16),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    height: 160,
                                    child: CustomForm(formKey: _formKey),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(primary: AppColors.profilePrimary),
                                      onPressed: () {
                                        setState(() {
                                          isLogged = true;
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Entrar'),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.login,
                    size: 24,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  collapsedAppBar(bool isCollapsed) {
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
                      child: FadeInImage(
                        placeholder: const AssetImage('assets/images/person_placeholder.png'),
                        placeholderFit: BoxFit.cover,
                        imageErrorBuilder: (context, error, stackTrace) => Image.asset(
                          'assets/images/person_placeholder.png',
                          fit: BoxFit.cover,
                        ),
                        image: const NetworkImage(_profilePhoto),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Alexandre Freitas',
                    style: AppTextStyles.textSize24.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
            : const SizedBox(),
      ),
    );
  }

  expandedAppBar(bool isCollapsed, BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimationReverse!,
      child: !isCollapsed
          ? SizedBox(
              height: 64,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 8.0),
                    height: 44,
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
                      style: AppTextStyles.textSize16.copyWith(
                        color: AppColors.profilePrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.only(left: 8.0),
                    height: 16,
                    child: const Text(
                      'Mobile Software Developer',
                      style: AppTextStyles.textSize12,
                    ),
                  ),
                ],
              ),
            )
          : const SizedBox(),
    );
  }

  profileBody() {
    final skills = SkillsData;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text(
              'Sobre Mim:',
              style: AppTextStyles.textSize16.copyWith(
                color: AppColors.profilePrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              child: Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Purus faucibus ornare suspendisse sed. Egestas maecenas pharetra convallis posuere morbi leo. Cras tincidunt lobortis feugiat vivamus at. Nulla malesuada pellentesque elit eget gravida cum. In nulla posuere sollicitudin aliquam. Nec feugiat in fermentum posuere urna. Orci porta non pulvinar neque laoreet. Ac odio tempor orci dapibus ultrices in iaculis. Urna neque viverra justo nec ultrices dui sapien eget. Bibendum arcu vitae elementum curabitur. Enim facilisis gravida neque convallis. Odio ut enim blandit volutpat maecenas.',
                style: AppTextStyles.textWhite.copyWith(color: AppColors.profilePrimary),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Habilidades:',
              style: AppTextStyles.textSize16.copyWith(
                color: AppColors.profilePrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: skills.map((e) => SkillsCustomChip(skill: e, isLogged: isLogged)).toList(),
            ),
            const SizedBox(height: 24),
            Text(
              'Idiomas:',
              style: AppTextStyles.textSize16.copyWith(
                color: AppColors.profilePrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                LanguageProgressBar(
                  languageTitle: 'Portugês',
                  languageLevel: 4,
                  languageBarisVisible: _languageBarIsVisible,
                ),
                LanguageProgressBar(
                  languageTitle: 'Inglês',
                  languageLevel: 3,
                  languageBarisVisible: _languageBarIsVisible,
                ),
                LanguageProgressBar(
                  languageTitle: 'Espanhol',
                  languageLevel: 2,
                  languageBarisVisible: _languageBarIsVisible,
                ),
                LanguageProgressBar(
                  languageTitle: 'Chinês',
                  languageLevel: 1,
                  languageBarisVisible: _languageBarIsVisible,
                ),
              ],
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
