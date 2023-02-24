import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';

import '../../../common/util/app_routes.dart';
import '../../../core/core.dart';

class ProfileAppBar extends StatefulWidget {
  final bool appBarCollapsed;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final AnimationController animationController;
  const ProfileAppBar({
    required this.scaffoldKey,
    required this.appBarCollapsed,
    required this.animationController,
    super.key,
  });

  @override
  State<ProfileAppBar> createState() => _ProfileAppBarState();
}

class _ProfileAppBarState extends State<ProfileAppBar> {
  final String _profilePhoto = Consts.profilePhoto;
  final FirebaseAuth auth = FirebaseAuth.instance;
  late Animation<double> _opacityAnimation;
  late Animation<double> _opacityAnimationReverse;

  @override
  void initState() {
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      curvedAnimation(),
    );
    _opacityAnimationReverse = Tween(begin: 1.0, end: 0.0).animate(
      curvedAnimation(),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return SliverAppBar(
      backgroundColor: AppColors.profilePrimary,
      automaticallyImplyLeading: false,
      forceElevated: true,
      pinned: true,
      expandedHeight: kIsWeb ? 0 : 384,
      collapsedHeight: 120,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Visibility(
              visible: !kIsWeb,
              child: CachedNetworkImage(
                imageUrl: _profilePhoto,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: AppColors.white.withOpacity(0.2),
                  highlightColor: AppColors.profilePrimary,
                  child: Image.asset(
                    'assets/images/person_placeholder.png',
                    fit: BoxFit.fitHeight,
                  ),
                ),
                errorWidget: (context, url, error) => Shimmer.fromColors(
                  baseColor: AppColors.white.withOpacity(0.2),
                  highlightColor: AppColors.profilePrimary,
                  child: Image.asset(
                    'assets/images/person_placeholder.png',
                    fit: BoxFit.fitHeight,
                  ),
                ),
                imageBuilder: ((context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                      ),
                    )),
              ),
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
        title: widget.appBarCollapsed
            ? FadeTransition(
                opacity: _opacityAnimation,
                child: Padding(
                  padding: const EdgeInsets.only(left: kIsWeb ? 160 : 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          height: 80,
                          width: 80,
                          child: CachedNetworkImage(
                            imageUrl: _profilePhoto,
                            placeholder: (context, url) => Image.asset(
                              'assets/images/person_placeholder.png',
                              fit: BoxFit.cover,
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              'assets/images/person_placeholder.png',
                              fit: BoxFit.cover,
                            ),
                            imageBuilder: ((context, imageProvider) => Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                  ),
                                )),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            Consts.shortName,
                            style: AppTextStyles.textSize24.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            text.profileRole,
                            style: AppTextStyles.textWhite.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ).animate().fadeIn(duration: 600.ms),
                    ],
                  ),
                ),
              )
            : FadeTransition(
                opacity: _opacityAnimationReverse,
                child: SizedBox(
                  height: 64,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                          Consts.fullName,
                          style: AppTextStyles.textSize16.copyWith(
                            color: AppColors.profilePrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ).animate().fadeIn(duration: 600.ms, curve: Curves.easeInOutCubic).slideX(),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.only(left: 8.0),
                        height: 16,
                        child: Text(
                          text.profileRole,
                          style: AppTextStyles.textSize12,
                        ),
                      ).animate().fadeIn(delay: 400.ms, duration: 600.ms).slideX(),
                    ],
                  ),
                ),
              ),
        titlePadding: const EdgeInsets.only(bottom: 8),
      ),
      leadingWidth: MediaQuery.of(context).size.width,
      leading: Visibility(
        visible: !widget.appBarCollapsed,
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                widget.scaffoldKey.currentState?.openDrawer();
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.only(left: 8),
                decoration: BoxDecoration(
                  color: AppColors.profilePrimary.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.account_box_rounded,
                      size: 24,
                    ),
                    Text(text.profileMenuButton),
                  ],
                ),
              ),
            ).animate().fadeIn(duration: 600.ms),
            Visibility(
              visible: auth.currentUser!.isAnonymous,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, onboardingRoute, arguments: {"page": 1});
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  margin: const EdgeInsets.only(left: 8.0),
                  decoration: BoxDecoration(
                    color: AppColors.profilePrimary.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.login,
                        size: 24,
                      ),
                      Text(text.profileLoginButton),
                    ],
                  ),
                ),
              ).animate().then(delay: 300.ms).fadeIn(duration: 600.ms),
            ),
          ],
        ),
      ),
      actions: [
        Visibility(
          visible: widget.appBarCollapsed,
          child: Container(
            padding: const EdgeInsets.only(right: kIsWeb ? 160 : 16, left: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Visibility(
                  visible: auth.currentUser!.isAnonymous,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, onboardingRoute, arguments: {"page": 1});
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.login,
                          size: 24,
                        ),
                        Text(text.profileLoginButton),
                      ],
                    ),
                  ).animate().then(delay: 300.ms).fadeIn(duration: 600.ms),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      widget.scaffoldKey.currentState?.openDrawer();
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.account_box_rounded,
                          size: 24,
                        ),
                        Text(text.profileMenuButton),
                      ],
                    ),
                  ).animate().fadeIn(duration: 600.ms),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  curvedAnimation() {
    return CurvedAnimation(
      parent: widget.animationController,
      curve: Curves.linear,
    );
  }
}
