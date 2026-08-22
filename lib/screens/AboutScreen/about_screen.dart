import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../common/bloc/accountBloc/account_bloc.dart';
import '../../common/bloc/accountBloc/account_event.dart';
import '../../common/bloc/accountBloc/account_state.dart';
import '../../common/util/app_routes.dart';
import '../../common/util/snackbar_util.dart';
import '../../common/widgets/CustomSnackBar/custom_snackbar.dart';
import '../../common/widgets/custom_dialog.dart';
import '../../common/widgets/custom_pinput.dart';
import '../../core/app_colors.dart';
import '../../l10n/app_localizations.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(foregroundColor: AppColors.profilePrimary),
      body: SafeArea(
        child: BlocConsumer<AccountBloc, AccountState>(
          listener: (context, state) {
            if (state is AccountDeletedState) {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, loginManagementRoute);
            }
            if (state is AccountErrorState) {
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
            if (state is AccountLoadingState) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.profilePrimary,
                ),
              );
            }
            return Center(
              child: SizedBox(
                width: MediaQuery.sizeOf(context).width / 1.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(text.aboutInfoMessage, textAlign: TextAlign.center),
                    Divider(
                      color: AppColors.profilePrimary.withValues(alpha: 0.5),
                      thickness: 1,
                    ),
                    Text(
                      text.deleteAccountDisplayNameLabel(
                        FirebaseAuth.instance.currentUser?.displayName ?? '',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      text.deleteAccountPhoneNumberLabel(
                        FirebaseAuth.instance.currentUser?.phoneNumber ?? '',
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      child: Text(text.privacyPolicyButton),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          legalDocumentRoute,
                          arguments: {
                            'documentName': 'privacy_policy',
                            'title': text.privacyPolicyButton,
                          },
                        );
                      },
                    ),
                    ElevatedButton(
                      child: Text(text.termsOfServiceButton),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          legalDocumentRoute,
                          arguments: {
                            'documentName': 'terms_of_service',
                            'title': text.termsOfServiceButton,
                          },
                        );
                      },
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        final accountBloc = context.read<AccountBloc>();
                        showDialog(
                          context: context,
                          builder:
                              (dialogContext) => BlocProvider.value(
                                value: accountBloc,
                                child: BlocConsumer<AccountBloc, AccountState>(
                                  listener: (context, state) {
                                    if (state is AccountErrorState) {
                                      Navigator.pop(dialogContext);
                                    }
                                  },
                                  builder: (context, state) {
                                    if (state is AccountCodeSentState) {
                                      return CustomDialog(
                                        dialogTitle:
                                            text.deleteAccountOtpDialogTitle,
                                        dialogColor: AppColors.profilePrimary,
                                        dialogBody: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              text.deleteAccountOtpDialogContent,
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 16),
                                            CustomPinput(
                                              length: 6,
                                              onCompleted: (pin) {
                                                Navigator.pop(dialogContext);
                                                context.read<AccountBloc>().add(
                                                  AccountVerifyOtpEvent(
                                                    pin: pin,
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                    if (state is AccountSendingCodeState) {
                                      return CustomDialog(
                                        dialogTitle:
                                            text.deleteAccountDialogTitle,
                                        dialogColor: AppColors.profilePrimary,
                                        dialogBody: const Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 24,
                                          ),
                                          child: CircularProgressIndicator(
                                            color: AppColors.profilePrimary,
                                          ),
                                        ),
                                      );
                                    }
                                    return CustomDialog(
                                      dialogTitle:
                                          text.deleteAccountDialogTitle,
                                      dialogBody: Text(
                                        text.deleteAccountDialogContent,
                                        textAlign: TextAlign.center,
                                      ),
                                      dialogColor: AppColors.profilePrimary,
                                      dialogAction: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(dialogContext);
                                            },
                                            child: Text(
                                              text.deleteDialogCancelButton,
                                              style: TextStyle(
                                                color: AppColors.black,
                                              ),
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              context.read<AccountBloc>().add(
                                                AccountDeleteEvent(),
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.snackBarError,
                                            ),
                                            child: Text(
                                              text.deleteDialogConfirmButton,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateColor.resolveWith(
                          (_) => AppColors.snackBarError,
                        ),
                        foregroundColor: WidgetStateColor.resolveWith(
                          (_) => AppColors.white,
                        ),
                      ),
                      child: Text(text.deleteAccountButton),
                    ),
                    Center(
                      child: FutureBuilder<PackageInfo>(
                        future: PackageInfo.fromPlatform(),
                        builder: (context, snapshot) {
                          final packageInfo = snapshot.data;
                          if (packageInfo == null) {
                            return const SizedBox.shrink();
                          }
                          return Text(
                            text.appVersionLabel(
                              packageInfo.version,
                              packageInfo.buildNumber,
                            ),
                            textAlign: TextAlign.center,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
