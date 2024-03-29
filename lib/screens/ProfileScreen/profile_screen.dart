import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_profile/screens/ProfileScreen/components/profile_app_bar.dart';
import '../../common/bloc/skillsBloc/skills_bloc.dart';
import '../../common/bloc/skillsBloc/skills_event.dart';
import 'components/profile_screen_body.dart';

class ProfileScreen extends StatefulWidget {
  final List<String> aboutMeText;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const ProfileScreen({
    Key? key,
    required this.scaffoldKey,
    required this.aboutMeText,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  bool _appBarCollapsed = false;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    if (kIsWeb) {
      setState(() {
        _appBarCollapsed = true;
        _animationController.forward();
      });
    } else {
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
    }
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: CustomScrollView(
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
      ),
    );
  }

  Future<void> onRefresh() async {
    context.read<SkillsBloc>().add(SkillsFetchEvent());
  }

  @override
  bool get wantKeepAlive => true;
}
