import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/bloc/workHistoryBloc/work_history_bloc.dart';
import '../../common/bloc/workHistoryBloc/work_history_event.dart';
import '../../common/bloc/workHistoryBloc/work_history_state.dart';
import '../../common/models/company.dart';
import '../../common/util/date_util.dart';
import '../../common/util/snackbar_util.dart';
import '../../common/widgets/CustomSnackBar/custom_snackbar.dart';
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../l10n/app_localizations.dart';
import 'components/cards/work_history_add_card.dart';
import 'components/cards/work_history_card.dart';
import 'components/cards/work_history_shimmer_card.dart';
import 'components/page_nav_button.dart';

class WorkHistoryScreen extends StatefulWidget {
  final bool isAdmin;
  const WorkHistoryScreen({required this.isAdmin, super.key});

  @override
  State<WorkHistoryScreen> createState() => _EmploymentHistoryScreenState();
}

class _EmploymentHistoryScreenState extends State<WorkHistoryScreen> {
  final _controller = PageController(initialPage: 0);
  List<Company> companyData = [];
  int _currentPage = 0;
  bool isLoading = true;

  int get _lastPage =>
      widget.isAdmin ? companyData.length + 1 : companyData.length;

  @override
  void initState() {
    getWorkHistoryList();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return BlocConsumer<WorkHistoryBloc, WorkHistoryState>(
      listener: (context, state) {
        if (state is WorkHistoryLoadingState) {
          isLoading = true;
        }
        if (state is WorkHistoryFetchedState) {
          companyData = state.workHistory;
          _sortCompanyDataByLatestOccupation();
          _currentPage = _controller.initialPage + 1;
          isLoading = false;
        }
        if (state is WorkHistoryAddedState) {
          isLoading = false;
          companyData = [...companyData, state.company];
          _sortCompanyDataByLatestOccupation();
          _showSuccessSnackBar(
            context,
            text,
            text.successSnackBarAddedWorkHistory,
          );
        }
        if (state is WorkHistoryUpdatedState) {
          isLoading = false;
          _currentPage = _controller.initialPage + 1;
          companyData = [
            for (final company in companyData)
              company.id == state.company.id ? state.company : company,
          ];
          _sortCompanyDataByLatestOccupation();
          _showSuccessSnackBar(
            context,
            text,
            text.successSnackBarUpdatedWorkHistory,
          );
        }
        if (state is WorkHistoryRemovedState) {
          isLoading = false;
          companyData =
              companyData
                  .where((company) => company.id != state.companyId)
                  .toList();
          _showSuccessSnackBar(
            context,
            text,
            text.successSnackBarRemovedWorkHistory,
          );
        }
        if (state is WorkHistoryErrorState) {
          SnackBarUtil.showCustomSnackBar(
            context: context,
            snackbar: ErrorSnackBar(
              title: text.snackBarGenericErrorTitle,
              subtitle: state.exception.toString(),
            ),
          );
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 160.0),
            child:
                isLoading
                    ? const WorkHistoryShimmerCard()
                    : Column(
                      children: [
                        Expanded(
                          child: PageView(
                            controller: _controller,
                            onPageChanged: (page) {
                              setState(() {
                                _currentPage = page + 1;
                              });
                            },
                            children: [
                              if (widget.isAdmin)
                                WorkHistoryAddCard(
                                  addWorkHistory: addWorkHistory,
                                ),
                              ...companyData.map(
                                (e) => WorkHistoryCard(
                                  company: e,
                                  updateWorkHistory: updateWorkHistory,
                                  removeWorkHistory: removeWorkHistory,
                                  isAdmin: widget.isAdmin,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            bottom:
                                companyData.isEmpty ||
                                        (companyData.length == 1 &&
                                            !widget.isAdmin)
                                    ? platformHeight() + 8
                                    : platformHeight(),
                          ),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child:
                                companyData.isEmpty && !widget.isAdmin
                                    ? const SizedBox()
                                    : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        PageNavButton(
                                          visible: _currentPage != 1,
                                          icon: Icons.arrow_back_ios,
                                          onPressed:
                                              () => _controller.previousPage(
                                                duration: const Duration(
                                                  milliseconds: 300,
                                                ),
                                                curve: Curves.ease,
                                              ),
                                        ),
                                        Text(
                                          '$_currentPage/$_lastPage',
                                          style: AppTextStyles.textSize12
                                              .copyWith(
                                                color:
                                                    AppColors
                                                        .workHistoryPrimary,
                                                fontSize: 12,
                                              ),
                                        ),
                                        PageNavButton(
                                          visible: _currentPage != _lastPage,
                                          icon: Icons.arrow_forward_ios,
                                          onPressed:
                                              () => _controller.nextPage(
                                                duration: const Duration(
                                                  milliseconds: 300,
                                                ),
                                                curve: Curves.ease,
                                              ),
                                        ),
                                      ],
                                    ),
                          ),
                        ),
                      ],
                    ).animate().fadeIn(),
          ),
        );
      },
    );
  }

  double platformHeight() => Platform.isIOS ? 48.0 : 80.0;

  void _showSuccessSnackBar(
    BuildContext context,
    AppLocalizations text,
    String subtitle,
  ) {
    SnackBarUtil.showCustomSnackBar(
      context: context,
      snackbar: SuccessSnackBar(
        title: text.snackBarGenericSuccessTitle,
        subtitle: subtitle,
      ),
    );
  }

  void _sortCompanyDataByLatestOccupation() {
    companyData.sort(
      (a, b) => DateUtil.formatDate(
        _latestOccupationStartDate(b),
      ).compareTo(DateUtil.formatDate(_latestOccupationStartDate(a))),
    );
  }

  String _latestOccupationStartDate(Company company) =>
      company.occupations.isEmpty ? '' : company.occupations.first.startDate;

  void getWorkHistoryList() {
    context.read<WorkHistoryBloc>().add(WorkHistoryFetchEvent());
  }

  void addWorkHistory(Company company) {
    context.read<WorkHistoryBloc>().add(WorkHistoryAddEvent(company: company));
  }

  void updateWorkHistory(Company company) {
    context.read<WorkHistoryBloc>().add(
      WorkHistoryUpdateEvent(company: company),
    );
  }

  void removeWorkHistory(String companyId) {
    Navigator.pop(context);
    context.read<WorkHistoryBloc>().add(
      WorkHistoryRemoveEvent(companyId: companyId),
    );
  }
}
