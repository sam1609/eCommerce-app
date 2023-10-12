import 'package:flutter/material.dart';
import 'package:upi_india/upi_india.dart';
String transactionRefId = DateTime.now().millisecondsSinceEpoch.toString();

class FormPage extends StatefulWidget {
  final double netAmount;

  FormPage({required this.netAmount});

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  UpiIndia _upiIndia = UpiIndia();
  List<UpiApp>? apps;

  @override
  void initState() {
    super.initState();
    
    // Place the snippet here
    _upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value) {
      print('Fetched UPI apps: $value');  // Debug print to check fetched apps
      setState(() {
        apps = value;
      });
    }).catchError((e) {
      print('Error fetching UPI apps: $e');  // Debug print to check for errors
      apps = [];
    });
  }
  
    Future<void> showUpiAppChooser() async {
    if (apps == null || apps!.isEmpty) {showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('No UPI Apps Found'),
            content: Text('Please install a UPI app to proceed with the transaction.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();  // Close the dialog
                },
              ),
            ],
          );
        },
      );
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text('Choose UPI App'),
          children: apps!.map<Widget>((UpiApp app) {
            return SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(context);  // Close the dialog
                UpiResponse response = await initiateTransaction(app);
                
                // Handle the response here
                String txnStatus;
                switch (response.status) {
                  case UpiPaymentStatus.SUCCESS:
                    txnStatus = 'Transaction Successful';
                    break;
                  case UpiPaymentStatus.SUBMITTED:
                    txnStatus = 'Transaction Submitted';
                    break;
                  case UpiPaymentStatus.FAILURE:
                    txnStatus = 'Transaction Failed';
                    break;
                  default:
                    txnStatus = 'Unknown Transaction Status';
                    break;
                }
                // Show a dialog or snackbar with the transaction status
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(txnStatus)),
                );
              },
              child: Row(
                children: [
                  Image.memory(
                    app.icon,
                    height: 40,
                    width: 40,
                  ),
                  SizedBox(width: 10),
                  Text(app.name),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

   Future<UpiResponse> initiateTransaction(UpiApp app) async {
    String transactionRefId = DateTime.now().millisecondsSinceEpoch.toString();  // Example using timestamp
    return _upiIndia.startTransaction(
      app: app,
      receiverUpiId: "sahilchugh1609-1@okhdfcbank",
      receiverName: 'Sahil Chugh',
      transactionRefId: transactionRefId,
      transactionNote: 'Testing payment',
      amount: widget.netAmount,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fill Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:  Form(
          key: _formKey,
          child: Column(
            children: [
            // ... Your form fields go here ...
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Phone number',
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                  if (value == null || value.isEmpty || value.length<10) {
                    return 'Phone Number Must contain atleast 10 Digits';
                  }
                  return null;
                },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Name',
              ),
              keyboardType: TextInputType.text,
              validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Address Line 1',
              ),
              keyboardType: TextInputType.text,
              validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Address Line 1 is required';
                  }
                  return null;
                },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Address Line 2',
              ),
              keyboardType: TextInputType.text,
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'City',
              ),
              keyboardType: TextInputType.text,
              validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'City is required';
                  }
                  return null;
                },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'State',
              ),
              keyboardType: TextInputType.text,
              validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'State is required';
                  }
                  return null;
                },
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Country',
              ),
              keyboardType: TextInputType.text,
              validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Country is required';
                  }
                  return null;
                },
            ),

SizedBox(height: 20,),

   Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        showUpiAppChooser();
                      }
                    },
                    child: Text('Proceed to Pay ₹${widget.netAmount}'),
                  ),
                ),
              ),
            // Text(
            //   'Net Amount: ${widget.netAmount}',
            //   style: TextStyle(fontSize: 20),
            // ),
          ],
        ),
      ),
    ));
  }
}