import 'package:flutter/material.dart';

void main() {
  runApp(const BusinessApp());
}

class BusinessApp extends StatelessWidget {
  const BusinessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfileCardScreen(),
    );
  }
}

class ProfileCardScreen extends StatefulWidget {
  const ProfileCardScreen({super.key});

  @override
  State<ProfileCardScreen> createState() => _ProfileCardScreenState();
}

class _ProfileCardScreenState extends State<ProfileCardScreen> {
  bool _isFollowing = false;
  bool _isLiked = false;
  int _followerCount = 1320;
  int _likesCount = 120;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],

      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.teal[700],
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: Center(
        child: Card(
          elevation: 6,
          margin: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),

          child: Padding(
            padding: const EdgeInsets.all(24.0),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.teal[100],
                  child: const Icon(
                    Icons.person,
                    size: 55,
                    color: Colors.teal,
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  'Аяулым Серикова',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  'Digital Engineering Student',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          '$_followerCount',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Followers',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(width: 30),

                    Column(
                      children: [
                        Text(
                          '$_likesCount',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Likes ❤️',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _toggleFollow,
                      icon: Icon(
                        _isFollowing
                            ? Icons.check
                            : Icons.person_add,
                      ),
                      label: Text(
                        _isFollowing
                            ? 'Following'
                            : 'Follow',
                      ),
                    ),

                    const SizedBox(width: 12),

                    OutlinedButton.icon(
                      onPressed: _toggleLike,
                      icon: Icon(
                        _isLiked
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: _isLiked
                            ? Colors.redAccent
                            : Colors.grey,
                      ),
                      label: Text(
                        _isLiked
                            ? 'Liked'
                            : 'Like',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                TextButton.icon(
                  onPressed: _resetProfile,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _toggleFollow() {
    setState(() {
      _isFollowing = !_isFollowing;

      if (_isFollowing) {
        _followerCount++;
      } else {
        _followerCount--;
      }
    });
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;

      if (_isLiked) {
        _likesCount++;
      } else {
        _likesCount--;
      }
    });
  }

  void _resetProfile() {
    setState(() {
      _isFollowing = false;
      _isLiked = false;
      _followerCount = 1320;
      _likesCount = 120;
    });
  }
}