import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:take_home_project/controller/data_controller.dart';
import 'package:take_home_project/model/weight.dart';
import 'package:take_home_project/res/custom_colors.dart';
import 'package:take_home_project/screens/appointment_screen.dart';
import 'package:take_home_project/screens/sign_in_screen.dart';
import 'package:take_home_project/utils/authentication.dart';

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  UserInfoScreenState createState() => UserInfoScreenState();
}

class UserInfoScreenState extends State<UserInfoScreen> {
  late User _user;
  final DataController dataController = Get.put(DataController());
  final CarouselController _controller = CarouselController();
  late List<Widget> imageSliders;
  late List<String> labels;
  late int _current;

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const SignInScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  void initState() {
    _current = 0;
    labels = [
      'Ounce',
      'Gram',
      'Hundred Gram',
      'Thousand Gram'
    ]; // list of weights
    _user = widget._user;
    dataController.fetchPrice();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primary,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: CustomColors.primary,
        title: Text(
          _user.displayName!,
          style: const TextStyle(
            color: CustomColors.secondary,
            fontSize: 18,
          ),
        ),
        leading: _user.photoURL != null
            ? Padding(
                padding: const EdgeInsets.all(5.0),
                child: ClipOval(
                  child: Material(
                    color: CustomColors.secondary.withOpacity(0.3),
                    child: Image.network(
                      _user.photoURL!,
                    ),
                  ),
                ),
              )
            : ClipOval(
                child: Material(
                  color: CustomColors.secondary.withOpacity(0.3),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: CustomColors.secondary,
                    ),
                  ),
                ),
              ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
            ),
            onPressed: () async {
              await Authentication.signOut(context: context);
              await Future.delayed(const Duration(seconds: 1));
              () {
                Navigator.of(context).pushReplacement(_routeToSignInScreen());
              }.call();
            },
          )
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (dataController.isLoadingPrice.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              Expanded(
                child: CarouselSlider(
                  items: List.generate(
                      dataController.weights.length,
                      (index) => getScreen(
                          dataController.weights[index], labels[index])),
                  carouselController: _controller,
                  options: CarouselOptions(
                      height: 800.0,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      aspectRatio: 2.0,
                      autoPlayCurve: Curves.easeInBack,
                      viewportFraction: 1.0,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      }),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: labels.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => _controller.animateToPage(entry.key),
                    child: Container(
                      width: 12.0,
                      height: 12.0,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.black)
                              .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                    ),
                  );
                }).toList(),
              ),
              InkWell(
                onTap: (() => Get.to(() => const AppointmentScreen())),
                child: Container(
                  height: 60,
                  color: CustomColors.secondary,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.calendar_month_sharp,
                          color: CustomColors.deepBlue),
                      SizedBox(width: 5),
                      Text(
                        'Place an appointment',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20, color: CustomColors.deepBlue),
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  Widget getScreen(Weight weight, String label) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Stack(
            children: [
              Image.asset(
                'assets/gold.jpeg',
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: CustomColors.primary,
                  ),
                  child: Text(
                    '\$${weight.gold} \n Gold',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 20, color: CustomColors.secondary),
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Stack(
            children: [
              Image.asset(
                'assets/platinum.jpeg',
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: CustomColors.primary,
                  ),
                  child: Text(
                    '\$${weight.platinum} \n Platinum',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 20, color: CustomColors.secondary),
                  ),
                ),
              )
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Stack(
            children: [
              Image.asset(
                'assets/silver.jpeg',
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: CustomColors.primary,
                  ),
                  child: Text(
                    '\$${weight.silver} \n Silver',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 20, color: CustomColors.secondary),
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: CustomColors.secondary,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, color: CustomColors.primary),
          ),
        )
      ],
    );
  }

  Future<void> myAsyncMethod(
      BuildContext context, VoidCallback onSuccess) async {
    await Future.delayed(const Duration(seconds: 2));
    onSuccess.call();
  }
}
