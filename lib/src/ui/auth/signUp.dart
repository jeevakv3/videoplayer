import '../../../allpackages.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  TextEditingController nameController = TextEditingController();

  TextEditingController phonenoController = TextEditingController();

  TextEditingController dobController = TextEditingController();

  TextEditingController mailController = TextEditingController();

  String? countryCodes = '+91';

  String? profileUrl;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final LoginBloc _loginBloc = context.read<LoginBloc>();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorConstant.appColor,
          title: CommonText(
            title: 'SignUp',
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
                          child: Align(
                        alignment: Alignment.topCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: size.height * 0.015,
                            ),
                            if (state is AuthUserImageState)
                              CircleAvatar(
                                backgroundColor: ColorConstant.appColor,
                                radius: 55,
                                backgroundImage: NetworkImage(state.imageUrl),
                              ),
                            if (state is AuthUserImageLoadingState)
                              CircleAvatar(
                                backgroundColor: ColorConstant.appColor,
                                radius: 55,
                              ),
                            TextButton(
                              onPressed: () {
                                _loginBloc.add(SignUpImageEvent());
                              },
                              child: CommonText(
                                title: 'Add Photo',
                                fontSize: 18,
                                textDecoration: TextDecoration.underline,
                                fontWeight: FontWeight.w400,
                                color: ColorConstant.blueColor,
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.055,
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 12, right: 12, top: 10, bottom: 10),
                                child: CommonText(
                                  title: 'Name',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: ColorConstant.greyColor,
                                ),
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
                                child: TextField(
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    hintText: ' Enter name',
                                    helperStyle: GoogleFonts.getFont('Inter',
                                        textStyle: const TextStyle(
                                          fontSize: 11,
                                          color: Color(0xff666666),
                                          fontWeight: FontWeight.w200,
                                        )),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 12, right: 12, top: 10, bottom: 10),
                                child: CommonText(
                                  title: 'Phone no',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: ColorConstant.greyColor,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 12, right: 12, bottom: 10),
                              child: Container(
                                  height: 60,
                                  width: size.width * 0.9,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade400),
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
                                          controller: phonenoController,
                                          decoration: InputDecoration(
                                            hintText: ' Enter Phone no',
                                            helperStyle: GoogleFonts.getFont(
                                                'Inter',
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
                            Align(
                              alignment: Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 12, right: 12, top: 10, bottom: 10),
                                child: CommonText(
                                  title: 'Email',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: ColorConstant.greyColor,
                                ),
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
                                child: TextField(
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    hintText: ' Enter email id',
                                    helperStyle: GoogleFonts.getFont('Inter',
                                        textStyle: const TextStyle(
                                          fontSize: 11,
                                          color: Color(0xff666666),
                                          fontWeight: FontWeight.w200,
                                        )),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
                            if (nameController.text.isNotEmpty &&
                                mailController.text.isNotEmpty &&
                                phonenoController.text.isNotEmpty) {
                              _loginBloc.add(SignUpEvent(
                                  name: nameController.text,
                                  phone:
                                      '${countryCodes}${phonenoController.text}',
                                  mailId: mailController.text,
                                  profileUrl: profileUrl!));
                            }
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OtpScreen(
                                          verficationId: '',
                                        )));
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
          },
          listener: (context, state) {
            if (state is AuthUserImageState) {
              profileUrl = state.imageUrl;
            }
            if (state is AuthOtpSendState) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => OtpScreen(
                            verficationId: state.verficationId,
                          )));
            }
          },
        ));
  }
}
