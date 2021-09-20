import 'package:get/get.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class StateController extends GetxController {
  var opacity = [
    0.2.obs,
    0.2.obs,
    0.2.obs,
    0.2.obs,
    0.2.obs,
  ];
  var isAllButtonsActivated = false;
  var playFlag = false.obs;

  var progressValueDin = [0.0.obs, 0.0.obs, 0.0.obs, 0.0.obs, 0.0.obs];
  var progressValueAnt = [1.0.obs, 1.0.obs, 1.0.obs, 1.0.obs, 1.0.obs];
  var progressValueCal = [1.0.obs, 1.0.obs, 1.0.obs, 1.0.obs, 1.0.obs];
  var antTime = 20.obs;
  var calTime = 10.obs;
  var dinTime = 6.obs;
  var isInProgress = [false.obs, false.obs, false.obs, false.obs, false.obs];

  var kutuTempNo = 4;

// For all boxes 8 buttons contents and box play/pause button situation (9th value in array)
// 5th one is for temp values.
  List buttonsContent = [
    [
      0.obs,
      0.obs,
      0.obs,
      0.obs,
      0.obs,
      0.obs,
      0.obs,
      0.obs,
    ],
    [
      0.obs,
      0.obs,
      0.obs,
      0.obs,
      0.obs,
      0.obs,
      0.obs,
      0.obs,
    ],
    [
      0.obs,
      0.obs,
      0.obs,
      0.obs,
      0.obs,
      0.obs,
      0.obs,
      0.obs,
    ],
    [
      0.obs,
      0.obs,
      0.obs,
      0.obs,
      0.obs,
      0.obs,
      0.obs,
      0.obs,
    ],
    [
      0.obs,
      0.obs,
      0.obs,
      0.obs,
      0.obs,
      0.obs,
      0.obs,
      0.obs,
    ],
  ];

  List kutuPlayFlag = [false.obs, false.obs, false.obs, false.obs, false.obs];

  List buttonsActivatedFlag = [
    [
      //TODO tüm boxlar için buttons activated valueleri oluştur.
      false.obs,
      false.obs,
      false.obs,
      false.obs,
      false.obs,
      false.obs,
      false.obs,
      false.obs
    ],
    [
      false.obs,
      false.obs,
      false.obs,
      false.obs,
      false.obs,
      false.obs,
      false.obs,
      false.obs
    ],
    [
      false.obs,
      false.obs,
      false.obs,
      false.obs,
      false.obs,
      false.obs,
      false.obs,
      false.obs
    ],
    [
      false.obs,
      false.obs,
      false.obs,
      false.obs,
      false.obs,
      false.obs,
      false.obs,
      false.obs
    ],
    [
      false.obs,
      false.obs,
      false.obs,
      false.obs,
      false.obs,
      false.obs,
      false.obs,
      false.obs
    ]
  ];

  List kutuActivatedFlag = [false.obs, false.obs, false.obs, false.obs];
//Kutuya ilk bağlandığımızda temp buttonsContent dizisini kutu dizisine aktarıyoruz. 2. ve sonrası için bunu yapmıyoruz.
  List kutuConnectedBeforeFlag = [false.obs, false.obs, false.obs, false.obs];

  List antrenmanSuresi = [
    [10.obs, 15.obs, 20.obs, 25.obs, 30.obs],
    [15.obs, 20.obs, 25.obs, 30.obs],
    [15.obs, 20.obs, 25.obs, 30.obs, 40.obs],
    [15.obs, 20.obs, 25.obs, 30.obs],
    [5.obs, 10.obs],
    [15.obs, 20.obs, 25.obs, 30.obs]
  ];
  List calismaDinlenmeSuresi = [
    1.obs,
    2.obs,
    3.obs,
    4.obs,
    5.obs,
    6.obs,
    7.obs,
    8.obs,
    9.obs,
    10.obs
  ];
  void changeOpacity(double opacity, int kutuNo) {
    this.opacity[kutuNo].value = opacity;
  }

  void arttir(int boxNum) {
    if (kutuPlayFlag[boxNum].value) {
      //Play Flag for related box
      for (var v = 0; v < buttonsContent[boxNum].length; v++) {
        if (buttonsActivatedFlag[boxNum][v].value) {
          int intTemp = buttonsContent[boxNum][v].value + 1;
          if (intTemp >= 0 && intTemp <= 100) {
            buttonsContent[boxNum][v].value = intTemp;
          }
          // print("Button " +
          //     v.toString() +
          //     " content =" +
          //     buttonsContent[v].value.toString());
        }
      }
    }
  }

  void azalt(int boxNum) {
    if (kutuPlayFlag[boxNum].value) {
      //Play Flag for related box
      for (var v = 0; v < buttonsContent[boxNum].length; v++) {
        if (buttonsActivatedFlag[boxNum][v].value) {
          int intTemp = buttonsContent[boxNum][v].value - 1;
          if (intTemp >= 0 && intTemp <= 100) {
            buttonsContent[boxNum][v].value = intTemp;
          }
          // print("Button " +
          //     v.toString() +
          //     " content =" +
          //     buttonsContent[v].value.toString());
        }
      }
    }
  }

  void doubleTapped(int boxNum) {
    if (kutuPlayFlag[boxNum].value) {
      //Play Flag for related box
      for (var v = 0; v < buttonsActivatedFlag[boxNum].length; v++) {
        buttonsActivatedFlag[boxNum][v].value = !isAllButtonsActivated;
        // print("Button " +
        //     v.toString() +
        //     " state =" +
        //     buttonsActivatedFlag[v].toString());
      }
      isAllButtonsActivated = !isAllButtonsActivated;
    }
  }

