import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_profile/core/app_colors.dart';
import 'package:flutter_profile/core/app_text_styles.dart';
import 'package:flutter_profile/screens/WorkHistoryScreen/components/cards/work_history_card.dart';
import 'package:flutter_profile/screens/WorkHistoryScreen/components/cards/work_history_shimmer_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../common/bloc/workHistoryBloc/work_history_bloc.dart';
import '../../common/bloc/workHistoryBloc/work_history_event.dart';
import '../../common/bloc/workHistoryBloc/work_history_state.dart';
import '../../common/models/company.dart';
import '../../common/util/snackbar_util.dart';
import '../../common/widgets/CustomSnackBar/custom_snackbar.dart';
import 'components/cards/work_history_add_card.dart';

class WorkHistoryScreen extends StatefulWidget {
  final bool isAdmin;
  const WorkHistoryScreen({
    required this.isAdmin,
    Key? key,
  }) : super(key: key);

  @override
  State<WorkHistoryScreen> createState() => _EmploymentHistoryScreenState();
}

class _EmploymentHistoryScreenState extends State<WorkHistoryScreen> {
  final _controller = PageController(initialPage: 0);
  List<Company> companyData = [];
  int _currentPage = 0;
  int _lastPage = 0;
  bool isLoading = true;
  late AppLocalizations text;

  @override
  void initState() {
    getWorkHistoryList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    text = AppLocalizations.of(context)!;
    return BlocConsumer<WorkHistoryBloc, WorkHistoryState>(
      listener: (context, state) {
        if (state is WorkHistoryFetchingState) {
          isLoading = true;
        }
        if (state is WorkHistoryFetchedState) {
          companyData = state.workHistory;
          _currentPage = _controller.initialPage + 1;
          _lastPage = widget.isAdmin ? companyData.length + 1 : companyData.length;
          isLoading = false;
        }
        if (state is WorkHistoryAddingState) {
          isLoading = true;
        }
        if (state is WorkHistoryAddedState) {
          getWorkHistoryList();
        }
        if (state is WorkHistoryUpdatingState) {
          isLoading = true;
        }
        if (state is WorkHistoryUpdatedState) {
          getWorkHistoryList();
        }
        if (state is WorkHistoryRemovingState) {
          isLoading = true;
        }
        if (state is WorkHistoryRemovedState) {
          getWorkHistoryList();
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
            child: isLoading
                ? const WorkHistoryShimmerCard()
                : Column(
                    children: [
                      Expanded(
                        child: PageView(
                          controller: _controller,
                          physics: const NeverScrollableScrollPhysics(),
                          onPageChanged: (page) {
                            setState(() {
                              _currentPage = page + 1;
                            });
                          },
                          children: [
                            ...companyData
                                .map((e) => WorkHistoryCard(
                                      company: e,
                                      updateWorkHistory: updateWorkHistory,
                                      removeWorkHistory: removeWorkHistory,
                                      isAdmin: widget.isAdmin,
                                    ))
                                .toList(),
                            if (widget.isAdmin) WorkHistoryAddCard(addWorkHistory: addWorkHistory),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: companyData.isEmpty || (companyData.length == 1 && !widget.isAdmin) ? 88 : 72.0,
                        ),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: companyData.isEmpty && !widget.isAdmin
                              ? const SizedBox()
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _currentPage != 1
                                        ? IconButton(
                                            onPressed: () =>
                                                _controller.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.ease),
                                            icon: const Icon(
                                              Icons.arrow_back_ios,
                                              size: kIsWeb ? 24 : 16,
                                              color: AppColors.workHistoryPrimary,
                                            ),
                                          )
                                        : const SizedBox(width: kIsWeb ? 40 : 48),
                                    Text(
                                      '$_currentPage/$_lastPage',
                                      style: AppTextStyles.textSize12.copyWith(color: AppColors.workHistoryPrimary, fontSize: kIsWeb ? 16 : 12),
                                    ),
                                    _currentPage != _lastPage
                                        ? IconButton(
                                            onPressed: () => _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease),
                                            icon: const Icon(
                                              Icons.arrow_forward_ios,
                                              size: kIsWeb ? 24 : 16,
                                              color: AppColors.workHistoryPrimary,
                                            ),
                                          )
                                        : const SizedBox(width: kIsWeb ? 40 : 48),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  getWorkHistoryList() {
    context.read<WorkHistoryBloc>().add(WorkHistoryFetchEvent());
  }

  addWorkHistory(Company company) {
    context.read<WorkHistoryBloc>().add(WorkHistoryAddEvent(company: company));
  }

  updateWorkHistory(Company company) {
    context.read<WorkHistoryBloc>().add(WorkHistoryUpdateEvent(company: company));
  }

  removeWorkHistory(String companyId) {
    context.read<WorkHistoryBloc>().add(WorkHistoryRemoveEvent(companyId: companyId));
  }
}
