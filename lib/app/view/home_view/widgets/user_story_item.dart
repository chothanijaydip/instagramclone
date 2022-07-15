import 'package:dashed_circle/dashed_circle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserStoryItem extends StatefulWidget {
  const UserStoryItem(
      {Key? key, required this.index, required this.setRectPoint})
      : super(key: key);

  final int index;
  final Function(Rect?) setRectPoint;
  @override
  _UserStoryItemState createState() => _UserStoryItemState();
}

class _UserStoryItemState extends State<UserStoryItem>
    with TickerProviderStateMixin {
  /// Variables
  late Animation<double> gap;
  late Animation<double> base;
  late Animation<double> reverse;
  AnimationController? animationController;
  Rect? rect;
  GlobalKey touchPoint = GlobalKey();

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 10));
    base = CurvedAnimation(parent: animationController!, curve: Curves.easeOut);
    reverse = Tween<double>(begin: 0.0, end: -1.0).animate(base);
    gap = Tween<double>(begin: 3.0, end: 0.0).animate(base)
      ..addListener(() {
        setState(() {});
      });
    animationController!.forward();
    animationController!.addListener(() {
      if (animationController!.isCompleted) {
        animationController!.repeat();
      }
    });
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0.w),
      child: GestureDetector(
        key: touchPoint,
        behavior: HitTestBehavior.opaque,
        onTapUp: (detalis) {
          var object = touchPoint.currentContext?.findRenderObject();
          var translation = object?.getTransformTo(null).getTranslation();
          var size = object?.semanticBounds.size;
          rect = Rect.fromLTWH(
              translation!.x, translation.y, size!.width, size.height);
          widget.setRectPoint(rect);
        },
        child: Hero(
          tag: "index${widget.index}",
          transitionOnUserGestures: true,
          child: Container(
            alignment: Alignment.center,
            child: RotationTransition(
              turns: base,
              child: DashedCircle(
                gapSize: gap.value,
                dashes: 20,
                color: const Color(0xffed4634),
                child: RotationTransition(
                  turns: reverse,
                  child: const Padding(
                    padding: EdgeInsets.all(5.0),
                    child: CircleAvatar(
                      radius: 30.0,
                      backgroundImage: NetworkImage(
                          'http://m.gettywallpapers.com/wp-content/uploads/2021/03/Cool-HD-Wallpaper.jpg'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
