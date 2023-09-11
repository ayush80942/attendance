import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

bool _isLoading = false;

Future<String> sendOTP(String enrollment_no, String instructorId) async {
  final url = 'https://newsdcattendance.onrender.com/updatePassword';
  final response = await http.post(Uri.parse(url),
      body: {'instructor_id': instructorId, "enrollment_no": "NA"});

  if (response.statusCode == 200) {
    SnackBar(
      content: Text("OTP sent successfully"),
    );
    return response.body;
  } else {
    throw Exception('Failed to send OTP');
  }
}

Future<String> verifyOTPAndChangePassword(
    String otp, String instructorId, String newPassword) async {
  final url = 'https://newsdcattendance.onrender.com/verifyOtp';
  final response = await http.post(Uri.parse(url), body: {
    'instructor_id': instructorId,
    "enrollment_no": "NA",
    'new_password': newPassword,
    'otp': otp,
  });

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    final success = jsonResponse['success'];

    if (success) {
      final message = jsonResponse['message'];
      return message;
    } else {
      throw Exception('Failed to verify OTP and change password');
    }
  } else {
    throw Exception('Failed to verify OTP and change password');
  }
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _instructorIdController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Center(
                child: Text(
                    'Generated OTP will be sent to your registered Email address.',
                    style: TextStyle(
                      color: Color.fromARGB(255, 233, 114, 105),
                      
                ),textAlign: TextAlign.left,),
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromARGB(105, 158, 158, 158),
                ),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                const SizedBox(
                  width: 4,
                ),
                Text(
                  'ENTER YOUR INSTRUCTOR ID',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.05,),
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              height: 44,
              child: TextFormField(
                controller: _instructorIdController,
                decoration: InputDecoration(
                  labelText: 'Instructor ID ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(160, 50),
                  backgroundColor: Color.fromRGBO(0, 70, 121, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  try {
                    final response =
                        await sendOTP("NA", _instructorIdController.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(response)),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to send OTP')),
                    );
                  }
                },
                child: Text('Send OTP'),
              ),
            ),
            SizedBox(height: 40),
            Text(
              'ENTER OTP AND NEW PASSWORD',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.05,),
            ),
            SizedBox(height: 10),
            Container(
              height: 44,
              child: TextFormField(
                controller: _otpController,
                decoration: InputDecoration(
                  labelText: 'OTP',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              height: 44,
              child: TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(160, 50),
                  backgroundColor: Color.fromRGBO(0, 70, 121, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  foregroundColor: Colors.white,
                ),
                onPressed: () async {
                  if (!_isLoading) {
                    setState(() {
                      _isLoading = true;
                    });
                    try {
                      final response = await verifyOTPAndChangePassword(
                        // _enrollment_noController.text,
                        _otpController.text,
                        _instructorIdController.text,
                        _newPasswordController.text,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(response)),
                      );
                    } catch (e) {
                      print(e);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('Failed to verify OTP and change password'),
                        ),
                      );
                    }
                    setState(() {
                      _isLoading = false;
                    });
                  }
                },
                child: Text('Verify OTP & Update Password '),
              ),
            ),
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //     minimumSize: Size(327, 69),
            //     backgroundColor: Color.fromRGBO(0, 70, 121, 1),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(50),
            //     ),
            //   ),
            //   onPressed: () async {
            //     if (!_isLoading) {
            //       setState(() {
            //         _isLoading = true;
            //       });
            //       try {
            //         final response = await verifyOTPAndChangePassword(
            //           // _enrollment_noController.text,
            //           _otpController.text,
            //           _instructorIdController.text,
            //           _newPasswordController.text,
            //         );
            //         ScaffoldMessenger.of(context).showSnackBar(
            //           SnackBar(content: Text(response)),
            //         );
            //       } catch (e) {
            //         print(e);
            //         ScaffoldMessenger.of(context).showSnackBar(
            //           SnackBar(
            //             content:
            //                 Text('Failed to verify OTP and change password'),
            //           ),
            //         );
            //       }
            //       setState(() {
            //         _isLoading = false;
            //       });
            //     }
            //   },
            //   child: Text('Verify OTP & Update Password'),
            // ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _instructorIdController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }
}
