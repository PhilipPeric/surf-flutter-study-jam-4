import 'package:flutter/material.dart';
import 'package:shake/shake.dart';
import '../data/predictor_service.dart';

class MagicBallScreen extends StatefulWidget {
  const MagicBallScreen({Key? key}) : super(key: key);

  @override
  State<MagicBallScreen> createState() => _MagicBallScreenState();
}

class _MagicBallScreenState extends State<MagicBallScreen> {
  String? prediction;
  bool gotError = false;

  final predictorService = PredictorService();

  Future<void> _getPrediction() async {
    var resp = await predictorService.getPrediction();

    setState(() {
      prediction = resp;
      if (resp == null) {
        gotError = true;
      } else {
        gotError = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    ShakeDetector _ = ShakeDetector.autoStart(
      onPhoneShake: () async {
        await _getPrediction();
      },
      minimumShakeCount: 1,
      shakeSlopTimeMS: 500,
      shakeCountResetTime: 3000,
      shakeThresholdGravity: 2.7,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFEFEFE), Color(0xFFD2D3FE)])),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(alignment: Alignment.center, children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.90,
                  child: InkWell(
                    onTap: () async => await _getPrediction(),
                    child: const Image(
                        image: AssetImage('assets/mask_group_light.png')),
                  ),
                ),
                if (gotError)
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.90,
                    child: InkWell(
                      onTap: () async => await _getPrediction(),
                      child: const Image(
                          image: AssetImage('assets/error_ball.png')),
                    ),
                  ),
                if (prediction != null)
                  Text(
                    prediction!,
                    style: const TextStyle(
                        fontFamily: 'GillSans',
                        color: Color(0xFF6C698C),
                        fontSize: 32),
                  ),
              ]),
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.90,
                      child: const Image(
                          image: AssetImage('assets/ellipse_light.png')),
                    ),
                  ),
                  if (gotError)
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.90,
                      child: InkWell(
                        onTap: () async => await _getPrediction(),
                        child: const Image(
                            image: AssetImage('assets/error_ellipse.png')),
                      ),
                    ),
                ],
              ),
              const Center(
                child: Text(
                  'Нажмите на шар \nили потрясите телефон',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'GillSans',
                    fontSize: 16,
                    color: Color(0xFF6C698C),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
