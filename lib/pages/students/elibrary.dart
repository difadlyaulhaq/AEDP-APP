import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_aedp/bloc/auth/auth_bloc.dart';
import 'package:project_aedp/bloc/auth/auth_state.dart';
import 'package:project_aedp/bloc/library_download/library_download_bloc.dart';
import 'package:project_aedp/bloc/library_download/library_download_event.dart';
import 'package:project_aedp/bloc/library_download/library_download_state.dart';
import 'package:project_aedp/generated/l10n.dart';

class ELibraryPage extends StatefulWidget {
  const ELibraryPage({super.key});

  @override
  _ELibraryPageState createState() => _ELibraryPageState();
}

class _ELibraryPageState extends State<ELibraryPage> {
  String getUserId() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthLoginSuccess) {
      return authState.userId.toString();
    } else {
      throw Exception('User not logged in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).e_library),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E71A2),
      ),
      body: BlocProvider(
        create: (context) {
         // Replace "1" with actual user ID from authentication/profile state
        final bloc = LibraryDownloadBloc();
         // Replace "getUserId()" with the actual method to get the user ID from your authentication/profile state
          final authState = context.read<AuthBloc>().state;
          if (authState is AuthLoginSuccess) {
          final userId = authState.userId;
          bloc.add(LoadLibraryFiles(userId.toString()));
          } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).errorLabel('user not logged in'))),
          );
          }
            if (authState is AuthLoginSuccess && authState.role.toLowerCase() == 'student') {
            bloc.add(LoadLibraryFiles(authState.userId.toString()));
            } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(S.of(context).errorLabel('user role not found'))),
            );
            }
            return bloc;
        },
        child: BlocConsumer<LibraryDownloadBloc, LibraryDownloadState>(
          listener: (context, state) {
            if (state is LibraryDownloadError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is LibraryDownloadLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is LibraryDownloadLoaded) {
              if (state.files.isEmpty) {
                return Center(
                  child: Text(
                    S.of(context).noFilesAvailable,
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ListView.builder(
                  itemCount: state.files.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (context, index) {
                    final file = state.files[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.file_present, color: Colors.deepPurple),
                          title: Text(
                            file.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.download, color: Colors.green),
                            onPressed: () => context.read<LibraryDownloadBloc>().add(DownloadFile(file.filePath)),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }

            return Center(
              child: Text(
                S.of(context).loadingLabel,
                style: const TextStyle(fontSize: 18, color: Colors.blue),
              ),
            );
          },
        ),
      ),
    );
  }
}