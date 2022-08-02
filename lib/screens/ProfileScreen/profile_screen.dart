import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile/common/util/app_routes.dart';
import '../../core/core.dart';
import 'components/profile_screen_body.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  bool _languageBarIsVisible = false;
  final _profilePhoto = Consts.profilePhoto;
  final ScrollController _scrollController = ScrollController();
  AnimationController? _animationController;
  Animation<double>? _opacityAnimation;
  Animation<double>? _opacityAnimationReverse;
  late AppLocalizations text;
  FirebaseAuth auth = FirebaseAuth.instance;

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
    if (kIsWeb) {
      setState(() {
        _appBarCollapsed = true;
        _languageBarIsVisible = true;
        _animationController?.forward();
      });
    } else {
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
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    text = AppLocalizations.of(context)!;
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        profileAppBar(),
        SliverToBoxAdapter(
          child: ProfileScreenBody(
            isLogged: !auth.currentUser!.isAnonymous,
            languageBarIsVisible: _languageBarIsVisible,
          ),
        ),
      ],
    );
  }

  curvedAnimation() {
    return CurvedAnimation(
      parent: _animationController!,
      curve: Curves.linear,
    );
  }

  profileAppBar() {
    return SliverAppBar(
      backgroundColor: AppColors.profilePrimary,
      automaticallyImplyLeading: false,
      pinned: true,
      expandedHeight: kIsWeb ? 0 : 400,
      collapsedHeight: 96,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (!kIsWeb)
              FadeInImage(
                placeholder: const AssetImage('assets/images/person_placeholder.png'),
                placeholderFit: BoxFit.cover,
                imageErrorBuilder: (context, error, stackTrace) => Image.asset(
                  'assets/images/person_placeholder.png',
                  fit: BoxFit.cover,
                ),
                image: NetworkImage(_profilePhoto),
                fit: BoxFit.fitHeight,
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
        title: animatedAppBar(),
        titlePadding: const EdgeInsets.only(bottom: 8),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, right: kIsWeb ? 160 : 16),
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
              if (auth.currentUser!.isAnonymous)
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, onboardingRoute, arguments: 1);
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

  animatedAppBar() {
    return _appBarCollapsed
        ? FadeTransition(
            opacity: _opacityAnimation!,
            child: Padding(
              padding: const EdgeInsets.only(left: kIsWeb ? 160 : 16.0),
              child: Row(
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
                        image: NetworkImage(_profilePhoto),
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
              ),
            ),
          )
        : FadeTransition(
            opacity: _opacityAnimationReverse!,
            child: SizedBox(
              height: 64,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
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
                    child: Text(
                      text.profileRole,
                      style: AppTextStyles.textSize12,
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
