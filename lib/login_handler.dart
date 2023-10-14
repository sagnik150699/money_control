import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:money_control/view_model.dart';

import 'expense_view.dart';
import 'login_view.dart';

class LoginHandler extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _authState = ref.watch(authStateProvider);

    return _authState.when(
      data: (data) {
        if (data != null) {
          return ExpenseView();
        } else
          return LoginView();
      },
      error: (error, stackTrace) {
        return LoginView();
      },
      loading: (() => CircularProgressIndicator()),
    );
  }
}
