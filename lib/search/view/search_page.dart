import 'package:chatapp/chat/chat.dart';
import 'package:chatapp/search/search.dart';
import 'package:chatapp/widgets/avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: BlocProvider(
        create: (context) => UserSearchCubit(),
        child: SearchForm(),
      ),
    );
  }
}

class SearchForm extends StatefulWidget {
  const SearchForm({super.key});

  @override
  State<SearchForm> createState() => _SearchFormState();
}

class _SearchFormState extends State<SearchForm> {
  final TextEditingController _searchController = TextEditingController();

  void _navigateToChatPage(String username, String id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatPage(
          receiverId: id,
          receiverUsername: username,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              labelText: 'Enter username to search',
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            final query = _searchController.text;
            context.read<UserSearchCubit>().searchUsers(query);
          },
          child: const Text('Search'),
        ),
        const SizedBox(height: 16),
        BlocBuilder<UserSearchCubit, List<Map<String, dynamic>>>(
          builder: (context, state) {
            if (state.isEmpty) {
              return const Text('No users found');
            } else {
              return Expanded(
                child: ListView.builder(
                  itemCount: state.length,
                  itemBuilder: (context, index) {
                    final user = state[index];
                    return Container(
                      padding: const EdgeInsets.all(8),
                      margin: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        // borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ListTile(
                        leading: Avatar(),
                        title: Text(user['username']),
                        subtitle: Text(user['email']),
                        onTap: () {
                          _navigateToChatPage(
                            user['username'],
                            user['uid'],
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
