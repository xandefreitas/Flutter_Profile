import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/bloc/workHistoryBloc/work_history_bloc.dart';
import '../../common/bloc/workHistoryBloc/work_history_event.dart';
import '../../common/bloc/workHistoryBloc/work_history_state.dart';
import '../../common/models/company.dart';
import '../../common/util/analytics_util.dart';
import '../../common/util/date_util.dart';
import '../../common/util/snackbar_util.dart';
import '../../common/widgets/CustomSnackBar/custom_snackbar.dart';
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
  List<Company> companyData = [];
  bool isLoading = true;

  @override
  void initState() {
    AnalyticsUtil.logWorkHistoryScreenVisit();
    getWorkHistoryList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 128.0, bottom: 72),
        child: BlocConsumer<WorkHistoryBloc, WorkHistoryState>(
          listener: (context, state) {
            if (state is WorkHistoryLoadingState) {
              isLoading = true;
            }
            if (state is WorkHistoryFetchedState) {
              companyData = state.workHistory;
              _sortCompanyDataByLatestOccupation();
              isLoading = false;
            }
            if (state is WorkHistoryAddedState) {
              // No manual list patch needed: the live subscription from
              // getWorkHistoryList() already reflects this change once the
              // write lands.
              isLoading = false;
              _showSuccessSnackBar(
                context,
                text,
                text.successSnackBarAddedWorkHistory,
              );
            }
            if (state is WorkHistoryUpdatedState) {
              isLoading = false;
              _showSuccessSnackBar(
                context,
                text,
                text.successSnackBarUpdatedWorkHistory,
              );
            }
            if (state is WorkHistoryRemovedState) {
              isLoading = false;
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
            return isLoading
                ? ListView.builder(
                  itemCount: 4,
                  itemBuilder: (context, index) => const WorkHistoryShimmerCard(),
                )
                : ListView(
                  children: [
                    if (widget.isAdmin)
                      WorkHistoryAddCard(addWorkHistory: addWorkHistory),
                    ...companyData.map(
                      (e) => WorkHistoryCard(
                        company: e,
                        updateWorkHistory: updateWorkHistory,
                        removeWorkHistory: removeWorkHistory,
                        isAdmin: widget.isAdmin,
                      ).animate().fadeIn(),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
          },
        ),
      ),
    );
  }

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
