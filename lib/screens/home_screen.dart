import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:water_tracker/localization/keys.dart';
import 'package:water_tracker/network/response.dart';
import 'package:water_tracker/routes.dart';
import 'package:water_tracker/services/firebase/firebase_authentication.dart';
import 'package:water_tracker/theme/theme.dart';
import 'package:water_tracker/view_models/home_view_model.dart';
import 'package:water_tracker/view_models/posts_view_model.dart';
import 'package:water_tracker/view_models/theme_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    /// We can listen to updates using the extensions:
    final postsProvider = context.watch<PostsViewModel>();
    final homeProvider = context.read<HomeViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Tracker'),
        actions: [
          IconButton(
              onPressed: () {
                AuthService().logOut();
                Navigator.pushNamedAndRemoveUntil(context, loginScreenRoute, (route) => false);
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            _buildChangeLangButton(translate(Keys.Language_English), 'en'),
            _buildChangeLangButton(translate(Keys.Language_Ukrainian), 'uk'),
          ]),
          _buildChangeThemeTile(),
          ElevatedButton(
            onPressed: () {
              postsProvider.fetchPosts();
            },
            child: Text(translate(Keys.Fetch_Posts)),
          ),
          Text(
            translatePlural(Keys.Plural_Demo, homeProvider.counter),
            textAlign: TextAlign.center,
            style: TextStyles.notifierTextLabel
                .copyWith(color: Theme.of(context).colorScheme.secondary),
          ),
          Text(
            _getText(postsProvider)!,
            textAlign: TextAlign.center,
            style: TextStyles.notifierTextLabel
                .copyWith(color: Theme.of(context).colorScheme.secondary),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => homeProvider.incrementCounter(),
        child: const Icon(Icons.add),
      ),
    );
  }

  ListTile _buildChangeThemeTile() {
    final themeViewModel = context.watch<ThemeViewModel>();
    return ListTile(
      leading: Text(
        translate(Keys.Theme_Change_Theme),
        style: Theme.of(context).textTheme.headline4,
      ),
      trailing: Switch(
        value: themeViewModel.isLightTheme,
        onChanged: (val) {
          themeViewModel.setThemeData = val;
        },
      ),
    );
  }

  ElevatedButton _buildChangeLangButton(String languageName, String languageCode) {
    return ElevatedButton(
      onPressed: () {
        changeLocale(context, languageCode);
      },
      child: Text(languageName),
    );
  }

  String? _getText(PostsViewModel postsViewModel) {
    final postsListResponse = postsViewModel.postsListResponse;
    switch (postsListResponse.status) {
      case Status.loading:
        return postsListResponse.message;
      case Status.completed:
        return '${postsListResponse.data!.length}';
      case Status.error:
        return postsListResponse.message;
      case Status.none:
      default:
        return '';
    }
  }
}
