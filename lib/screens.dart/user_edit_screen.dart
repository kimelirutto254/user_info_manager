import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend_interview/model/user.dart';
import 'package:frontend_interview/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class UserEditScreen extends StatefulWidget {
  final String userId;
  UserEditScreen({required this.userId});

  @override
  _UserEditScreenState createState() => _UserEditScreenState();
}

class _UserEditScreenState extends State<UserEditScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isUpdating = false; // Track update state

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).loadUser(widget.userId);
    });
  }

  Future<void> _updateUser(UserProvider userProvider, User user) async {
    setState(() => isUpdating = true);

    try {
      bool success = await userProvider.updateUser(widget.userId, user);
      if (success) {
        Fluttertoast.showToast(
          msg: "User updated successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Failed to update user",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "An error occurred: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      setState(() => isUpdating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.selectedUser;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Edit User',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        backgroundColor: Colors.black,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body:
          userProvider.isLoading || user == null
              ? _buildShimmerEffect()
              : Padding(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: user.name,
                        decoration: InputDecoration(labelText: "Name"),
                        onChanged: (value) => user.name = value,
                      ),
                      TextFormField(
                        initialValue: user.email,
                        decoration: InputDecoration(labelText: "Email"),
                        onChanged: (value) => user.email = value,
                      ),
                      TextFormField(
                        initialValue: user.occupation,
                        decoration: InputDecoration(labelText: "Occupation"),
                        onChanged: (value) => user.occupation = value,
                      ),
                      TextFormField(
                        initialValue: user.bio,
                        decoration: InputDecoration(labelText: "Bio"),
                        onChanged: (value) => user.bio = value,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed:
                            isUpdating
                                ? null
                                : () => _updateUser(userProvider, user),
                        child:
                            isUpdating
                                ? SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                                : Text("Update User"),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView(
        padding: EdgeInsets.all(16.0),
        children:
            List.generate(4, (_) => _buildShimmerItem()) +
            [
              SizedBox(height: 20),
              Container(height: 50, color: Colors.grey[300]),
            ],
      ),
    );
  }

  Widget _buildShimmerItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(height: 20, color: Colors.grey[300]),
    );
  }
}
