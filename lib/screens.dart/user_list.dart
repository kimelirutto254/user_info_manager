import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:frontend_interview/providers/user_provider.dart';
import 'user_edit_screen.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  bool _isDelayed = false;
  final TextEditingController _searchController = TextEditingController();
  final Map<String, bool> _expandedBioMap = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUsers();
      Future.delayed(Duration(seconds: 10), () {
        if (mounted) {
          setState(() {
            _isDelayed = true;
          });
        }
      });
    });
  }

  Future<void> _loadUsers() async {
    await Provider.of<UserProvider>(context, listen: false).loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Users', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Container(
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black, width: 1)),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Users...',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          SizedBox(height: 12),
          Expanded(
            child: Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                if (userProvider.isLoading) {
                  return _buildShimmerEffect();
                }

                final filteredUsers =
                    userProvider.users.where((user) {
                      return user.name.toLowerCase().contains(
                        _searchController.text.toLowerCase(),
                      );
                    }).toList();

                if (filteredUsers.isEmpty) {
                  return Center(child: Text("No users found."));
                }

                return RefreshIndicator(
                  onRefresh: _loadUsers, // Trigger refresh
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = filteredUsers[index];
                      final initials = _getInitials(user.name);
                      final isExpanded = _expandedBioMap[user.id] ?? false;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => UserEditScreen(userId: user.id),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 8.0),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                radius: 20,
                                child: Text(
                                  initials,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.name,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Email',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      user.email,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Occupation',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      user.occupation,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Bio',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      _truncateBio(user.bio, isExpanded),
                                      style: TextStyle(color: Colors.grey),
                                      maxLines: isExpanded ? null : 2,
                                      overflow:
                                          isExpanded
                                              ? TextOverflow.visible
                                              : TextOverflow.ellipsis,
                                    ),
                                    if (user.bio.length > 100)
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _expandedBioMap[user.id] =
                                                !isExpanded;
                                          });
                                        },
                                        child: Text(
                                          isExpanded
                                              ? 'Read Less'
                                              : 'Read More',
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.black,
                                size: 16,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[200]!,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: 10,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(top: 8.0),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                CircleAvatar(backgroundColor: Colors.grey[300], radius: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 16,
                        color: Colors.grey[300],
                      ),
                      SizedBox(height: 4),
                      Container(
                        width: double.infinity,
                        height: 12,
                        color: Colors.grey[300],
                      ),
                      SizedBox(height: 4),
                      Container(
                        width: double.infinity,
                        height: 12,
                        color: Colors.grey[300],
                      ),
                      SizedBox(height: 4),
                      Container(
                        width: double.infinity,
                        height: 12,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[300],
                  size: 16,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getInitials(String name) {
    List<String> nameParts = name.split(' ');
    if (nameParts.length >= 2) {
      return nameParts[0][0] + nameParts[1][0];
    } else if (nameParts.isNotEmpty) {
      return nameParts[0][0];
    }
    return '';
  }

  String _truncateBio(String bio, bool isExpanded) {
    if (isExpanded || bio.length <= 100) {
      return bio;
    }
    return bio.substring(0, 100) + '...';
  }
}
