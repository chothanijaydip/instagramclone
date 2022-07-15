import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instagramclone/app/app_data/story_data.dart';
import 'package:instagramclone/app/helper/constant.dart';
import 'package:instagramclone/app/helper/style.dart';
import 'package:instagramclone/app/page_animations/page_routes_animation.dart';
import 'package:instagramclone/app/view/story_feed/story_feed_view.dart';
import 'package:rect_getter/rect_getter.dart';
import 'widgets/user_story_item.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  GlobalKey<RectGetterState> reactGetterkey = RectGetter.createGlobalKey();
  Rect? rect;
  AnimationController? storyAnimationController;
  Animation? storycolorAnimation;

  @override
  void initState() {
    super.initState();
    storyAnimationController =
        AnimationController(vsync: this, duration: animationDuration);
    storycolorAnimation = ColorTween(begin: Colors.black12, end: Colors.black)
        .animate(storyAnimationController!);
    storyAnimationController!.addListener(() {
      setState(() {});
    });
  }

  void onStoryItemTap(reactpoint, index) {
    setState(() => rect = reactpoint);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() =>
          rect = rect!.inflate(1.3 * MediaQuery.of(context).size.longestSide));
      storyAnimationController!.forward();
      Future.delayed(animationDuration, () {
        Navigator.of(context)
            .push(
              FadeRouteBuilder(
                page: StoryFeedView(
                    stories: stories, herotagString: 'index$index'),
              ),
            )
            .then((value) => setState(() => rect = null));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: false,
            // ignore: deprecated_member_use
            backwardsCompatibility: true,
            actionsIconTheme: IconThemeData(color: Colors.black, size: 25.w),
            actions: const [
              IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.add_box_outlined,
                  color: Colors.black,
                ),
              ),
              IconButton(
                onPressed: null,
                icon: Icon(
                  Icons.message,
                  color: Colors.black,
                ),
              ),
            ],
            title: Text(
              "Instagram",
              style: textsizeBold20,
            ),
          ),
          body: Column(
            children: [
              SizedBox(
                height: 70.w,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  itemBuilder: (context, index) {
                    return UserStoryItem(
                      setRectPoint: (rectpoint) {
                        print(rect);
                        setState(() {
                          rect = rectpoint;
                        });
                        onStoryItemTap(rect, index);
                      },
                      index: index,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        rippleAnimation(),
      ],
    );
  }

  Widget rippleAnimation() {
    if (rect == null) {
      return const Offstage();
    }
    return AnimatedPositioned(
      left: rect!.left,
      right: MediaQuery.of(context).size.width - rect!.right,
      top: rect!.top,
      bottom: MediaQuery.of(context).size.height - rect!.bottom,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: storycolorAnimation!.value,
        ),
      ),
      duration: animationDuration,
    );
  }
}
