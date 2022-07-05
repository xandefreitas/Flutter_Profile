import 'package:flutter/material.dart';
import 'package:flutter_profile/core/app_colors.dart';
import 'package:flutter_profile/core/app_text_styles.dart';
import 'package:flutter_profile/data/company_data.dart';
import 'package:flutter_profile/screens/WorkHistoryScreen/components/work_history_screen_body.dart';

class WorkHistoryScreen extends StatefulWidget {
  const WorkHistoryScreen({Key? key}) : super(key: key);

  @override
  State<WorkHistoryScreen> createState() => _EmploymentHistoryScreenState();
}

class _EmploymentHistoryScreenState extends State<WorkHistoryScreen> {
  final _controller = PageController(initialPage: 0);
  final companyData = CompanyData;
  int _currentPage = 0;
  int _lastPage = 0;
  @override
  void initState() {
    _currentPage = _controller.initialPage + 1;
    _lastPage = companyData.length;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 160.0),
          child: PageView(
            controller: _controller,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (page) {
              setState(() {
                _currentPage = page + 1;
              });
            },
            children: companyData.map((e) => WorkHistoryScreenBody(company: e)).toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 80.0),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _currentPage != 1
                    ? IconButton(
                        onPressed: () => _controller.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease),
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          size: 16,
                          color: AppColors.experiencesPrimary,
                        ),
                      )
                    : const SizedBox(width: 48),
                Text(
                  '$_currentPage/$_lastPage',
                  style: AppTextStyles.textSize12.copyWith(color: AppColors.experiencesPrimary),
                ),
                _currentPage != _lastPage
                    ? IconButton(
                        onPressed: () => _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease),
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: AppColors.experiencesPrimary,
                        ),
                      )
                    : const SizedBox(width: 48),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
