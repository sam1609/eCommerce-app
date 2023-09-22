import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
//import 'package:flutter/material.dart';

const String apiurl="https://ecommerceapi.cloudpub.in";
const String accessCode='lknoXi8oXYZp9U3Xd/6vngMBRKImyBVgs67AKIH+GnY=';
// final String iCompanyID ='1';
// final String BranchID = '1';
  String username = '-11';
  String password = 'DC6F7CCB2DAD40BB9AF09BBFF07C273A';
  String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
String? companyid;
String? branchid;
String? signupvia;
String? companyname;
String? financialperiod;
// Future<Map<String, dynamic>> WebGetCompanyDetail() async {
 
//   final url = apiurl+'/api/WebCompanyInfo?accessCode='+accessCode;

//   final response = await http.get(Uri.parse(url));

//   if (response.statusCode == 200) {
//     final parsed = jsonDecode(response.body);
//     print('here is the parsed : $parsed');
//     return parsed;
//   } else {
//     throw Exception('Failed to reverse geocode coordinates');
//   }
// }
Future<void> fetchCompanyInfo() async {
  const String apiUrl = 'https://ecommerceapi.cloudpub.in/api/WebCompanyInfo?accessCode=$accessCode';
  final Uri uri = Uri.parse(apiUrl);
  final response = await http.post(
    uri,
    headers: {
      'Authorization': basicAuth,
    },
  );
  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body)[0];
    companyid = data['iCompanyId'].toString();
    branchid = data['iBranchID'].toString();
    signupvia=data['SignUpVia'].toString();
     companyname=data['CompanyName'].toString();
        financialperiod=data['FinancialPeriod'].toString();
        print('The output is : $companyid$branchid$signupvia$companyname$financialperiod');
  } else {
    throw Exception('Failed to fetch data');
  }
}
// ignore: non_constant_identifier_names
Future<List<Map<String, dynamic>>> fetchSliderHomePage(String sliderseq) async {
  final String apiUrl = 'https://ecommerceapi.cloudpub.in/api/WebGetSliderHomePage?iCompanyID=${companyid.toString()}&iBranchID=${branchid.toString()}&accessCode=$accessCode&SLiderSeq=${sliderseq.toString()}';
  print('Here is company id: $companyid');
   print('Here is branch id: $branchid');
   print(accessCode);
  final Uri uri = Uri.parse(apiUrl);
  final response = await http.post(
    uri,
    headers: {
      'Authorization': basicAuth,
    },
  );

  if (response.statusCode == 200) {
    return List<Map<String, dynamic>>.from(jsonDecode(response.body));
  } else {
    throw Exception('Failed to fetch data');
  }
}

Future<List<String>> getCategoryMultiLevel(String iCompanyID) async {
  String apiUrl = '$apiurl/api/WebGetmultiLevelCategoryOfItem';
  final Uri uri = Uri.parse('$apiUrl?striCompanyID=$iCompanyID&accessCode=$accessCode');

  final response = await http.post(
    uri,
    headers: {
      'Authorization': basicAuth,
    },
  );

 List<String> categories = [];
  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    categories = List<String>.from(data.map((item) => item['CategoryDesc']));
  }
  //print('here is the output of categories: $categories');
  return categories;
}

Future<Map<String, dynamic>> reverseGeocode(double latitude, double longitude) async {
  final apiKey = 'pk.c4abc5734e15330c360f976acd611cf5'; // Replace with your LocationIQ API key
  final url = 'https://us1.locationiq.com/v1/reverse?key=$apiKey&lat=$latitude&lon=$longitude&format=json';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final parsed = jsonDecode(response.body);
    //print('here is the parsed : ${parsed['display_name']}');
    return parsed;
  } else {
    throw Exception('Failed to reverse geocode coordinates');
  }
}

