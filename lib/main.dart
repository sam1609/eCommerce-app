import 'package:flutter/material.dart';
import 'dart:convert';
import 'homepage.dart';

void main() {
  runApp(MyApp());
}

class CountryDetails {
  final String name;
  final String flag;
  final String code;
  final String dialCode;

  CountryDetails({
    required this.name,
    required this.flag,
    required this.code,
    required this.dialCode,
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  CountryDetails? selectedCountry;
  List<CountryDetails> countries = [];
  TextEditingController phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load country data from assets
    loadCountryData();
  }

  Future<void> loadCountryData() async {
    final String data =
        await DefaultAssetBundle.of(context).loadString('assets/countries.json');
    final List<dynamic> jsonList = json.decode(data);
    final List<CountryDetails> countryList = jsonList.map((e) {
      return CountryDetails(
        name: e['name'],
        flag: e['flag'],
        code: e['code'],
        dialCode: e['dial_code'],
      );
    }).toList();
    setState(() {
      countries = countryList;
      selectedCountry = countryList.firstWhere(
        (country) => country.name == 'India', // Select India by default
        orElse: () => countryList[0], // If not found, select the first country
      );
    });
  }

  void checkPhoneNumber() {
    if (phoneNumberController.text.length == 10) {
      // Navigate to OTP verification when phone number is 10 digits
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPVerificationPage(
            selectedCountry?.dialCode ?? '',
            phoneNumberController.text,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'eCommerce App',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'Spring Time Software Solutions Pvt. Ltd.',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              '• Quick  • Affordable  • Trusted',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              DropdownButton<CountryDetails>(
                value: selectedCountry,
                items: countries.map<DropdownMenuItem<CountryDetails>>(
                  (CountryDetails country) {
                    return DropdownMenuItem<CountryDetails>(
                      value: country,
                      child: Row(
                        children: [
                          Text(country.flag),
                          SizedBox(width: 3),
                          Text(
                            '${country.name.length <= 8 ? country.name : country.name.substring(0, 8)} ',
                          ),
                        ],
                      ),
                    );
                  },
                ).toList(),
                onChanged: (CountryDetails? newValue) {
                  setState(() {
                    selectedCountry = newValue;
                  });
                },
              ),
              SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: phoneNumberController,
                  onChanged: (value) {
                    // Check phone number length and navigate if it's 10 digits
                    checkPhoneNumber();
                  },
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    prefix: Text('${selectedCountry?.dialCode ?? ''} '),
                  ),
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          SizedBox(height: 20),
         
        ],
      ),
          ),
     Align(
  alignment: Alignment.bottomRight,
  child: ClipRRect(
    borderRadius: BorderRadius.circular(20), // Adjust the radius as needed
    child: SizedBox(
      width: 100, // Adjust the width as needed
      child: OutlinedButton(
        onPressed: () {
          // Navigate to Home Page
          Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => HomePage(null, null),
  ),
);

        },
        child: Text('Skip'),
      ),
    ),
  ),
),

        ],
      ),
    );
  }
}
class OTPVerificationPage extends StatefulWidget {
  final String dialCode;
  final String phoneNumber;

  OTPVerificationPage(this.dialCode, this.phoneNumber);

  @override
  OTPVerificationPagestate createState() => OTPVerificationPagestate();
}

class OTPVerificationPagestate extends State<OTPVerificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('otp verification here'),
            Text('Dial Code: ${widget.dialCode}'),
            Text('Phone Number: ${widget.phoneNumber}'),
          ],
        ),
      ),
    );
  }
}