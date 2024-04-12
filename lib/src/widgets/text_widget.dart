import '../../allpackages.dart';

class CommonText extends StatelessWidget {
  String title;
  Color color;
  double fontSize;
  FontWeight fontWeight;
  TextDecoration? textDecoration;
  CommonText(
      {required this.title,
      required this.color,
      required this.fontSize,
      required this.fontWeight,
      this.textDecoration});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.getFont('Inter',
          textStyle: TextStyle(
              decoration: textDecoration,
              fontSize: fontSize,
              color: color,
              fontWeight: fontWeight)),
    );
  }
}
