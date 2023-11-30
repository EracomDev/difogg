import 'package:flutter/material.dart';
import 'package:difog/utils/app_config.dart';
import 'app_layout.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/browse_web.dart';

void main() => runApp(BrowserPage());

class BrowserPage extends StatefulWidget {
  @override
  _BrowserPageState createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
  List<String> recentWebsites = [];
  TextEditingController _urlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRecentWebsites();
    _urlController.text = AppConfig.baseUrl; // Set the default value here
  }

  void _loadRecentWebsites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      recentWebsites = prefs.getStringList('recentWebsites') ?? [];
    });
  }

  void _saveRecentWebsites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('recentWebsites', recentWebsites);
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _updateRecentWebsites(String websiteUrl) {
    setState(() {
      if (!recentWebsites.contains(websiteUrl)) {
        recentWebsites.insert(0, websiteUrl);
        _saveRecentWebsites();
      }
    });
  }

  void _openWebPage(BuildContext context, String url) {
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://' + url;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebBrowser(url: url),  // Change this line
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      child: Scaffold(

        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _urlController,
                      decoration: InputDecoration(
                        hintText: 'Enter a website URL',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: () {
                      final url = _urlController.text;
                      if (url.isNotEmpty) {
                        _openWebPage(context, url);
                        _updateRecentWebsites(url);
                      }
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: recentWebsites.length,
                itemBuilder: (context, index) {
                  final websiteUrl = recentWebsites[index];
                  return ListTile(
                    title: Text(websiteUrl),
                    onTap: () {
                      _openWebPage(context, websiteUrl);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
