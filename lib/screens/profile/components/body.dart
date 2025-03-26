import 'package:ayamgepuk/screens/auth/sign_in_screen.dart';
import 'package:ayamgepuk/screens/check_booking_screen.dart';
import 'package:ayamgepuk/screens/profile/components/password_change.dart';
import 'package:ayamgepuk/screens/profile/components/profile_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants.dart';
import '../../../entry_point.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  // Log out method that clears user session data
  Future<void> _logOut(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userId');
    prefs.remove('username');
    prefs.setBool('isLoggedIn', false);

    // Navigate to EntryPoint or SignIn screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const EntryPoint(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  // Check if the user is logged in and retrieve user ID
  Future<int?> _getLoggedInUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId'); // Fetch the stored userId
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
          child: FutureBuilder<int?>(
            future: _getLoggedInUserId(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasData && snapshot.data != null) {
                // User is logged in
                final loggedInUserId = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: defaultPadding),
                    Text("Account Settings",
                        style: Theme.of(context).textTheme.headlineMedium),
                    Text(
                      "Update your settings like bookings, profile edit etc.",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    ProfileMenuCard(
                      svgSrc: "assets/icons/profile.svg",
                      title: "Profile Information",
                      subTitle: "Change your account information",
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewCustomerScreen(
                              title: "Profile Information",
                              userId: loggedInUserId, // Pass the user ID here
                            ),
                          ),
                        );
                      },
                    ),
                    ProfileMenuCard(
                      svgSrc: "assets/icons/lock.svg",
                      title: "Change Password",
                      subTitle: "Change your password",
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PasswordChangeScreen(
                              userId: loggedInUserId, // Pass the user ID correctly
                            ),
                          ),
                        );
                      },
                    ),
                    ProfileMenuCard(
                      svgSrc: "assets/icons/order.svg",
                      title: "Bookings",
                      subTitle: "Check your bookings",
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckBookingScreen(userId: loggedInUserId),
                          ),
                        );

                      },
                    ),
                    ProfileMenuCard(
                      svgSrc: "assets/icons/logout.svg",
                      title: "Logout",
                      subTitle: "Sign out of your account",
                      press: () async {
                        await _logOut(context); // Call the logout method
                      },
                    ),
                  ],
                );
              } else {
                // User is not logged in
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: defaultPadding),
                    Text("Account Settings",
                        style: Theme.of(context).textTheme.headlineMedium),
                    Text(
                      "Please sign in to manage your account settings.",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    ProfileMenuCard(
                      svgSrc: "assets/icons/sign_in.svg",
                      title: "Sign In",
                      subTitle: "Log in to manage your account",
                      press: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignInScreen(),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class ProfileMenuCard extends StatelessWidget {
  const ProfileMenuCard({
    super.key,
    this.title,
    this.subTitle,
    this.svgSrc,
    this.press,
  });

  final String? title, subTitle, svgSrc;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: defaultPadding / 2),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        onTap: press,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              SvgPicture.asset(
                svgSrc!,
                height: 24,
                width: 24,
                colorFilter: ColorFilter.mode(
                  titleColor.withOpacity(0.64),
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title!,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subTitle!,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 14,
                        color: titleColor.withOpacity(0.54),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_ios_outlined,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
