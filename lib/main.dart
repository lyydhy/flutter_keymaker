import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_keymaker_template/page/home_page.dart';
import 'package:flutter_keymaker_template/util/app_config.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // setPathUrlStrategy();
  await flutter_acrylic.Window.initialize();
  await WindowManager.instance.ensureInitialized();
  windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setTitleBarStyle(
      TitleBarStyle.hidden,
      windowButtonVisibility: false,
    );
    await windowManager.setSize(const Size(755, 545));
    await windowManager.setMinimumSize(const Size(350, 600));
    await windowManager.center();
    await windowManager.show();
    await windowManager.setPreventClose(true);
    await windowManager.setSkipTaskbar(false);
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppTheme(),
      builder: (context, _) {
        final appTheme = context.watch<AppTheme>();
        return FluentApp(
          title: AppConfig.appTitle,
          themeMode: appTheme.mode,
          debugShowCheckedModeBanner: false,
          home: const MyHomePage(),
          color: appTheme.color,
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            accentColor: appTheme.color,
            visualDensity: VisualDensity.standard,
            focusTheme: FocusThemeData(
              glowFactor: is10footScreen() ? 2.0 : 0.0,
            ),
          ),
          theme: ThemeData(
            accentColor: appTheme.color,
            visualDensity: VisualDensity.standard,
            focusTheme: FocusThemeData(
              glowFactor: is10footScreen() ? 2.0 : 0.0,
            ),
          ),
          locale: appTheme.locale,
          builder: (context, child) {
            return Directionality(
              textDirection: appTheme.textDirection,
              child: NavigationPaneTheme(
                data: NavigationPaneThemeData(
                  backgroundColor: appTheme.windowEffect !=
                          flutter_acrylic.WindowEffect.disabled
                      ? Colors.transparent
                      : null,
                ),
                child: child!,
              ),
            );
          },
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WindowListener {
  bool value = false;
  final viewKey = GlobalKey();
  int index = 0;
  final settingsController = ScrollController();

  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    settingsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = context.watch<AppTheme>();
    return NavigationView(
      key: viewKey,
      appBar: NavigationAppBar(
        automaticallyImplyLeading: false,
        title: () {
          return DragToMoveArea(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(AppConfig.appTitle),
            ),
          );
        }(),
        actions: Container(
          padding: const EdgeInsets.only(top: 10, right: 10),
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              ToggleSwitch(
                content: const Text('主题'),
                checked: FluentTheme.of(context).brightness.isDark,
                onChanged: (v) {
                  if (v) {
                    appTheme.mode = ThemeMode.dark;
                  } else {
                    appTheme.mode = ThemeMode.light;
                  }
                },
              ),
              const WindowButtons(),
            ],
          ),
        ),
      ),
      pane: NavigationPane(
        selected: index,
        onChanged: (i) => setState(() => index = i),
        size: const NavigationPaneSize(
          openMinWidth: 150.0,
          openMaxWidth: 150.0,
        ),
        header: Container(
            height: kOneLineTileHeight,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(AppConfig.appTitle)),
        displayMode: appTheme.displayMode,
        // indicator: () {
        //   switch (appTheme.indicator) {
        //     case NavigationIndicators.end:
        //       return const EndNavigationIndicator();
        //     case NavigationIndicators.sticky:
        //     default:
        //       return const StickyNavigationIndicator();
        //   }
        // }(),
        items: [
          // It doesn't look good when resizing from compact to open
          // PaneItemHeader(header: Text('User Interaction')),
          PaneItem(
            icon: const Icon(FluentIcons.home),
            title: const Text('首页'),
          ),
        ],

        footerItems: [
          PaneItemSeparator(),
          PaneItem(
            icon: const Icon(FluentIcons.settings),
            title: const Text('Settings'),
          ),
          // _LinkPaneItemAction(
          //   icon: const Icon(FluentIcons.open_source),
          //   title: const Text('Source code'),
          //   link: 'https://github.com/bdlukaa/fluent_ui',
          // ),
        ],
      ),
      content: NavigationBody(index: index, children: const [
        HomeIndexPage(),
        // Settings(controller: settingsController),
      ]),
    );
  }

  @override
  void onWindowClose() async {
    bool _isPreventClose = await windowManager.isPreventClose();
    if (_isPreventClose) {
      showDialog(
        context: context,
        builder: (_) {
          return ContentDialog(
            title: const Text('关闭'),
            content: const Text('你忍心关掉本可爱嘛！'),
            actions: [
              FilledButton(
                child: const Text('是'),
                onPressed: () {
                  Navigator.pop(context);
                  windowManager.destroy();
                },
              ),
              Button(
                child: const Text('否'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }
}
class WindowButtons extends StatelessWidget {
  const WindowButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = FluentTheme.of(context);

    return SizedBox(
      width: 138,
      height: 50,
      child: WindowCaption(
        brightness: theme.brightness,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
