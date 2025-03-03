import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:navigator_app/constants/Text.dart';
import 'package:navigator_app/constants/size.dart';
import 'package:google_fonts/google_fonts.dart';



class OTPScreen extends StatelessWidget{
    const OTPScreen({Key?  key}) : super (key: key);

    @override
   Widget build(BuildContext context){
      return Scaffold(
        body: Container(
          padding: const EdgeInsets.all(tDefaultSize),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                 Text('Verification',style: GoogleFonts.montserrat(
                   fontWeight: FontWeight.bold,
                   fontSize: 40,
                ),
              ),
              Text('We\'ve sent you the verification\ncode on a******@email.com\n will comlete it later ',style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 40.0),
              OtpTextField(
                numberOfFields: 4,
                fillColor: Colors.black.withOpacity(0.1),
                filled: true,
                keyboardType: TextInputType.number,
                onSubmit: (code){print("OTP is => $code" );},
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                width: double.infinity,
                  child: ElevatedButton(onPressed: (){}, child: Text(tNext))),
              Text('We\'ve sent you the verification\ncode on a******@email.com',style: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
        ),
      );
    }
}