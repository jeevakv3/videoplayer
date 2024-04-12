import '../../../allpackages.dart';

abstract class AuthProcessEvent extends Equatable {
  const AuthProcessEvent();
}

class PhoneNumberVerficationEvent extends AuthProcessEvent {
  final String phoneNumber;
  PhoneNumberVerficationEvent({required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber];
}

class OtpVerficationEvent extends AuthProcessEvent {
  final String otp;
  final String verficationId;
  OtpVerficationEvent({required this.otp, required this.verficationId});

  @override
  List<Object?> get props => [otp];
}

class SignUpEvent extends AuthProcessEvent {
  final String name;
  final String phone;
  final String mailId;
  final String profileUrl;
  SignUpEvent(
      {required this.name,
      required this.phone,
      required this.mailId,
      required this.profileUrl});

  @override
  List<Object?> get props => [name, phone, mailId, profileUrl];
}

class SignUpImageEvent extends AuthProcessEvent {
  SignUpImageEvent(
      //   required this.image,
      );

  @override
  List<Object?> get props => [];
}

class CheckStatusEvent extends AuthProcessEvent {
  const CheckStatusEvent();

  @override
  List<Object?> get props => [];
}

abstract class AuthProcessState extends Equatable {
  const AuthProcessState();
}

class AuthInitialState extends AuthProcessState {
  const AuthInitialState();

  @override
  List<Object?> get props => [];
}

class AuthLoadingState extends AuthProcessState {
  const AuthLoadingState();

  @override
  List<Object?> get props => [];
}

class AuthUserImageLoadingState extends AuthProcessState {
  const AuthUserImageLoadingState();

  @override
  List<Object?> get props => [];
}

class AuthUserImageState extends AuthProcessState {
  final String imageUrl;
  const AuthUserImageState({required this.imageUrl});

  @override
  List<Object?> get props => [imageUrl];
}

class AuthOtpSendState extends AuthProcessState {
  String verficationId;
  AuthOtpSendState({required this.verficationId});

  @override
  List<Object?> get props => [verficationId];
}

class AuthVerfiedState extends AuthProcessState {
  const AuthVerfiedState();

  @override
  List<Object?> get props => [];
}

class AuthFailureState extends AuthProcessState {
  const AuthFailureState();

  @override
  List<Object?> get props => [];
}

class AuthStatisState extends AuthProcessState {
  const AuthStatisState();

  @override
  List<Object?> get props => [];
}

class LoginBloc extends Bloc<AuthProcessEvent, AuthProcessState> {
  LoginBloc() : super(const AuthInitialState()) {
    on<PhoneNumberVerficationEvent>(_phoneVerfication);
    on<OtpVerficationEvent>(otpVerfication);
    on<SignUpImageEvent>(uploadImage);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _phoneVerfication(
    PhoneNumberVerficationEvent event,
    Emitter<AuthProcessState> emits,
  ) async {
    emit(const AuthLoadingState());
    try {
      DocumentSnapshot data = await FirebaseFirestore.instance
          .collection('users')
          .doc(event.phoneNumber)
          .get();
      // if (data.exists) {
      _auth.verifyPhoneNumber(
        phoneNumber: event.phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          User? user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            emit(const AuthVerfiedState());
          } else {
            emit(const AuthFailureState());
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          emit(const AuthFailureState());
        },
        codeSent: (String verificationId, int? resendToken) {
          emit(AuthOtpSendState(verficationId: verificationId));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
      // } else {
      // emit(const AuthInitialState());
      //   Fluttertoast.showToast(
      //       msg: 'Your number not be register go to signup your number');
      // }
    } catch (e) {
      print(e);
      emit(const AuthFailureState());
    }
  }

  Future<void> otpVerfication(
    OtpVerficationEvent event,
    Emitter<AuthProcessState> emits,
  ) async {
    emit(const AuthLoadingState());
    try {
      AuthCredential credential = await PhoneAuthProvider.credential(
          verificationId: event.verficationId, smsCode: event.otp);
      UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      emit(const AuthVerfiedState());
    } catch (e) {
      emit(const AuthFailureState());
    }
  }

  Future<void> usersignUp(
    SignUpEvent event,
    Emitter<AuthProcessState> emits,
  ) async {
    emit(const AuthLoadingState());
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(event.phone)
          .set({
        'name': event.name,
        'phoneNo': event.phone,
        'profileUrl': event.profileUrl,
        'mail': event.mailId
      });
      await _auth.verifyPhoneNumber(
        phoneNumber: event.phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          User? user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            emit(const AuthVerfiedState());
          } else {
            emit(const AuthFailureState());
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          emit(const AuthFailureState());
        },
        codeSent: (String verificationId, int? resendToken) {
          emit(AuthOtpSendState(verficationId: verificationId));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      emit(const AuthFailureState());
    }
  }

  Future<void> uploadImage(
      SignUpImageEvent event, Emitter<AuthProcessState> emits) async {
    emit(AuthUserImageLoadingState());
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return null;
    }
    String fileName = basename(image.path); // Requires path package
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('uploads/$fileName');
    UploadTask uploadTask = ref.putFile(File(image.path));

    try {
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      print(downloadUrl);
      emit(AuthUserImageState(imageUrl: downloadUrl));
    } catch (e) {
      print(e);
    }
  }
}
