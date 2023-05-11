import 'package:butcekontrol/constans/material_color.dart';
import 'package:butcekontrol/riverpod_management.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../constans/text_pref.dart';
import '../models/spend_info.dart';

class GunlukInfo extends ConsumerStatefulWidget {
  const GunlukInfo({super.key});
  @override
  ConsumerState<GunlukInfo> createState() => _GunlukInfoState();
}

class _GunlukInfoState extends ConsumerState<GunlukInfo> {
  final ScrollController scroolBarController2 = ScrollController();
  var renkler = CustomColors();

  Widget gelirGiderInfo(SpendInfo item) {
    if (item.operationType == 'Gelir') {
      return Text(
        '${item.amount}',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          fontFamily:'Nexa3',
          color: renkler.yesilRenk,
        ),
      );
    } else {
      return Text(
        '${item.amount}',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
          fontFamily:'Nexa3',
          color: renkler.kirmiziRenk,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(databaseRiverpod, (previous, next) {
      return ref.watch(databaseRiverpod);
    });
    var readDB = ref.read(databaseRiverpod);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd.MM.yyyy').format(now);
    var size = MediaQuery.of(context).size;
    CustomColors renkler = CustomColors();
    return Center(
      child: SizedBox(
        height: 230,
        child: Container(
            //margin: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                topRight: Radius.circular(10)),
                            color: renkler.koyuuRenk,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.only(
                                left: 15.0, right: 20, top: 6, bottom: 3),
                            child: Text(
                              "Bugünün İşlem Bilgileri",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Nexa3',
                                fontSize: 18,
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
                      child: Text(formattedDate,
                          style: const TextStyle(
                              fontSize: 18,
                              fontFamily: 'Nexa4',
                              fontWeight: FontWeight.w900)),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Center(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            width: 20,
                          ),
                          SizedBox(
                            width: 100,
                            child: Center(
                              child: Text(
                                'Kategori',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: renkler.koyuuRenk,
                                  fontFamily: 'Nexa3',
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 60,
                            child: Center(
                              child: Text(
                                'Ödeme',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Nexa3',
                                  color: renkler.koyuuRenk,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: Center(
                              child: Text(
                                'Miktar',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Nexa3',
                                  color: renkler.koyuuRenk,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 60,
                            child: Center(
                              child: Text(
                                'Saat',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Nexa3',
                                  color: renkler.koyuuRenk,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                        ],
                      ),
                      FutureBuilder<List<SpendInfo>>(
                        future: readDB.myDailyMethod(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<SpendInfo>> snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return snapshot.data!.length == 0 ? Center(
                            child: SizedBox(
                              height: 160,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/image/origami_noinfo.png",
                                    width: 50,
                                    height: 50,
                                  ),
                                  SizedBox(
                                    height: 30,
                                    width: 110,
                                    child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(20),bottomRight: Radius.circular(20)),
                                          border: Border.all(
                                              color: Colors.black, width: 2),
                                        ),
                                        child: const Center(child: TextMod(
                                            "Kayıt Yok", Colors.amber, 18))
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ) :SizedBox(
                            height: 170,
                            child: Padding(
                              //borderin scroll ile birleşimi gözüksü diye soldan padding
                              padding: const EdgeInsets.only(
                                  left: 5.0, top: 5),
                              child: Theme(
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
                                        height: 170,
                                        child:  DecoratedBox(
                                          decoration: BoxDecoration(
                                              borderRadius: const BorderRadius.all(Radius.circular(30)),
                                              color: snapshot.data!.length <= 4 ? renkler.arkaRenk : const Color(0xFF0D1C26)),
                                        ),
                                      ),
                                    ),
                                    Scrollbar(
                                      controller: scroolBarController2,
                                      thumbVisibility: true,
                                      scrollbarOrientation:
                                      ScrollbarOrientation.left,
                                      interactive: true,
                                      thickness: 7,
                                      radius: const Radius.circular(15.0),
                                      child: ListView.builder(
                                          controller: scroolBarController2,
                                          itemCount: snapshot.data!.length,
                                          itemBuilder:
                                              (BuildContext context, index) {
                                            SpendInfo item =
                                            snapshot.data![index];
                                            return Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 15, right: 10),
                                                  child: ClipRRect(
                                                    //Borderradius vermek için kullanıyoruz
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        10.0),
                                                    child: Container(
                                                      height: 28,
                                                      color: renkler.arkaRenk,
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
                                                              child: Text(item
                                                                  .operationTime
                                                                  .toString(),textAlign: TextAlign.center),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                    height:
                                                    6) // elemanlar arasına bşluk bırakmak için kulllandım.
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
      ),
    );
  }
}