import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/api/auth_webclient.dart';
import '../../common/bloc/certificatesBloc/certificates_bloc.dart';
import '../../common/bloc/depositionsBloc/depositions_bloc.dart';
import '../../common/bloc/workHistoryBloc/work_history_bloc.dart';
import '../../common/enums/nav_bar_items.dart';
import '../../common/models/personal_data.dart';
import '../../common/util/connectivity_util.dart';
import '../../common/util/shared_preferences_util.dart';
import '../../common/widgets/CustomDrawer/custom_drawer.dart';
import '../../common/widgets/custom_screen.dart';
import '../../core/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../CertificatesScreen/certificates_screen.dart';
import '../DepositionsScreen/depositions_screen.dart';
import '../ProfileScreen/profile_screen.dart';
import '../WorkHistoryScreen/work_history_screen.dart';
import 'components/custom_bottom_nav_bar.dart';

class NavigationManagementScreenContainer extends StatelessWidget {
  const NavigationManagementScreenContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => DepositionsBloc()),
        BlocProvider(create: (context) => CertificatesBloc()),
        BlocProvider(create: (context) => WorkHistoryBloc()),
      ],
      child: const NavigationManagementScreen(),
    );
  }
}

class NavigationManagementScreen extends StatefulWidget {
  final ConnectivityUtil? connectivityUtil;
  const NavigationManagementScreen({this.connectivityUtil, super.key});

