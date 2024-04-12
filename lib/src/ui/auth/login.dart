import 'package:video_playerapp/src/src.dart';

import '../../../allpackages.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController phoneNoController = TextEditingController();

  String? countryCodes = '+91';

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final LoginBloc _loginBloc = context.read<LoginBloc>();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConstant.appColor,
          title: CommonText(
            title: 'Login',
            fontSize: 20,
            fontWeight: FontWeight.w900,
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
                              title: 'Phone no',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: ColorConstant.greyColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 12, right: 12, bottom: 10),
                            child: Container(
                                height: 60,
                                width: size.width * 0.9,
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade400),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  children: [
                                    CountryCodePicker(
                                      onChanged: (CountryCode countryCode) {
                                        print(
                                            "Country code: ${countryCode.dialCode}");
                                        countryCodes =
                                            '${countryCode.dialCode}';
                                      },
                                      initialSelection: 'IN',
                                      favorite: ['+91', 'IN'],
                                      showCountryOnly: false,
                                      showOnlyCountryWhenClosed: false,
                                      alignLeft: false,
                                    ),
                                    VerticalDivider(
                                      color: Colors.grey.shade400,
                                      thickness: 1,
                                      indent: 20,
                                      endIndent: 20,
                                    ),
                                    Expanded(
                                      child: TextField(
                                        controller: phoneNoController,
                                        decoration: InputDecoration(
                                          hintText: ' Enter Phone no',
                                          helperStyle:
                                              GoogleFonts.getFont('Inter',
                                                  textStyle: const TextStyle(
                                                    fontSize: 11,
                                                    color: Color(0xff666666),
                                                    fontWeight: FontWeight.w200,
                                                  )),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpScreen()));
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
                                  text: 'Don`t not have an account?  '),
                              TextSpan(
                                text: 'SignUp',
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
                          print('${countryCodes}${phoneNoController.text}');
                          _loginBloc.add(PhoneNumberVerficationEvent(
                              phoneNumber:
                                  '${countryCodes}${phoneNoController.text}'));
                        },
                        child: Container(
                          height: size.height * 0.065,
                          width: size.width * 0.9,
                          decoration: BoxDecoration(
                              color: ColorConstant.appColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: CommonText(
                              title: 'Get Otp',
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
        }, listener: (context, state) {
          if (state is AuthOtpSendState) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OtpScreen(
                          verficationId: state.verficationId,
                        )));
          }
        }));
  }
}
