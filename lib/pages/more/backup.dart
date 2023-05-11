import 'package:butcekontrol/constans/material_color.dart';
import 'package:butcekontrol/utils/cvs_converter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../classes/app_bar_for_page.dart';
import '../../classes/nav_bar.dart';
import '../../riverpod_management.dart';

class BackUp extends ConsumerStatefulWidget {
  const BackUp({Key? key}) : super(key: key);

  @override
  ConsumerState<BackUp> createState() => _BackUpState();
}

class _BackUpState extends ConsumerState<BackUp> {
  @override
  Widget build(BuildContext context) {
    var readSetting = ref.read(settingsRiverpod);
    CustomColors renkler = CustomColors();

    //bool isExpandGDrive = false ;
    //bool isExpandExcel = false ;
    bool isExpandCvs = false ;
    bool isopen = readSetting.isBackUp == 1 ? true : false ; // databaseden alınacak
    var size = MediaQuery.of(context).size;
    return Container(
      color: renkler.koyuuRenk,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xffF2F2F2),
          bottomNavigationBar: const NavBar(),
          appBar: const AppBarForPage(title: "YEDEKLE"),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal:18, vertical: 8 ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: Container(
                      height: 40,
                      width: size.width,
                      color: renkler.arkaRenk,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          children: [
                            const Text(
                              "Yedeklenme Durumu",
                              style: TextStyle(
                                fontFamily: "Nexa3",
                              ),
                            ),
                          const Spacer(),
                          isopen ? const Text("Açık", style: TextStyle(fontFamily: "Nexa3"),)
                              : const Text("Kapalı", style: TextStyle(fontFamily: "Nexa3"),),
                          Switch(
                            value: isopen ,
                            onChanged: (bool value) {
                              setState(() {
                                readSetting.setBackup(value);
                                readSetting.setisuseinsert();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ), /// Giriş şifresi
              /// Yedeklenme durumunu kontrol etmemiz gerekiyor.
              if (!isopen) const SizedBox() else Column(
                children: [
                  /*
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right:  15.0, bottom: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Container(
                        color : Color(0xffD9D9D9),
                        child: ExpansionTile(
                            onExpansionChanged: (bool expanding) => setState(() => isExpandGDrive = expanding),
                            title: Text("Google Drive ile Yedekle"),
                          children: [
                            Divider(thickness: 2.0,color: renkler.sariRenk),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Google Drive ile ilişkilendir"
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        final directory = await getExternalStorageDirectory() ;
                                        print(directory?.path);
                                      },
                                      child: FittedBox( ///Google Drive Oturumvarlığını sorgulayalım.
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: Color(0xff2A2895),
                                          ),
                                          child: const Center(
                                            child: Padding(
                                              padding: EdgeInsets.all(8),
                                              child: Text(
                                                  "Oturum Aç",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  fontFamily: "Nexa3"
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right:  15.0, bottom: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Container(
                        color:  Color(0xffD9D9D9),
                        child: ExpansionTile(
                          title: Text("Excel Dosyası olarak indir(.xlsx)"),
                          onExpansionChanged: (bool expanding) => setState(() => isExpandExcel = expanding),
                          children: [
                            Divider(thickness: 2.0,color: renkler.sariRenk),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: const [
                                      Text(
                                        "Yedeklenme Sıklığı"
                                      )
                                    ],
                                  ),
                                  Row(),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),

                   */
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right:  15.0, bottom: 8.0),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: Container(
                        color:  renkler.arkaRenk,
                        child: ExpansionTile(
                          title: const Text("CVS formatında indir (.cvs)"),
                          onExpansionChanged: (bool expanding) => setState(() => isExpandCvs = expanding),
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Column(
                                children: [
                                  Divider(thickness: 2.0,color: renkler.sariRenk),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const SizedBox(
                                            width: 1,)
                                          ,
                                          const Text(
                                            "Yedeklenme Sıklığı",
                                            style:TextStyle(
                                              fontFamily: "Nexa4",
                                              fontSize: 15  ,
                                            ),
                                          ),
                                          toolCustomButton(context),
                                          const SizedBox(
                                            width: 1,)
                                          ,
                                        ],
                                      ),
                                      const SizedBox(height: 10 ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              restore();
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(
                                                    backgroundColor:
                                                    Color(0xff0D1C26),
                                                    duration: Duration(seconds: 1),
                                                    content: Text(
                                                      'Verileriniz Çekildi',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontFamily: 'Nexa3',
                                                        fontWeight: FontWeight.w600,
                                                        height: 1.3,
                                                      ),
                                                    ),
                                                  ),
                                              );
                                            },
                                            child: FittedBox(
                                              child: DecoratedBox(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: renkler.koyuuRenk,
                                                ),
                                                child: const Center(
                                                  child: Padding(
                                                    padding: EdgeInsets.all(8),
                                                    child: Text(
                                                      "Geri Yükle",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15,
                                                          fontFamily: "Nexa3"
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              readSetting.Backup(); //CVS KAYDINI YAPIORUZ ve son kayıt date günceli oluyor
                                              setState(() {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(
                                                      backgroundColor: Color(0xFF0D1C26),
                                                      duration: Duration(seconds: 1),
                                                      content: Text(
                                                        'Downlodand/Klasörünün altına indirildi!',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                          fontFamily: 'Nexa3',
                                                          fontWeight: FontWeight.w600,
                                                          height: 1.3,
                                                        ),
                                                      ),
                                                    )
                                                );
                                              });
                                            },
                                            child: FittedBox(
                                              child: DecoratedBox(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: renkler.koyuuRenk,
                                                ),
                                                child: const Center(
                                                  child: Padding(
                                                    padding: EdgeInsets.all(8),
                                                    child: Text(
                                                      "Yedekle",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15,
                                                          fontFamily: "Nexa3"
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      )
    );
  }
  double heightTool_ = 26;
  double heightTool2_ = 32;
  double heightTool3_ = 26;
  Color _containerColorTool3 = const Color(0xff0D1C26);
  Color _containerColorTool2 = const Color(0xff0D1C26);
  Color _containerColorTool = const Color(0xffF2CB05);
  Color _textColorTool = const Color(0xff0D1C26);
  Color _textColorTool2 = Colors.white;
  Color _textColorTool3 = Colors.white;
  Widget toolCustomButton(BuildContext context) {
    var readSetting = ref.read(settingsRiverpod);
    if(readSetting.Backuptimes == "Günlük"){
      setState(() {
        heightTool2_ = 32;
        heightTool_ = 26;
        heightTool3_ = 26;
        _containerColorTool = const Color(0xffF2CB05);
        _containerColorTool2 = const Color(0xff0D1C26);
        _containerColorTool3 = const Color(0xff0D1C26);
        _textColorTool = const Color(0xff0D1C26);
        _textColorTool2 = Colors.white;
        _textColorTool3 = Colors.white;
      });
    }else if(readSetting.Backuptimes == "Aylık"){
      setState(() {
        heightTool_ = 32;
        heightTool2_ = 26;
        heightTool3_ = 26;
        _containerColorTool2 = const Color(0xffF2CB05);
        _containerColorTool = const Color(0xff0D1C26);
        _containerColorTool3 = const Color(0xff0D1C26);
        _textColorTool = Colors.white;
        _textColorTool2 = const Color(0xff0D1C26);
        _textColorTool3 = Colors.white;
      });
    }else{
      setState(() {
        heightTool_ = 26;
        heightTool2_ = 26;
        heightTool3_ = 32;
        _containerColorTool3 = const Color(0xffF2CB05);
        _containerColorTool = const Color(0xff0D1C26);
        _containerColorTool2 = const Color(0xff0D1C26);
        _textColorTool = Colors.white;
        _textColorTool2 = Colors.white;
        _textColorTool3 = const Color(0xff0D1C26);
      });
    }
    return SizedBox(
      height: 32,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(40)),
                color: Color(0xff0D1C26),
              ),
              height: 34,
              width: 180,
            ),
          ),
          Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 1200),
                curve: Curves.fastLinearToSlowEaseIn,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                  color: _containerColorTool,
                ),
                height: heightTool2_,
                child: SizedBox(
                  width: 60,
                  child: TextButton(
                      onPressed: () {
                        setState(() {
                          //_operationTool.text = "Nakit";
                          readSetting.setBackuptimes("Günlük");
                        });
                      },
                      child: Text("Günlük",
                          style: TextStyle(
                              color: _textColorTool,
                              fontSize: 13,
                              fontFamily: 'Nexa3',
                              fontWeight: FontWeight.w800))),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 1200),
                curve: Curves.fastLinearToSlowEaseIn,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                  color: _containerColorTool2,
                ),
                height: heightTool_,
                child: SizedBox(
                  width: 66,
                  child: TextButton(
                      onPressed: () {
                        setState(() {
                          readSetting.setBackuptimes("Aylık");
                        });
                      },
                      child: Text("Aylık",
                          style: TextStyle(
                              color: _textColorTool2,
                              fontSize: 13,
                              fontFamily: 'Nexa3',
                              fontWeight: FontWeight.w800))),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 1200),
                curve: Curves.fastLinearToSlowEaseIn,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(25)),
                  color: _containerColorTool3,
                ),
                height: heightTool3_,
                child: SizedBox(
                  width: 44,
                  child: TextButton(
                      onPressed: () {
                        setState(() {
                          readSetting.setBackuptimes("Yıllık");
                        });
                      },
                      child: Text("Yıllık",
                          style: TextStyle(
                              color: _textColorTool3,
                              fontSize: 13,
                              fontFamily: 'Nexa3',
                              fontWeight: FontWeight.w800))),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