  @override
  State<NavigationManagementScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<NavigationManagementScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final _controller = PageController(initialPage: 0);
  final FocusNode _nameTextFocus = FocusNode();
  final FocusNode _relationshipTextFocus = FocusNode();
  final FocusNode _depositionTextFocus = FocusNode();
  late User user;
  late final ConnectivityUtil _connectivityUtil;
  StreamSubscription<bool>? _connectivitySubscription;
  StreamSubscription<String>? _tokenRefreshSubscription;
  bool? _wasConnected;
  List<Reference> resumesList = [];
  PersonalData personalData = PersonalData();
  int _index = 0;
  Color tabActiveColor = AppColors.profilePrimary;
  bool _isAdmin = false;

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser!;
    _connectivityUtil = widget.connectivityUtil ?? ConnectivityUtil();
    getUserRole();
    getCurriculum();
    getPersonalData();
    _registerFcmToken();
    _tokenRefreshSubscription = FirebaseMessaging.instance.onTokenRefresh.listen(_saveFcmToken);
    _connectivitySubscription = _connectivityUtil.watchConnected().listen(_refetchOnReconnect);
    super.initState();
  }

  // Lets the notifyAdminOnNewDeposition Cloud Function reach this device:
  // anonymous viewers are skipped since only an admin account ever gets
  // notified, so there's nothing useful to store for them.
  Future<void> _registerFcmToken() async {
    if (user.isAnonymous) return;
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) await _saveFcmToken(token);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> _saveFcmToken(String token) async {
    try {
      await AuthWebclient(auth: FirebaseAuth.instance).updateFcmToken(token);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // getUserRole/getCurriculum/getPersonalData only ever run once, in
  // initState — without this, coming back online after a real offline
  // period wouldn't refresh their one-shot Storage/Firestore reads until
  // the screen remounts.
  void _refetchOnReconnect(bool connected) {
    if (connected && _wasConnected == false) {
      getUserRole();
      getCurriculum();
      getPersonalData();
    }
    _wasConnected = connected;
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    _tokenRefreshSubscription?.cancel();
    if (widget.connectivityUtil == null) {
      _connectivityUtil.dispose();
    }
    _controller.dispose();
    _nameTextFocus.dispose();
    _relationshipTextFocus.dispose();
    _depositionTextFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return Scaffold(
      key: _scaffoldKey,
      drawer:
          personalData.email.isEmpty
              ? null
              : CustomDrawer(
                resumesList: resumesList,
                personalData: personalData,
              ),
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: changeScreenBySliding,
            children: [
              ProfileScreen(
                scaffoldKey: _scaffoldKey,
                aboutMeText: personalData.aboutMeTexts,
              ),
              CustomScreen(
                tabColor: AppColors.certificatesPrimary,
                title: text.certificatesTitle,
                subtitle: text.certificatesSubtitle,
                tabIcon: Icons.school,
                isAdmin: _isAdmin,
                screenBody: CertificatesScreen(isAdmin: _isAdmin),
              ),
              CustomScreen(
                tabColor: AppColors.workHistoryPrimary,
                title: text.workHistoryTitle,
                subtitle: text.workHistorySubtitle,
                tabIcon: Icons.work,
                isAdmin: _isAdmin,
                screenBody: WorkHistoryScreen(isAdmin: _isAdmin),
              ),
              CustomScreen(
                tabColor: AppColors.depositionsPrimary,
                title: text.depositionsTitle,
                subtitle: text.depositionsSubtitle,
                tabIcon: Icons.comment,
                screenBody: DepositionsScreen(
                  nameTextFocus: _nameTextFocus,
                  relationshipTextFocus: _relationshipTextFocus,
                  depositionTextFocus: _depositionTextFocus,
                  isAdmin: _isAdmin,
                ),
              ),
            ],
          ),
          CustomBottomNavBar(
            changeScreen: changeScreen,
            index: _index,
            tabActiveColor: tabActiveColor,
          ).animate().fadeIn(duration: 1600.ms),
        ],
      ),
    );
  }

  Future<void> getUserRole() async {
    try {
      final isAdmin = await AuthWebclient(auth: FirebaseAuth.instance).getUserRole();
      if (!mounted) return;
      setState(() {
        _isAdmin = isAdmin;
      });
    } catch (e) {
      // Falls back to the non-admin default set above — e.g. a first-ever
      // fetch while offline, with nothing cached yet.
      debugPrint(e.toString());
    }
  }

  Future<void> getCurriculum() async {
    // Unlike RTDB/Firestore, Storage's listAll() has no offline cache of its
    // own, so show the last known file names first — building a Reference
    // needs no network round-trip, and ResumeUtil.downloadResume already
    // serves the disk-cached PDF once its own metadata check fails offline —
    // instead of leaving the drawer empty while waiting on the network call.
    final cachedNames = await SharedPreferencesUtil.getCachedResumeNames();
    if (cachedNames.isNotEmpty && mounted) {
      setState(() {
        resumesList = cachedNames.map((name) => FirebaseStorage.instance.ref('/resumes/$name')).toList();
      });
    }

    try {
      final response = await FirebaseStorage.instance.ref('/resumes').listAll();
      if (response.items.isNotEmpty) {
        if (mounted) {
          setState(() {
            resumesList = response.items;
          });
        }
        await SharedPreferencesUtil.setCachedResumeNames(response.items.map((item) => item.name).toList());
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getPersonalData() async {
    final authWebclient = AuthWebclient(auth: FirebaseAuth.instance);
    // Firestore's default get() tries the server first and only falls back
    // to its on-disk cache once that fails, so read the cache explicitly
    // first — same as the resume/getCurriculum fix — to show a cached
    // profile immediately instead of waiting on that round-trip.
    try {
      final cached = await authWebclient.getPersonalData(source: Source.cache);
      if (mounted) {
        setState(() {
          personalData = cached;
        });
      }
    } catch (e) {
      // No cached document yet — e.g. a first-ever fetch while offline.
      debugPrint(e.toString());
    }

    try {
      final response = await authWebclient.getPersonalData();
      if (mounted) {
        setState(() {
          personalData = response;
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void changeScreen(int index, Color activeColor) {
    setState(() {
      _index = index;
      tabActiveColor = activeColor;
      _controller.jumpToPage(index);
      _nameTextFocus.unfocus();
      _relationshipTextFocus.unfocus();
      _depositionTextFocus.unfocus();
    });
  }

  void changeScreenBySliding(int index) {
    setState(() {
      _nameTextFocus.unfocus();
      _relationshipTextFocus.unfocus();
      _depositionTextFocus.unfocus();
      _index = index;
      if (index == NavBarItems.PROFILE.value) {
        tabActiveColor = NavBarItems.PROFILE.color;
      }
      if (index == NavBarItems.CERTIFICATES.value) {
        tabActiveColor = NavBarItems.CERTIFICATES.color;
      }
      if (index == NavBarItems.WORKHISTORY.value) {
        tabActiveColor = NavBarItems.WORKHISTORY.color;
      }
      if (index == NavBarItems.DEPOSITIONS.value) {
        tabActiveColor = NavBarItems.DEPOSITIONS.color;
      }
    });
  }
}
