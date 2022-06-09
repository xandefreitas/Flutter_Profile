import 'package:flutter/material.dart';
import 'package:flutter_profile/common/widgets/custom_button_widget.dart';
import 'package:flutter_profile/screens/ProfileScreen/components/drawer_title.dart';

const String _profilePhoto =
    'https://media-exp2.licdn.com/dms/image/C5603AQHlAkM0n6T-ww/profile-displayphoto-shrink_200_200/0/1600175926661?e=1660176000&v=beta&t=s4jJWz16wkOgtdAAhpUfM5-WHs80ivb6iao2yNwA6VM';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

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
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DrawerTitle(title: 'Entre em Contato'),
              Row(
                children: [
                  CustomIconButton(
                    onTap: () {},
                    icon: const Icon(
                      Icons.catching_pokemon,
                      color: Color(0xff525B76),
                    ),
                  ),
                  CustomIconButton(
                    onTap: () {},
                    icon: const Icon(
                      Icons.catching_pokemon,
                      color: Color(0xff525B76),
                    ),
                  ),
                  CustomIconButton(
                    onTap: () {},
                    icon: const Icon(
                      Icons.catching_pokemon,
                      color: Color(0xff525B76),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      '+55 (71) 99711-0012',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff525B76),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'alexandrefreitas.dev@gmail.com',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff525B76),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const DrawerTitle(title: 'Currículo'),
              const SizedBox(height: 8),
              curriculumDownloadItem('Português'),
              curriculumDownloadItem('English'),
              const Spacer(),
              const Padding(
                padding: EdgeInsets.only(left: 16.0, bottom: 16),
                child: Text(
                  'Obrigado!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff525B76),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          profileAppBar(context, _appBarCollapsed),
          profileBody(),
        ],
      ),
    );
  }

  Row curriculumDownloadItem(String title) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomIconButton(
          onTap: () {},
          icon: const Icon(
            Icons.file_download,
            size: 32,
            color: Color(0xff525B76),
          ),
        ),
        const SizedBox(width: 8),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }

  SliverAppBar profileAppBar(BuildContext context, bool isCollapsed) {
    return SliverAppBar(
      backgroundColor: const Color(0xff525B76),
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
              _scaffoldKey.currentState?.openDrawer();
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

  CurvedAnimation curvedAnimation() {
    return CurvedAnimation(
      parent: _animationController!,
      curve: Curves.linear,
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
                      color: const Color(0xffFFFFFF).withOpacity(0.8),
                    ),
                    child: const Text(
                      'Alexandre Gazar Libório de Freitas',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff525B76),
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

  Widget profileBody() => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: const BoxDecoration(color: Color(0xffBA3F1D)),
                height: 500,
                child: const Center(
                  child: Text('About Placeholder'),
                ),
              ),
              Container(
                decoration: const BoxDecoration(color: Color(0xff3D1400)),
                height: 500,
                child: const Center(
                  child: Text('Skills Placeholder'),
                ),
              ),
              Container(
                decoration: const BoxDecoration(color: Color(0xff29524A)),
                height: 500,
                child: const Center(
                  child: Text('Languages Placeholder'),
                ),
              ),
            ],
          ),
        ),
      );
}
