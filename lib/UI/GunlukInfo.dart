import 'package:butcekontrol/constans/MaterialColor.dart';
import 'package:butcekontrol/modals/Spendinfo.dart';
import 'package:butcekontrol/utils/dbHelper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:butcekontrol/constans/TextPref.dart';

import '../utils/DateTimeManager.dart';

class GunlukInfo extends StatefulWidget {
  const GunlukInfo({super.key});


  @override
  State<StatefulWidget> createState() => _GunlukInfoState();
}

class _GunlukInfoState extends State<GunlukInfo> {
  //bool _isLoading = true;

/*
  void _refreshSpendinfoList() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshSpendinfoList();
  }

 */ // şuan kullanılmadığı için yorum satırı yaptım
  final ScrollController Scrollbarcontroller2 = ScrollController();
  var renkler = CustomColors();

  static String today = DateTimeManager.getCurrentDay();
  static Future<List<spendinfo>> myMethod() async {
    List<spendinfo> items = await SQLHelper.getItemsByOperationDay(today);
    return items;
  }

  Widget gelirGiderInfo(spendinfo item) {
    if (item.operationType == 'Gelir') {
      return Text(
        '${item.amount}',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: renkler.yesilRenk,
        ),
      );
    } else {
      return Text(
        '${item.amount}',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: renkler.kirmiziRenk,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd.MM.yyyy').format(now);
    var size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height / 3,
      child: Container(
          margin: const EdgeInsets.only(top: 4.5),
          child: Column(
            children: [
              Row(
                // günlük yarcama yazı ve tarih kısmı
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          color: renkler.koyuuRenk,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.only(
                              left: 15.0, right: 20, top: 5, bottom: 2),
                          child: Text(
                            "Bügünün Islem Bilgileri",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 25,
                      top: 4,
                    ),
                    child: Text(formattedDate,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w900)),
                  )
                ],
              ),
              Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 4.8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // tür bilgilendirme kısmı.(kategori, ödeme, miktar, saat)
                        children: [
                          Text(
                            'Kategori',
                            style: TextStyle(
                              fontSize: 16,
                              color: renkler.koyuuRenk,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 34),
                          Text(
                            'Ödeme',
                            style: TextStyle(
                              fontSize: 16,
                              color: renkler.koyuuRenk,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 34),
                          Text(
                            'Miktar',
                            style: TextStyle(
                              fontSize: 16,
                              color: renkler.koyuuRenk,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 48),
                          Text(
                            'Saat',
                            style: TextStyle(
                              fontSize: 16,
                              color: renkler.koyuuRenk,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder<List<spendinfo>>(
                      future: myMethod(),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<spendinfo>> snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return SizedBox(
                          height: 165,
                          child: Padding(
                            //borderin scroll ile birleşimi gözüksü diye soldan padding
                            padding: const EdgeInsets.only(
                                left: 5.0, top: 5, bottom: 10),
                            child: snapshot.data!.length == 0
                                ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/image/origami_noinfo.png",
                                    width: 50,
                                    height: 50,
                                  ),

                                  SizedBox(
                                    height: 25,
                                    width: 100,
                                    child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                                          border: Border.all(
                                              color: Colors.black, width: 2),
                                        ),
                                        child: const Center(child: Textmod(
                                            "Kayıt Yok", Colors.amber, 15))
                                    ),
                                  ),
                                ],
                              ),
                            )
                                : Theme(
                              data: Theme.of(context).copyWith(
                                  scrollbarTheme: ScrollbarThemeData(
                                    thumbColor:
                                    MaterialStateProperty.all(renkler.sariRenk),
                                  )),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 1.75),
                                    child: SizedBox(
                                      width: 4,
                                      height: size.height / 3.04,
                                      child: const DecoratedBox(
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(30)),
                                            color: Color(0xff0D1C26)),
                                      ),
                                    ),
                                  ),
                                  Scrollbar(
                                    controller: Scrollbarcontroller2,
                                    thumbVisibility: true,
                                    scrollbarOrientation:
                                    ScrollbarOrientation.left,
                                    interactive: true,
                                    thickness: 7,
                                    radius: const Radius.circular(15.0),
                                    child: ListView.builder(
                                        controller: Scrollbarcontroller2,
                                        itemCount: snapshot.data!.length,
                                        itemBuilder:
                                            (BuildContext context, index) {
                                          spendinfo item = snapshot.data![index];
                                          return Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15, right: 10),
                                                child: ClipRRect(  //Borderradius vermek için kullanıyoruz
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      10.0),
                                                  child: Container(
                                                    height: 26,
                                                    color: renkler.ArkaRenk,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      mainAxisSize: MainAxisSize.max,
                                                      children: [
                                                        SizedBox(
                                                          width: 100,
                                                          child: Text(
                                                              '${item.category}',textAlign: TextAlign.center),
                                                        ),
                                                        SizedBox(
                                                          width: 50,
                                                          child: Text(
                                                              '${item.operationTool}',textAlign: TextAlign.center),
                                                        ),
                                                        SizedBox(
                                                          width: 100,
                                                          child: gelirGiderInfo(item),
                                                        ),
                                                        SizedBox(
                                                          width: 60,
                                                          child: Padding(
                                                            padding: const EdgeInsets.only(right: 10),
                                                            child: Text(item.operationTime.toString(),textAlign: TextAlign.center),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                  height: 5
                                              ) // elemanlar arasına bşluk bırakmak için kulllandım.
                                            ],
                                          );
                                        }),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}