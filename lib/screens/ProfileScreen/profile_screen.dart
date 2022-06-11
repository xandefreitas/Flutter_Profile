import 'package:flutter/material.dart';
import 'package:flutter_profile/core/app_colors.dart';

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
                    style: TextStyle(fontSize: 24),
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
                    child: const Text(
                      'Alexandre Gazar Libório de Freitas',
                      style: TextStyle(
                        fontSize: 16,
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
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const SizedBox(),
    );
  }

  Widget profileBody() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SizedBox(
              height: 500,
              child: Center(
                child: Text('About Placeholder'),
              ),
            ),
            SizedBox(
              height: 500,
              child: Center(
                child: Text('Skills Placeholder'),
              ),
            ),
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
