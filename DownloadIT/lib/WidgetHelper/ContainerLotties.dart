import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class ContainerLotties extends StatefulWidget {
  final String header;
  final String animationPath;

  const ContainerLotties({
    Key key,
    @required this.header,
    @required this.animationPath,
  }) : super(key: key);

  @override
  _ContainerLottiesState createState() => _ContainerLottiesState();
}

class _ContainerLottiesState extends State<ContainerLotties> {
  var connectivity;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height * .20,
        width: MediaQuery.of(context).size.width * .38,
        decoration: _semptomBoxDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(11),
          child: Center(
            child: Table(

              children: <TableRow>[
                TableRow(children: [
                  TableCell(
                    child: AspectRatio(
                      aspectRatio: 2,
                      child: Center(
                          child:  Image.asset(widget.animationPath, fit: BoxFit.fitHeight,)

                      ),
                    ),
                  )
                ]),
                TableRow(children: [TableCell(child: Text(widget.header, style: _secondaryStyle, textAlign: TextAlign.center))]),

              ],
            ),
          ),
        ),
      ),
    );
  }
  TextStyle get _secondaryStyle => GoogleFonts.openSans(
      color: Color(0xFF5C93C4),
      fontWeight: FontWeight.w700,
      letterSpacing: 0.20,
      fontSize: 12);
  BoxDecoration _semptomBoxDecoration() {
    return BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.all(Radius.circular(20)),
      boxShadow: [BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10)],
    );
  }

}