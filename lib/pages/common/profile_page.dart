import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project_aedp/bloc/auth/auth_bloc.dart';
import 'package:project_aedp/bloc/auth/auth_state.dart';
import 'package:project_aedp/bloc/load_profile/load_profile_event.dart';
import 'package:project_aedp/bloc/load_profile/profile_bloc.dart';
import 'package:project_aedp/bloc/load_profile/profile_state.dart';
import 'package:project_aedp/generated/l10n.dart';
import 'package:project_aedp/widget/dropdown/language_dropdown.dart';
import 'package:project_aedp/widget/profile/profile_content.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLogoutSuccess) {
          context.go('/select-role');
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is AuthLoginSuccess) {
            context.read<LoadProfileBloc>().add(
                  LoadUserProfile(id: authState.userId.toString()),
                );

            return Scaffold(
              appBar: AppBar(
                actions: [
                  LanguageDropdown(),
                ],
              ),
              body: BlocBuilder<LoadProfileBloc, LoadProfileState>(
                builder: (context, state) {
                  if (state is LoadProfileLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is LoadProfileLoaded) {
                    return ProfileContent(
                      profileData: state.profileData,
                      screenWidth: screenWidth,
                    );
                  } else if (state is LoadProfileError) {
                    return Center(
                      child: Text(S.of(context).errorLabel(state.message)),
                    );
                  }
                  return Center(child: Text(S.of(context).noProfileData));
                },
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
