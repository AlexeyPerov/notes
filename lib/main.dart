import 'package:async_redux/async_redux.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mynotes/app/app.dart';
import 'package:mynotes/app/options/notes_options.dart';
import 'package:mynotes/app/theme/theme_constants.dart';
import 'package:mynotes/app/theme/themes.dart';
import 'package:mynotes/redux/app_state_store.dart';
import 'package:mynotes/screens/notes/notes_connector.dart';
import 'package:mynotes/common/utilities/routing/routing_extensions.dart';

void main() {
  GoogleFonts.config.allowRuntimeFetching = true;
  runApp(AppWidget());
}

class AppWidget extends StatelessWidget {
  final Future _appInitialization;

  AppWidget() : _appInitialization = App.initializeApp();

  @override
  Widget build(BuildContext context) => StoreProvider<AppState>(
      store: store,
      child: ModelBinding(
        initialModel: NotesOptions(
          themeMode: ThemeMode.system,
          textScaleFactor: systemTextScaleFactorOption,
          timeDilation: timeDilation,
          platform: defaultTargetPlatform,
          isTestMode: false,
        ),
        child: Builder(
          builder: (context) {
            return _createApp(context);
          },
        ),
      ));

  MaterialApp _createApp(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'notes',
      title: 'Notes',
      themeMode: NotesOptions.of(context).themeMode,
      theme: NotesThemeData.lightThemeData.copyWith(
        platform: NotesOptions.of(context).platform,
      ),
      darkTheme: NotesThemeData.darkThemeData.copyWith(
        platform: NotesOptions.of(context).platform,
      ),
      onGenerateRoute: _generateRoute,
    );
  }

  FutureBuilder _redirectOnAppInit(RouteToWidget routeTo) {
    return FutureBuilder(
      future: _appInitialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container(); // TODO error screen
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return routeTo();
        }

        return Container(); // TODO splash screen
      },
    );
  }

  Route<dynamic> _generateRoute(RouteSettings settings) {
    var routingData = settings.name.getRoutingData;
    switch (routingData.route) {
      case '/new':
        // TODO
        break;
    }

    return MaterialPageRoute(
      builder: (context) => _redirectOnAppInit(() => NotesConnector()),
    );
  }
}

typedef Widget RouteToWidget();
