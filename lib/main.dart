import 'package:flutter/material.dart';
import 'dart:convert';
import 'homepage.dart';
import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('Initializing Firebase...');
  try {
    await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully.');
  }catch (e, s) {
    print('Failed to initialize Firebase: $e\n$s');
   // return;  // Return early, don't start the app if Firebase initialization fails
  }
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
void checkPhoneNumber() async {
  if (phoneNumberController.text.length == 10) {
    final String phoneNumber = '${selectedCountry?.dialCode ?? ''}${phoneNumberController.text}';
    try {
      print('Sending SMS to: $phoneNumber'); // Add this line
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {
          print('Verification completed');
          // Handle automatic code verification
        },
        verificationFailed: (FirebaseAuthException e) {
          print('Verification failed: ${e.message}');
          // Handle verification failed
        },
        codeSent: (String verificationId, int? resendToken) {
          print('Code sent: $verificationId'); // Add this line
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OTPVerificationPage(
                phoneNumber,
                verificationId,
                checkPhoneNumber,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('Auto retrieval timeout');
          // Handle auto retrieval timeout
        },
      );
    } catch (e, s) {
      print('Exception: $e\nStack trace: $s');
    }
  } else {
    print('Phone number is not 10 digits long');
  }
}



  // Function to show the country selection bottom sheet
  void showCountrySelectionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: countries.length,
          itemBuilder: (context, index) {
            final country = countries[index];
            return ListTile(
              title: Text('${country.flag}  ${country.name}  ${country.dialCode}'),
              onTap: () {
                setState(() {
                  selectedCountry = country;
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
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
              'Urban Company',
              style: TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'Your Home Services Expert',
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
              Container(
                 padding: EdgeInsets.all(8.0), // Add padding around the GestureDetector
  decoration: BoxDecoration(
    border: Border.all(
      color: Colors.grey, // You can change the color
      width: 1.0, // You can change the border width
    ),
    borderRadius: BorderRadius.circular(5.0), // You can adjust the border radius
  ),
  child: GestureDetector(
    onTap: showCountrySelectionSheet,
    child: Row(
      children: [
        Text(selectedCountry?.flag ?? ''),
        SizedBox(width: 3),
        Text(
          ' ${selectedCountry?.dialCode}',
        ),
      ],
    ),
  ),
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
  final String phoneNumber;
 final String verificationId;
 final Function resendOTP;
  OTPVerificationPage(this.phoneNumber, this.verificationId, this.resendOTP);

  @override
  OTPVerificationPageState createState() => OTPVerificationPageState();
}

class OTPVerificationPageState extends State<OTPVerificationPage> {
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  TextEditingController _controller3 = TextEditingController();
  TextEditingController _controller4 = TextEditingController();
  TextEditingController _controller5 = TextEditingController();
  TextEditingController _controller6 = TextEditingController();
  List<FocusNode> _focusNodes = [
  FocusNode(),
  FocusNode(),
  FocusNode(),
  FocusNode(),
  FocusNode(),
  FocusNode(),
];
  late Timer _timer;
  int _start = 120;
  bool _showResend = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }
void verifyOTP() async {
  final String otpCode = '${_controller1.text}${_controller2.text}${_controller3.text}${_controller4.text}${_controller5.text}${_controller6.text}';
  print('Verifying OTP: $otpCode, verificationId: ${widget.verificationId}'); // Add this line
  final PhoneAuthCredential credential = PhoneAuthProvider.credential(
    verificationId: widget.verificationId,
    smsCode: otpCode,
  );
 try {
    await FirebaseAuth.instance.signInWithCredential(credential);
    print('Verification successful');
    print(widget.phoneNumber);
String phoneNumber = '';
String countryCode = '';

if (widget.phoneNumber.length >= 10) {
  // Extract the last 10 digits as the phone number
  phoneNumber = widget.phoneNumber.substring(widget.phoneNumber.length - 10);

  // Extract the rest as the country code
  countryCode = widget.phoneNumber.substring(0, widget.phoneNumber.length - 10);
}
print(phoneNumber);
print(countryCode);
    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(countryCode ,phoneNumber),
      ),
    );
  } catch (e) {
    print('Verification failed: $e'); // Add this line
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Verification Failed'),
          content: Text('An error occurred during verification. Please try again.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}


  void startTimer() {
    _start = 120;
    _showResend = false;
    _timer = Timer.periodic(
      Duration(seconds: 1),
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            _showResend = true;
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('OTP Verification'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter Verification Code',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'We have sent you a 6 digit verification code on the mobile number ending with ${widget.phoneNumber.substring(widget.phoneNumber.length - 4)}',
            ),
           Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    singleOTPBox(_controller1, _focusNodes[0], _focusNodes[1]),
    singleOTPBox(_controller2, _focusNodes[1], _focusNodes[2]),
    singleOTPBox(_controller3, _focusNodes[2], _focusNodes[3]),
    singleOTPBox(_controller4, _focusNodes[3], _focusNodes[4]),
    singleOTPBox(_controller5, _focusNodes[4], _focusNodes[5]),
    singleOTPBox(_controller6, _focusNodes[5], null),
  ],
),
 SizedBox(height: 20),  // Add some space between the OTP fields and the Verify button
            ElevatedButton(
              onPressed: verifyOTP,  // Call the verifyOTP method when the button is pressed
              child: Text('Verify'),
            ),

             _showResend
                ? ElevatedButton(
                    onPressed: () {
                      widget.resendOTP();  // Call resendOTP method when the button is pressed
                    },
                    child: Text('Resend'),
                  )
                : Text('$_start seconds'),
          ],
        ),
      ),
    );
  }

 Widget singleOTPBox(TextEditingController controller, FocusNode focusNode, FocusNode? nextFocusNode) {
  return Container(
    width: 40,
    child: TextField(
      focusNode: focusNode,
      controller: controller,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      maxLength: 1,
      onChanged: (value) {
        if (value.length == 1 && nextFocusNode != null) {
          FocusScope.of(context).requestFocus(nextFocusNode);
        }
      },
      decoration: InputDecoration(
        counterText: '',
        border: OutlineInputBorder(),
      ),
    ),
  );
}
}