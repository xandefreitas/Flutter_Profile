import 'package:flutter/material.dart';

const String _profilePhoto =
    'https://media-exp2.licdn.com/dms/image/C5603AQHlAkM0n6T-ww/profile-displayphoto-shrink_200_200/0/1600175926661?e=1660176000&v=beta&t=s4jJWz16wkOgtdAAhpUfM5-WHs80ivb6iao2yNwA6VM';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  AnimationController? _animationController;
  Animation<double>? _opacityAnimation;
  Animation<double>? _opacityAnimationReverse;
  bool _appBarCollapsed = false;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
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

  CurvedAnimation curvedAnimation() {
    return CurvedAnimation(
      parent: _animationController!,
      curve: Curves.linear,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          profileAppBar(context, _appBarCollapsed),
          profileBody(),
        ],
      ),
    );
  }

  SliverAppBar profileAppBar(BuildContext context, bool isCollapsed) {
    return SliverAppBar(
      backgroundColor: Color(0xff525B76),
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
        titlePadding: EdgeInsets.only(bottom: 8),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            icon: Icon(
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
                    child: AnimatedContainer(
                      height: 72,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.linear,
                      child: Image.network(
                        _profilePhoto,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Alexandre Freitas',
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              )
            : SizedBox(),
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
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      color: Color(0xffFFFFFF).withOpacity(0.8),
                    ),
                    child: Text(
                      'Alexandre Gazar Libório de Freitas',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff525B76),
                      ),
                    ),
                  ),
                  SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.only(left: 8.0),
                    height: 12,
                    child: Text(
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
          : SizedBox(),
    );
  }

  Widget profileBody() => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(color: Colors.red),
                height: 500,
                child: Center(
                  child: Text('About Placeholder'),
                ),
              ),
              Container(
                decoration: BoxDecoration(color: Colors.blue),
                height: 500,
                child: Center(
                  child: Text('Skills Placeholder'),
                ),
              ),
              Container(
                decoration: BoxDecoration(color: Colors.green),
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
