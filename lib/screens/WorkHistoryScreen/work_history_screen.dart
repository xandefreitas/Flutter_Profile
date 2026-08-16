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
  int _lastPage = 0;
  bool isLoading = true;

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
        if (state is WorkHistoryFetchingState) {
          isLoading = true;
        }
        if (state is WorkHistoryFetchedState) {
          companyData = state.workHistory;
          companyData.sort(
            (a, b) => DateUtil.formatDate(
              b.occupations.first.startDate,
            ).compareTo(DateUtil.formatDate(a.occupations.first.startDate)),
          );
          _currentPage = _controller.initialPage + 1;
          _lastPage =
              widget.isAdmin ? companyData.length + 1 : companyData.length;
          isLoading = false;
        }
        if (state is WorkHistoryAddingState) {
          isLoading = true;
        }
        if (state is WorkHistoryAddedState) {
          isLoading = false;
          companyData = [...companyData, state.company];
          companyData.sort(
            (a, b) => DateUtil.formatDate(
              b.occupations.first.startDate,
            ).compareTo(DateUtil.formatDate(a.occupations.first.startDate)),
          );
          _lastPage =
              widget.isAdmin ? companyData.length + 1 : companyData.length;
          SnackBarUtil.showCustomSnackBar(
            context: context,
            snackbar: SuccessSnackBar(
              title: text.snackBarGenericSuccessTitle,
              subtitle: text.successSnackBarAddedWorkHistory,
            ),
          );
        }
        if (state is WorkHistoryUpdatingState) {
          isLoading = true;
        }
        if (state is WorkHistoryUpdatedState) {
          isLoading = false;
          companyData = [
            for (final company in companyData)
              company.id == state.company.id ? state.company : company,
          ];
          companyData.sort(
            (a, b) => DateUtil.formatDate(
              b.occupations.first.startDate,
            ).compareTo(DateUtil.formatDate(a.occupations.first.startDate)),
          );
          SnackBarUtil.showCustomSnackBar(
            context: context,
            snackbar: SuccessSnackBar(
              title: text.snackBarGenericSuccessTitle,
              subtitle: text.successSnackBarUpdatedWorkHistory,
            ),
          );
        }
        if (state is WorkHistoryRemovingState) {
          isLoading = true;
        }
        if (state is WorkHistoryRemovedState) {
          isLoading = false;
          companyData =
              companyData.where((company) => company.id != state.companyId).toList();
          _lastPage =
              widget.isAdmin ? companyData.length + 1 : companyData.length;
          SnackBarUtil.showCustomSnackBar(
            context: context,
            snackbar: SuccessSnackBar(
              title: text.snackBarGenericSuccessTitle,
              subtitle: text.successSnackBarRemovedWorkHistory,
            ),
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
                                        Visibility(
                                          visible: _currentPage != 1,
                                          replacement: const SizedBox(
                                            width: 48,
                                          ),
                                          child: IconButton(
                                            onPressed:
                                                () => _controller.previousPage(
                                                  duration: const Duration(
                                                    milliseconds: 300,
                                                  ),
                                                  curve: Curves.ease,
                                                ),
                                            icon: const Icon(
                                              Icons.arrow_back_ios,
                                              size: 16,
                                              color:
                                                  AppColors.workHistoryPrimary,
                                            ),
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
                                        Visibility(
                                          visible: _currentPage != _lastPage,
                                          replacement: const SizedBox(
                                            width: 48,
                                          ),
                                          child: IconButton(
                                            onPressed:
                                                () => _controller.nextPage(
                                                  duration: const Duration(
                                                    milliseconds: 300,
                                                  ),
                                                  curve: Curves.ease,
                                                ),
                                            icon: const Icon(
                                              Icons.arrow_forward_ios,
                                              size: 16,
                                              color:
                                                  AppColors.workHistoryPrimary,
                                            ),
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
