import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payflex/core/utils/style/typo.dart';
import 'package:payflex/features/user/cubit/user_cubit.dart';

class UserWidget extends StatelessWidget {
  const UserWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserCubit>().user;

    return Row(
      children: [
        Image.asset(user.picture, height: 50),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Howdy',
              style: subTitle,
            ),
            Text(
              user.name,
              style: headerWhite,
            ),
          ],
        ),
        const Spacer(),
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: Image.asset('assets/ic_bell.png', height: 20),
            ),
            IconButton(
              onPressed: () {},
              icon: Image.asset('assets/ic_mail.png', height: 20),
            ),
          ],
        ),
      ],
    );
  }
}
