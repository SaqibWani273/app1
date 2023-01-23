import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'screens/signup.dart';
import 'package:flutter/material.dart';

import 'profile_data.dart';

class Profile extends StatefulWidget {
//  ProfileData _profileData;
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final profileData = Provider.of<ProfileData>(context);
    log('profile build');
    switch (profileData.userState) {
      case 'loading':
        return const Center(child: CircularProgressIndicator());
      case 'null':
        return const SingUp();
      case 'emailNotVerified':
        return const VerifyEmail();
      case 'loggedOut':
        return const ProfileDashboard();

      default:
        return SingUp();
    }
  }
}

class ProfileDashboard extends StatelessWidget {
  const ProfileDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text('Dashboard')),
    );
  }
}
