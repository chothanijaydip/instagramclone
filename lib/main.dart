import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app/view/home_view/home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MediaQuery(
      data: const MediaQueryData(),
      child: ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: () {
            return AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle(
                systemNavigationBarColor: Colors.white,
                systemNavigationBarIconBrightness:
                    Theme.of(context).backgroundColor.computeLuminance() > 0.5
                        ? Brightness.dark
                        : Brightness.light,
                systemNavigationBarDividerColor: Colors.white,
                statusBarColor: Colors.white,
              ),
              child: MaterialApp(
                title: 'Instagram Clone',
                debugShowCheckedModeBanner: false,
                builder: (context, child) {
                  ScreenUtil.setContext(context);
                  return MediaQuery(
                      data:
                          MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: AnnotatedRegion<SystemUiOverlayStyle>(
                          value: SystemUiOverlayStyle(
                            systemNavigationBarColor: Colors.white,
                            systemNavigationBarIconBrightness: Theme.of(context)
                                        .backgroundColor
                                        .computeLuminance() >
                                    0.5
                                ? Brightness.dark
                                : Brightness.light,
                            systemNavigationBarDividerColor: Colors.white,
                            statusBarColor: Colors.white,
                          ),
                          child: child!));
                },
                theme: ThemeData(
                  scaffoldBackgroundColor: Colors.white,
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                  primarySwatch: Colors.blue,
                ),
                home:  const HomeView(),
              ),
            );
          }),
    );
  }
}
