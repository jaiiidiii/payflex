import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflex/core/utils/style/typo.dart';
import 'package:payflex/features/user/cubit/user_cubit.dart';


class BalanceDisplay extends StatelessWidget {
  const BalanceDisplay({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Available Balance',
              style: subTitle,
            ),
            const SizedBox(height: 5),
            Builder(builder: (context) {
              final balance = context
                  .select((UserCubit userCubit) => userCubit.user.balance);
              return Text(
                '${balance.toStringAsFixed(2)} AED',
                style: largePrimary,
              );
            }),
          ],
        ),
      ],
    );
  }
}