//TODO Update proccessor methodu düzenlenecek şu anda öylesine bir gösteri çalışıyor.
//Sürelerle alaklı Hasanla konuşmam lazım. Büyük ihtimal bir önceki sayfada seçilen ayarlar
//buraya gelecek.
  // void updateProgress() {
  //   const oneSec = const Duration(seconds: 1);
  //   const oneMin = const Duration(minutes: 1);

  //   new Timer.periodic(oneSec, (Timer t) {
  //     if (!playFlag.value) {
  //       t.cancel();
  //       return;
  //     }
  //     progressValueDin.value -= 0.1;
  //     // we "finish" downloading here
  //     if (progressValueDin <= 0.0) {
  //       //isLoading.value = false;
  //       t.cancel();
  //       progressValueDin.value = 1;
  //       //TODO Antrenman bittikten sonra play butonu başlangıc durumuna getirmek adına aşagıdaki
  //       //kodu düzenleyecegim
  //       //playFlag.value = false;
  //       return;
  //     }
  //   });
  // }

  void updateProgressAntrenmanSuresi(int antSuresi, int kutuNo) {
    const oneMin = const Duration(minutes: 1);
    isInProgress[kutuNo] = true.obs;

    new Timer.periodic(
      oneMin,
      (Timer t) {
        for (var i = 0; i < 4; i++) {
          if (kutuPlayFlag[i].value) {
            progressValueAnt[i].value -= 1 / antSuresi;
            // we "finish" downloading here
            if (progressValueAnt[i] <= 0.0) {
              isInProgress[kutuNo].value = false;
              t.cancel();
              progressValueAnt[i].value = 1;
              //TODO Antrenman bittikten sonra play butonu başlangıc durumuna getirmek adına aşagıdaki
              //kodu düzenleyecegim
              kutuPlayFlag[i].value = false;
              return;
            }
          }
        }
      },
    );
  }

  void updateProgressCal(int calSuresi, int dinSuresi, int kutuNo) {
    const oneSec = const Duration(seconds: 1);

    new Timer.periodic(oneSec, (Timer t) {
      if (!kutuPlayFlag[kutuNo].value) {
        t.cancel();
        return;
      }
      progressValueCal[kutuNo].value -= 1 / calSuresi;
      // we "finish" downloading here
      if (progressValueCal[kutuNo].value <= 0.0) {
        //isLoading.value = false;

        progressValueDin[kutuNo].value = 1.0;
        //TODO Antrenman bittikten sonra play butonu başlangıc durumuna getirmek adına aşagıdaki
        //kodu düzenleyecegim
        //playFlag.value = false;
        if (isInProgress[kutuNo].value) {
          updateProgressDin(calSuresi, dinSuresi, kutuNo);
        }
        t.cancel();
        return;
      }
    });
  }

  void updateProgressDin(int calSuresi, int dinSuresi, int kutuNo) {
    const oneSec = const Duration(seconds: 1);
    //progressValueDin.value = 1.0;

    new Timer.periodic(oneSec, (Timer t) {
      if (!kutuPlayFlag[kutuNo].value) {
        t.cancel();
        return;
      }
      progressValueDin[kutuNo].value -= 1 / dinSuresi;
      // we "finish" downloading here
      if (progressValueDin[kutuNo].value <= 0.0) {
        //isLoading.value = false;

        progressValueCal[kutuNo].value = 1.0;
        //TODO Antrenman bittikten sonra play butonu başlangıc durumuna getirmek adına aşagıdaki
        //kodu düzenleyecegim
        //playFlag.value = false;
        if (isInProgress[kutuNo].value) {
          updateProgressCal(calSuresi, dinSuresi, kutuNo);
        }
        t.cancel();
        return;
      }
    });
  }

  read(String renk) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'my_' + renk + 'kutu_address';
    final value = prefs.getString(key) ?? "0";
    print('read: $value');
    return value;
  }
}
