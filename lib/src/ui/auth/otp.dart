import '../../../allpackages.dart';

class OtpScreen extends StatefulWidget {
  final verficationId;
  const OtpScreen({required this.verficationId});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  TextEditingController pincodeController = TextEditingController();

  int _resendTokenCooldown = 0;

  Timer? _timer;

  void resendOTP() {
    if (_resendTokenCooldown == 0) {
      setState(() => _resendTokenCooldown = 59); // 30 seconds cooldown
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_resendTokenCooldown > 0) {
          setState(() => _resendTokenCooldown--);
        } else {
          _timer?.cancel();
        }
      });
    }
  }

  void _listenForOtp() async {
    var d = await SmsAutoFill().listenForCode;
    print(d.toString());
  }

  @override
  void initState() {
    super.initState();
    resendOTP();
    _listenForOtp();
  }

  @override
  void dispose() {
    _timer?.cancel();
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final LoginBloc _loginBloc = context.read<LoginBloc>();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConstant.appColor,
          title: CommonText(
            title: 'OTP Verfication',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: ColorConstant.whiteColor,
          ),
          centerTitle: true,
        ),
        body: BlocConsumer<LoginBloc, AuthProcessState>(
          builder: (context, state) {
            return Stack(
              children: [
                Container(
                  color: state is AuthLoadingState
                      ? Colors.grey.withOpacity(0.5)
                      : Colors.white,
                  child: Column(
                    children: [
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 12, right: 12, top: 25, bottom: 10),
                            child: CommonText(
                              title:
                                  'Enter 6 digit code which was sent to +91 9080613668',
                              color: ColorConstant.blackColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 12, right: 12, top: 12, bottom: 10),
                            child: CommonText(
                              title: ' Enter OTP',
                              color: ColorConstant.greyColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 15),
                            child: PinFieldAutoFill(
                              controller: pincodeController,
                              codeLength: 6,
                              onCodeChanged: (code) {
                                if (code != null && code.length == 6) {
                                  pincodeController.text = code;
                                  _loginBloc.add(OtpVerficationEvent(
                                      otp: pincodeController.text,
                                      verficationId: widget.verficationId));
                                }
                              },
                            ),

                            // PinCodeTextField(
                            //   length: 6,
                            //   obscureText: false,
                            //   animationType: AnimationType.fade,
                            //   pinTheme: PinTheme(
                            //     shape: PinCodeFieldShape.underline,
                            //     borderRadius: BorderRadius.circular(10),
                            //     fieldHeight: 50,
                            //     fieldWidth: 40,
                            //     activeColor: Colors.green.shade400.withOpacity(0.4),
                            //     selectedFillColor: ColorConstant.whiteColor,
                            //     inactiveFillColor: Colors.green.shade400.withOpacity(0.4),
                            //     disabledColor: ColorConstant.whiteColor,
                            //     inactiveColor: ColorConstant.whiteColor,
                            //     activeFillColor: Colors.green.shade400.withOpacity(0.4),
                            //   ),
                            //   animationDuration: Duration(milliseconds: 300),
                            //   backgroundColor: ColorConstant.whiteColor,
                            //   enableActiveFill: true,
                            //   controller: pincodeController,
                            //   onCompleted: (v) {
                            //     print("Completed");
                            //   },
                            //   onChanged: (value) {},
                            //   beforeTextPaste: (text) {
                            //     return true;
                            //   },
                            //   appContext: context,
                            // ),
                          ),
                          Center(
                            child: TextButton(
                              onPressed: _resendTokenCooldown > 0
                                  ? null
                                  : () {
                                      resendOTP();
                                    },
                              child: Text(_resendTokenCooldown > 0
                                  ? 'Resend OTP in $_resendTokenCooldown'
                                  : 'Resend OTP'),
                            ),
                          )
                        ],
                      )),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: RichText(
                            text: TextSpan(
                              style: GoogleFonts.getFont('Inter',
                                  textStyle: const TextStyle(
                                    fontSize: 15,
                                    color: Color(0xff666666),
                                    fontWeight: FontWeight.w600,
                                  )),
                              children: <TextSpan>[
                                const TextSpan(
                                    text: 'Already you have an account?  '),
                                TextSpan(
                                  text: 'SignIn',
                                  style: GoogleFonts.getFont('Inter',
                                      textStyle: TextStyle(
                                        fontSize: 15,
                                        color: ColorConstant.appColor,
                                        fontWeight: FontWeight.w600,
                                      )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15, top: 15),
                        child: Center(
                            child: InkWell(
                          onTap: () {
                            _loginBloc.add(OtpVerficationEvent(
                                otp: pincodeController.text,
                                verficationId: widget.verficationId));
                          },
                          child: Container(
                            height: size.height * 0.065,
                            width: size.width * 0.9,
                            decoration: BoxDecoration(
                                color: ColorConstant.appColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: Center(
                              child: CommonText(
                                title: 'Continue',
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: ColorConstant.whiteColor,
                              ),
                            ),
                          ),
                        )),
                      )
                    ],
                  ),
                ),
                state is AuthLoadingState
                    ? Align(
                        alignment: Alignment.center,
                        child: Container(
                          child: const CircularProgressIndicator(),
                        ))
                    : Container()
              ],
            );
          },
          listener: (context, state) {
            if (state is AuthVerfiedState) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DashBoardScreen()));
            }
          },
        ));
  }
}
