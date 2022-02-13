import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';

class HelpSlider extends StatefulWidget {
  const HelpSlider({Key? key}) : super(key: key);

  @override
  _HelpSliderState createState() => _HelpSliderState();
}

class _HelpSliderState extends State<HelpSlider> {
  List<Slide> slides = [];

  @override
  void initState() {
    super.initState();
    slides.add(Slide(
        title: "Welcome to Bangla Chef",
        backgroundColor: Colors.orange,
        centerWidget: Image.asset(
          "assets/chef-hat.png",
          height: 200,
        ),
        description:
            "আপনার সমস্ত খাবার একই সময়ে শেষ হয় তা নিশ্চিত করতে আমি এখানে আছি"));
    slides.add(Slide(
        title: "Recipes",
        backgroundColor: Colors.blue,
        centerWidget: Image.asset(
          "assets/recipe.png",
          height: 200,
        ),
        description:
            "প্রতিটি রেসিপিতে একাধিক উপাদান থাকতে পারে। প্রতিটি ডিশের জন্য একটি উপাদান যোগ করুন, যেমন আলু বা মুরগি।  "
            "প্রতিটি উপাদানের জন্য টাইমারগুলি অনুকরণীয়ভাবে চলবে এবং একই সময়ে শেষ হবে"));
    slides.add(Slide(
        title: "Ingredients",
        backgroundColor: Colors.red,
        centerWidget: Image.asset(
          "assets/fish.png",
          height: 200,
        ),
        description: "উপাদানগুলি পর্যায়ক্রমে গঠিত হয়। "
            "একাধিক ফেজ যোগ করুন যদি আপনি একটি উপাদানের জন্য বিভিন্ন পদক্ষেপ করতে চান, যেমন 20 মিনিটের জন্য marinade তারপর 40 মিনিটের জন্য বেক করুন"));
    slides.add(Slide(
        title: "Start The Timer",
        backgroundColor: Colors.green,
        centerWidget: Image.asset(
          "assets/stopwatch.png",
          height: 200,
        ),
        description: "একবার আপনার টাইমার প্রস্তুত হয়ে গেলে, প্লে টিপুন।"
        "একবার একটি উপাদান টাইমার শুরু হতে চলেছে একবার আপনি বিজ্ঞপ্তি পাবেন, এবং প্রতিবার একটি ফেজ শেষ হয়"));
    slides.add(Slide(
        title: "Schedule Timers",
        backgroundColor: Colors.orange,
        centerWidget: Image.asset(
          "assets/scheduledstopwatch.png",
          height: 200,
        ),
        description: "একটি নির্দিষ্ট সময়ে শেষ করার জন্য একটি টাইমার নির্ধারণ করুন।"
        "Sous শেফ আপনার প্রথম ডিশ মধ্যে রাখা সময় কখন আপনাকে জানাতে হবে"));
  }

  void goHome(BuildContext context) {
    Navigator.of(context).pushNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      slides: slides,
      onDonePress: () => goHome(context),
      onSkipPress: () => goHome(context),
    );
  }
}
