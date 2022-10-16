import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
      pinned: true,
      expandedHeight: kIsWeb ? 0 : 400,
      collapsedHeight: 120,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (!kIsWeb)
              CachedNetworkImage(
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
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    )),
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
                            imageBuilder: ((context, imageProvider) =>
                                Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover),
                                  ),
                                )),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        Consts.shortName,
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
                          Consts.fullName,
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
              ),
        titlePadding: const EdgeInsets.only(bottom: 8),
      ),
      actions: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.profilePrimary.withOpacity(0.9),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(15),
              topLeft: Radius.circular(15),
            ),
          ),
          padding: const EdgeInsets.only(right: kIsWeb ? 160 : 16, left: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  widget.scaffoldKey.currentState?.openDrawer();
                },
                child: const Icon(
                  Icons.account_box_rounded,
                  size: 24,
                ),
              ),
              if (auth.currentUser!.isAnonymous)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, onboardingRoute,
                          arguments: {"page": 1});
                    },
                    child: const Icon(
                      Icons.login,
                      size: 24,
                    ),
                  ),
                ),
            ],
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
