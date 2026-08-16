import 'package:flutter/material.dart';

import 'components/profile_app_bar.dart';
import 'components/profile_screen_body.dart';

class ProfileScreen extends StatefulWidget {
  final List<String> aboutMeText;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const ProfileScreen({
    required this.scaffoldKey,
    required this.aboutMeText,
    super.key,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  bool _appBarCollapsed = false;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scrollController.addListener(() {
      if (_scrollController.position.pixels > 264) {
        setState(() {
          _appBarCollapsed = true;
          _animationController.forward();
        });
      } else {
        setState(() {
          _appBarCollapsed = false;
          _animationController.reverse();
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        ProfileAppBar(
          scaffoldKey: widget.scaffoldKey,
          appBarCollapsed: _appBarCollapsed,
          animationController: _animationController,
        ),
        SliverToBoxAdapter(
          child: ProfileScreenBody(aboutMeText: widget.aboutMeText),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
