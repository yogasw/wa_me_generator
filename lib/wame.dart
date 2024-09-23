import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import Clipboard class
import 'package:url_launcher/url_launcher.dart';

class WaMeGeneratorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WA.me Generator',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: WaMeGeneratorScreen(),
    );
  }
}

class WaMeGeneratorScreen extends StatefulWidget {
  @override
  _WaMeGeneratorScreenState createState() => _WaMeGeneratorScreenState();
}

class _WaMeGeneratorScreenState extends State<WaMeGeneratorScreen> {
  final _phoneNumberController = TextEditingController();
  final _textMessageController = TextEditingController();

  String _waMeLink = '';

  void _generateWaMeLink() {
    final phoneNumber = _phoneNumberController.text
        .replaceAll(' ', '')
        .replaceAll('-', '')
        .replaceAll("+", '');
    final textMessage = _textMessageController.text;

    if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a phone number')),
      );
      return;
    }

    final encodedMessage = Uri.encodeComponent(textMessage);
    final waMeLink = 'https://wa.me/$phoneNumber?text=$encodedMessage';
    setState(() {
      _waMeLink = waMeLink;
    });
  }

  void _launchWaMeLink() async {
    final Uri waMeUri = Uri.parse(_waMeLink);
    if (await canLaunchUrl(waMeUri)) {
      await launchUrl(waMeUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $_waMeLink')),
      );
    }
  }

  void _copyWaMeLink() {
    Clipboard.setData(ClipboardData(text: _waMeLink));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Link copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WA.me Generator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                hintText: 'Enter phone number without + or 0 prefix',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),
            TextField(
              controller: _textMessageController,
              decoration: InputDecoration(
                labelText: 'Message Text',
                hintText: 'Enter your message',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _generateWaMeLink,
              child: Text('Generate Link'),
            ),
            SizedBox(height: 16),
            if (_waMeLink.isNotEmpty)
              Column(
                children: [
                  SelectableText(
                    _waMeLink,
                    style: TextStyle(color: Colors.blue),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _launchWaMeLink,
                    child: Text('Open in WhatsApp'),
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _copyWaMeLink,
                    child: Text('Copy to Clipboard'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
