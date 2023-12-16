import 'package:butcekontrol/UI/change_currency_page.dart';
import 'package:butcekontrol/classes/app_bar_for_page.dart';
import 'package:butcekontrol/classes/nav_bar.dart';
import 'package:butcekontrol/constans/text_pref.dart';
import 'package:butcekontrol/models/spend_info.dart';
import 'package:butcekontrol/riverpod_management.dart';
import 'package:butcekontrol/utils/db_helper.dart';
import 'package:butcekontrol/utils/textConverter.dart';
import 'package:d_chart/d_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../UI/add_assets.dart';
import '../../UI/history_asset.dart';
import '../../classes/language.dart';
import '../../constans/material_color.dart';
import '../../models/Data.dart';

class assetsPage extends ConsumerStatefulWidget {
  const assetsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<assetsPage> createState() => _assetsPage();
}

class _assetsPage extends ConsumerState<assetsPage> {
  var icsclick = true;
  PageController _pageViewController = PageController();
  @override
  void dispose() {
    // TODO: implement dispose
    _pageViewController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    List<double> getMeasure(double kart, double  nakit, double  diger){
      var totalorigin =  kart + nakit + diger ;
      if(kart <= 0){
        kart = 0;
      }
      if(nakit <= 0){
        nakit = 0;
      }
      if(diger <= 0){
        diger = 0 ;
      }
      var total = kart + nakit + diger ;
      if(total == 0){
        total = 1.0;
      }
      var kardMeasure = 100 * kart / total ;
      var nakitMeasure = 100 * nakit / total ;
      var digerMeasure = 100 * diger / total ;
      List<double> listem = [double.tryParse(kardMeasure.toStringAsFixed(1))!, double.tryParse(nakitMeasure.toStringAsFixed(2))!, double.tryParse(digerMeasure.toStringAsFixed(1))!, double.tryParse(totalorigin.toStringAsFixed(1))!];

      return listem;
    }
    var dbRiv = ref.watch(databaseRiverpod);
    var readSettingsRiv = ref.read(settingsRiverpod);
    ref.watch(settingsRiverpod).isuseinsert;
    var size = MediaQuery.of(context).size;
    var renkler = CustomColors();
    var time = DateTime.now().hour;
    User? user = FirebaseAuth.instance.currentUser;
    Future<List<SpendInfo>> Total =  SQLHelper.getItems();
    return SafeArea(
        bottom: false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBarForPage(title: translation(context).myAssets),
          bottomNavigationBar: const NavBar(),
          body: FutureBuilder(
            future: Total,
            builder:
            (context, snapshot) {
              if(snapshot.hasData){
                var myData = snapshot.data; //bütün kaytları içerir.
                List<double> measureList = getMeasure(double.tryParse(dbRiv.getTotalAmountByKart(myData!))!, double.tryParse(dbRiv.getTotalAmountByNakit(myData!))!, double.tryParse(dbRiv.getTotalAmountByDiger(myData!))!);
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * .029,vertical: 8),
                  child: SizedBox(
                    height: size.height ,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: size.height * .053,
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).indicatorColor,
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: Row(
                            children: [
                              Center(
                                child: Image.asset(
                                  time > 5 && time < 12
                                      ? "assets/icons/good-Morning.png"
                                      : time >= 12 && time < 18
                                      ? "assets/icons/good-tag.png"
                                      : time >= 18 && time <= 23
                                      ? "assets/icons/day-and-night.png"
                                      : "assets/icons/good-night.png",
                                  height: 30,
                                ),
                              ),
                              SizedBox(width: size.width * .02),
                              Text(
                                time > 5 && time < 12
                                ? translation(context).goodMorning
                                : time >= 12 && time < 18
                                  ? translation(context).goodDay
                                  : time >= 18 && time <= 23
                                    ? translation(context).goodEvening
                                    : translation(context).goodNight,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  height: 1
                                ),
                              ),
                            ],
                          ),
                        ), ///Karşılama
                        SizedBox(height: size.height *.01),
                        SizedBox(
                          height: 115,
                          child: Container(
                            child: Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      stops: [0.5, 1],
                                      end: Alignment.bottomCenter,
                                        ///Color(0xFF5AAA85)
                                      colors: [Theme.of(context).hintColor.withOpacity(0.7) ,Theme.of(context).scaffoldBackgroundColor ],
                                    ),
                                    boxShadow: readSettingsRiv.DarkMode == 1 ? [
                                      BoxShadow(
                                        color: Colors.black54.withOpacity(0.8),
                                        spreadRadius: 1,
                                        blurRadius: 2,
                                        offset: const Offset(-1, 2),
                                      )
                                    ] : [
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          spreadRadius: 0.5,
                                          blurRadius: 2,
                                          offset: const Offset(0, 2)
                                      )
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextMod(translation(context).total,Theme.of(context).unselectedWidgetColor, 16),
                                      SizedBox(height: 5),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "${measureList[3]}" ,style: TextStyle(
                                                fontFamily: 'NEXA3' ,
                                                fontSize: 25,
                                                color: Theme.of(context).unselectedWidgetColor
                                            ),
                                            ),
                                            TextSpan(
                                              text: readSettingsRiv.prefixSymbol,
                                              style: TextStyle(
                                                  fontFamily: 'TL',
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  color: Theme.of(context).unselectedWidgetColor
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(" + 200 TL"),
                                    ],
                                  ),
                                ),
                                CustomPaint(
                                  size: size,
                                  painter: shadowBanner(
                                    color: Colors.white.withOpacity(0.2),
                                    mod : 1,
                                  ),
                                ),
                                CustomPaint(
                                  size: size,
                                  painter: shadowBanner(
                                    color: Colors.white.withOpacity(0.4),
                                    mod : 2,
                                  ),
                                ),
                                CustomPaint(
                                  size: size,
                                  painter: shadowBanner(
                                    color: Colors.white.withOpacity(0.55),
                                    mod : 3,
                                  ),
                                ),
                                CustomPaint(
                                  size: size,
                                  painter: shadowBanner(
                                    color: Colors.white.withOpacity(0.2),
                                    mod : 4,
                                  ),
                                ),
                                CustomPaint(
                                  size: size,
                                  painter: shadowBanner(
                                    color: Colors.white.withOpacity(0.4),
                                    mod : 5,
                                  ),
                                ),
                                CustomPaint(
                                  size: size,
                                  painter: shadowBanner(
                                    color: Colors.white.withOpacity(0.55),
                                    mod : 6,
                                  ),
                                ),
                                Positioned(
                                  right: 10,
                                  top : 10,
                                  child: SizedBox(
                                    height: size.width * .22,
                                    width: size.width * .22,
                                    child: measureList[3] <= 0
                                    ? Padding( // DATA YOK MESAJI
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).indicatorColor.withOpacity(0.7),
                                            shape: BoxShape.circle,
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 1,
                                                offset: Offset(0, 1),
                                                spreadRadius: 1,
                                              )
                                            ],
                                          ),
                                          child: Center(
                                              child: Text(
                                                translation(context).noAssetFound,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Theme.of(context).unselectedWidgetColor
                                                ),
                                              )
                                          ),
                                        ),
                                      )
                                    :Stack(
                                      children: [
                                        DChartPie(
                                          strokeWidth: 1,
                                          showLabelLine: false,
                                          animationDuration: const Duration(milliseconds: 500),
                                          labelPosition: PieLabelPosition.outside,
                                          labelColor:  Colors.transparent,
                                          data: [
                                            {'domain': translation(context).bank, 'measure': measureList[0]},
                                            {'domain': translation(context).cashAsset, 'measure': measureList[1]},
                                            {'domain': translation(context).other, 'measure': measureList[2]},
                                          ],
                                          fillColor: (pieData, index) {
                                            return colorsList[index!];
                                          },
                                          donutWidth: 6,
                                        ),
                                        Positioned(
                                          left: size.width * .088,
                                          top: size.width * .08,
                                          child: Text(
                                            readSettingsRiv.prefixSymbol.toString(),
                                            style: TextStyle(
                                                fontFamily: 'TL',
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                                color: Theme.of(context).unselectedWidgetColor
                                            ),
                                          ),
                                        ),
                                      ]
                                    ),
                                  ),
                                ),
                              ]
                            ),
                          ),
                        ),///pasta satırı
                        SizedBox(height: size.height *.01),
                        Container(
                          height : size.height * .1,
                          padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color : Theme.of(context).indicatorColor
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  assetBox(context, ref, translation(context).cardAsset, dbRiv.getTotalAmountByKart(myData)),
                                  assetBox(context, ref, translation(context).cashAsset, dbRiv.getTotalAmountByNakit(myData)),
                                  assetBox(context, ref, translation(context).other, dbRiv.getTotalAmountByDiger(myData)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          opaque: false, //sayfa saydam olması için
                                          transitionDuration: const Duration(milliseconds: 1),
                                          pageBuilder: (context, animation, nextanim) => const addAssets(),
                                          reverseTransitionDuration: const Duration(milliseconds: 1),
                                          transitionsBuilder: (context, animation, nexttanim, child) {
                                            return FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: size.width * .4,
                                      height: size.height * .031,
                                      padding: EdgeInsets.symmetric(vertical: size.height * .007, horizontal: size.width *.02),
                                      decoration: BoxDecoration(
                                          gradient: readSettingsRiv.DarkMode == 1 ? LinearGradient(
                                            colors: [Theme.of(context).secondaryHeaderColor, Theme.of(context).shadowColor],
                                          ) : null ,
                                          color : readSettingsRiv.DarkMode == 1 ? null : Theme.of(context).highlightColor,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: Theme.of(context).canvasColor.withOpacity(0.5),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Theme.of(context).indicatorColor,
                                                blurRadius: 3,
                                                spreadRadius: 1
                                            )
                                          ]
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            translation(context).addRemoveAsset,
                                            style: const TextStyle(
                                                color: Color(0xFFE9E9E9),
                                                fontSize: 13,
                                                height: 1
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          opaque: false, //sayfa saydam olması için
                                          transitionDuration: const Duration(milliseconds: 1),
                                          pageBuilder: (context, animation, nextanim) => const HistoryAsset(),
                                          reverseTransitionDuration: const Duration(milliseconds: 1),
                                          transitionsBuilder: (context, animation, nexttanim, child) {
                                            return FadeTransition(
                                              opacity: animation,
                                              child: child,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: size.width * .5,
                                      height: size.height * .031,
                                      padding: EdgeInsets.symmetric(vertical: size.height * .007, horizontal: size.width *.02),
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).highlightColor,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: Theme.of(context).canvasColor.withOpacity(0.5),
                                          ),
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 3,
                                                spreadRadius: 1
                                            )
                                          ]
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            translation(context).past,
                                            style: const TextStyle(
                                                color: Color(0xFFE9E9E9),
                                                fontSize: 13,
                                                height: 1
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          const Icon(
                                            Icons.history,
                                            size: 16,
                                            color: Color(0xFFE9E9E9),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),///butonlar ve assetBox lar
                        SizedBox(height: size.height *.01),
                        Container(
                          height : size.height * .15,
                          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).indicatorColor
                          ),
                          child: Column(
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Aylık Varlık Değişimi"),
                                  Text("* --"),

                                ],
                              ),
                              SizedBox(
                                height: size.height * .11,
                                child: PageView(
                                  controller: _pageViewController,
                                  physics: const BouncingScrollPhysics(
                                    decelerationRate: ScrollDecelerationRate.fast
                                  ),
                                  children: [
                                    pageFirst(ref, measureList[3]),
                                    FutureBuilder(
                                      future: SQLHelper.SQLEntry('SELECT * FROM spendinfo WHERE operationType == "Gelir"'),
                                      builder: (context, snapshot) {
                                        if(snapshot.hasData){
                                          List<SpendInfo>? data = snapshot.data;
                                          return ListView.builder(
                                            itemCount: data!.length > 2 ? 2 : data.length,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                height: size.height * .045,
                                                width: double.infinity,
                                                margin: EdgeInsets.symmetric(horizontal: size.width * .001, vertical: size.height * .006),
                                                padding: EdgeInsets.symmetric(horizontal: size.width * .01),
                                                decoration: BoxDecoration(
                                                  color:Theme.of(context).indicatorColor,
                                                  borderRadius: BorderRadius.circular(7),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Theme.of(context).secondaryHeaderColor,
                                                        blurRadius: 2
                                                    ),
                                                  ]
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      flex :1,
                                                      child: Text(
                                                        data[index].operationDate.toString(),
                                                        style: const TextStyle(
                                                          height: 1,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex :2,
                                                      child: Center(
                                                        child: Text(
                                                          data[index].note.toString(),
                                                          style: const TextStyle(
                                                            height: 1,
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex :1,
                                                      child: Align(
                                                        alignment: Alignment.centerRight,
                                                        child: RichText(
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                            text: TextSpan(children: [
                                                              TextSpan(
                                                                text:  data[index].realAmount.toString(),
                                                                style: TextStyle(
                                                                  fontSize: 15,
                                                                  fontFamily: 'Nexa3',
                                                                  color: Theme.of(context).secondaryHeaderColor
                                                                ),
                                                              ),
                                                              TextSpan(
                                                                text: readSettingsRiv.prefixSymbol,
                                                                style: TextStyle(
                                                                  height: 1,
                                                                  fontFamily: 'TL',
                                                                  fontSize: 16,
                                                                  fontWeight: FontWeight.w600,
                                                                  color : Theme.of(context).secondaryHeaderColor
                                                                ),
                                                              ),
                                                            ]
                                                          )
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        }else{
                                          return Text("Yükleniyor.");
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),///pageView
                        SizedBox(height: size.height *.01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             Text(
                                translation(context).myCurrencies,
                              style: TextStyle(
                                fontSize: 17,
                                fontFamily: "Nexa3",
                                height: 1,
                                color: Theme.of(context).canvasColor,

                              ),
                            ),
                            SizedBox(
                              width: size.width * double.parse(translation(context).myCurrenciesSize),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Container(
                                  color: Theme.of(context).highlightColor,
                                  height: 3,
                                  width: double.infinity,
                                  child: const VerticalDivider(
                                    thickness: 1,
                                    width: 0,
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                 icsclick = !icsclick;
                               });
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).shadowColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Transform.rotate(
                                  angle: 3.14 / 2,
                                  child: const Icon(Icons.swap_horiz),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: size.width * .07,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Container(
                                  color: Theme.of(context).highlightColor,
                                  height: 3,
                                  width: double.infinity,
                                  child: const VerticalDivider(
                                    thickness: 1,
                                    width: 0,
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),///divider satırı
                        SizedBox(height: size.height *.01),
                        Expanded(
                          child: FutureBuilder(
                            future: SQLHelper.getItemsByCurrency(readSettingsRiv.Prefix!),
                            builder: (context, snapshot) {
                              List ?data ;
                              if(snapshot.hasData){
                                switch(icsclick){
                                  case true:
                                    data = List.from(snapshot.data!);
                                    data.sort((a, b) {
                                      DateTime dateA = convertDate(a.operationDate);
                                      DateTime dateB = convertDate(b.operationDate);
                                      return dateB.compareTo(dateA);
                                    });
                                    break;
                                  case false:
                                    data = List.from(snapshot.data!);
                                    data.sort((a, b) {
                                      DateTime dateA = convertDate(a.operationDate);
                                      DateTime dateB = convertDate(b.operationDate);
                                      return dateA.compareTo(dateB);
                                    });
                                    break;
                                  default:
                                }
                                return data!.length == 0
                                ? SizedBox(
                                  height: 150,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/image/noInfo5.png",
                                        width: 75,
                                        height: 75,
                                        //color: Theme.of(context).canvasColor,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        height: 20,
                                        width: 140,
                                        child: DecoratedBox(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: Theme.of(context).canvasColor,
                                            ),
                                            child: Center(child: TextMod(
                                                translation(context).currencyNotFound, Theme.of(context).primaryColor, 14))
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                :GridView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: size.width * .06,
                                      mainAxisSpacing: size.height * .005,
                                      childAspectRatio: 3
                                  ),
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            opaque: false, //sayfa saydam olması için
                                            transitionDuration: const Duration(milliseconds: 1),
                                            pageBuilder: (context, animation, nextanim) => changeCurrencyPage(data![index]),
                                            reverseTransitionDuration: const Duration(milliseconds: 1),
                                            transitionsBuilder: (context, animation, nexttanim, child) {
                                              return FadeTransition(
                                                opacity: animation,
                                                child: child,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(horizontal: size.width *.02, vertical: size.height * .013),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          color: Theme.of(context).indicatorColor,
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 6,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        Converter().textConverterFromDB(data![index].operationTool!, context, 2),
                                                        style: TextStyle(
                                                          height: 1,
                                                          color: Theme.of(context).canvasColor,
                                                        ),
                                                      ),
                                                      Text(
                                                          data[index].operationDay.toString()  == "null" ? translation(context).asset : data[index].operationDate.toString() ,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          height: 1,
                                                            color: Theme.of(context).canvasColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                      "${data[index].amount.toStringAsFixed(2)} ${data[index].moneyType.toString().substring(0,3)}",style: TextStyle(
                                                    height: 1,
                                                    color: Theme.of(context).canvasColor,
                                                  ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Expanded(
                                              flex: 1,
                                              child: Icon(Icons.swap_horiz_rounded)
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }else{
                                return Center(
                                    child: CircularProgressIndicator(
                                      color: Theme.of(context).disabledColor,
                                  )
                                );
                              }
                            },
                          ),
                        ),///Dövizlerim
                      ],
                    ),
                  ),
                );
              }else{
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).disabledColor,
                  )
                );
              }
            },
          ),
        )
    );
  }
  List<Color> colorsList = [
    const Color(0xFFB7ACF9),
    const Color(0xFFF9D1AC),
    const Color(0xFFF9ACAC),
  ];


  Widget assetBox(BuildContext context,WidgetRef ref, String title, String amaount ) {
    var size = MediaQuery.of(context).size;
    var readSettings = ref.read(settingsRiverpod);
    var renkkler = CustomColors();
    IconData ?myIcon ;
    Color? myColor ;
    if(title == translation(context).cardAsset) {
      myIcon = Icons.credit_card;
      myColor = colorsList[0];
    }else if(title == translation(context).cashAsset){
      myIcon = Icons.wallet;
      myColor = colorsList[1];
    }else{
      myIcon = Icons.animation_outlined;
      myColor = colorsList[2];
    }
    return Container(
      height: size.height * .052,
      width: size.width * .295,
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color : renkkler.arkaRenk.withOpacity(0.3)
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 1,
            spreadRadius: 1,
            offset: Offset(0, 1),
          )
        ],
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: readSettings.DarkMode == 1 ? [0.0,0.4] : [0.0,1.0],
          colors: [myColor.withOpacity(0.5) ,Theme.of(context).scaffoldBackgroundColor ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              title == translation(context).cardAsset
              ? Image.asset(
                "assets/icons/bank.png",
                height:  21,
                color: Theme.of(context).canvasColor,
                alignment: Alignment.centerLeft,
              ) : title == translation(context).cashAsset
                ? Image.asset(
                  "assets/icons/cash.png",
                  height: 22,
                color: Theme.of(context).canvasColor,
                  alignment: Alignment.centerLeft,
                )
                : Icon(
                  myIcon,
                  color: Theme.of(context).canvasColor,
                  size: 22,
                ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  height: 1,
                  color: Theme.of(context).canvasColor,
                ),
              ),
            ],
          ),
          Expanded(
            child: RichText(
              textAlign: TextAlign.end,
              maxLines: 1,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "$amaount" ,style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontFamily: 'NEXA3',
                      fontSize: 13,
                      height: 1,
                      color: Theme.of(context).canvasColor
                    ),
                  ),
                  TextSpan(
                    text: readSettings.prefixSymbol,
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontFamily: 'TL',
                        fontSize: 14,
                        height: 1,
                        color: Theme.of(context).canvasColor
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  DateTime convertDate(String Date) {
    // Date format: "dd.MM.yyyy
    if(Date == "null"){
      Date = "00.00.0000";
    }
    List<String> dateSplit = Date.split(".");
    int day = int.parse(dateSplit[0]);
    int month = int.parse(dateSplit[1]);
    int year = int.parse(dateSplit[2]);
    return DateTime(year, month, day);
  }
  Future<void> calculateAssetPerDAy() async{

  }
  Widget pageFirst(WidgetRef ref,double FirstTotalAsset) {
    return FutureBuilder(
      future: ref.read(databaseRiverpod).monthlyAssetChange(ref, FirstTotalAsset),
      builder:(context, snapshot) {
        if(snapshot.hasData){
         var item = snapshot.data;
          return SizedBox(
            height: 70,
            child: SfCartesianChart(
              borderColor: Colors.transparent,
              borderWidth: 0,
              plotAreaBorderWidth: 0,
              primaryXAxis: CategoryAxis(
                labelRotation: 45,
                isVisible: false,
                majorGridLines: const MajorGridLines(width: 0), // Ana grid çizgilerini gizler
                minorGridLines: const MinorGridLines(width: 0), // Alt grid çizgilerini gizler
                axisLine: const AxisLine(
                  color: Colors.transparent,
                ),
              ),
              primaryYAxis: NumericAxis(
                minorGridLines: const MinorGridLines(width: 0),
                isVisible: false, // Y ekseni görünmez yapılıyor
              ),
              series: <ChartSeries>[
                SplineAreaSeries<Data, String>(
                  dataSource:  getDataSet("aylık", item!),
                  xValueMapper:(Data data, _) => data.x,
                  yValueMapper: (Data data, _) => data.y,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).hintColor.withOpacity(0.7) ,
                      Theme.of(context).primaryColor
                    ],
                  ),
                  dataLabelSettings: const DataLabelSettings(
                      isVisible: false,
                      angle: 45,
                      alignment: ChartAlignment.far,
                      offset: Offset(0, 0),
                      labelAlignment: ChartDataLabelAlignment.middle
                  ),
                ),
              ],
            ),
          );
        }else{
          return Text("Yünkleniyor.");
        }
      },
    );
  }
  int foundMaxdayinMoth (){ //ayın kaç gün olduğunu buluyor.
    DateTime now = DateTime.now();
    DateTime firstDayOfNextMonth = DateTime(now.year, now.month + 1, 1);
    DateTime lastDayOfMonth = firstDayOfNextMonth.subtract(Duration(days: 1));
    return lastDayOfMonth.day;
  }
  List<Data> getDataSet(String mod, List<double> items){
    List<Data> dataSetList = [];
    Map<String, double> takvim  = {};
    for(int i = 0 ; i < items.length ; i++){
      dataSetList.add(Data(i.toString(), items[i]));
    }
    return dataSetList;
  }

}

class shadowBanner extends CustomPainter{
  final int mod;
  final Color color ;
  const shadowBanner({
    required this.color,
    required this.mod
  });
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint

    Paint paint = Paint()
      ..color = color
      ..isAntiAlias = true
      ..style = PaintingStyle.fill ;

    Path myPath = Path();

    Offset startPoint;
    Offset topRight;
    Offset bottomRight;
    Offset bottomLeft;

    switch(mod){
      case 1:
        startPoint = Offset(size.width * 0.25, 0);
        topRight = Offset(size.width * 0.28, 0);
        bottomRight = Offset(size.width * .13 , size.height);
        bottomLeft =  Offset(size.width * .1, size.height);
        break;
      case 2:
        startPoint = Offset(size.width * 0.28, 0);
        topRight = Offset(size.width * 0.31, 0);
        bottomRight = Offset(size.width * .16 , size.height);
        bottomLeft =  Offset(size.width * .13, size.height);
        break;
      case 3:
        startPoint = Offset(size.width * 0.31, 0);
        topRight = Offset(size.width * 0.34, 0);
        bottomRight = Offset(size.width * .19 , size.height);
        bottomLeft =  Offset(size.width * .16, size.height);
        break;
      case 4:
        startPoint = Offset(size.width * 0.75, 0);
        topRight = Offset(size.width * 0.78, 0);
        bottomRight = Offset(size.width * .63 , size.height);
        bottomLeft =  Offset(size.width * .6, size.height);
        break;
      case 5:
        startPoint = Offset(size.width * 0.78, 0);
        topRight = Offset(size.width * 0.81, 0);
        bottomRight = Offset(size.width * .66 , size.height);
        bottomLeft =  Offset(size.width * .63, size.height);
        break;
      case 6:
        startPoint = Offset(size.width * 0.81, 0);
        topRight = Offset(size.width * 0.84, 0);
        bottomRight = Offset(size.width * .69 , size.height);
        bottomLeft =  Offset(size.width * .66, size.height);
        break;
      default :
        startPoint = Offset(size.width * 0.75, 0);
        topRight = Offset(size.width * 0.78, 0);
        bottomRight = Offset(size.width * .18 , size.height);
        bottomLeft =  Offset(size.width * .15, size.height);
        break;
    }


    myPath.moveTo(startPoint.dx, startPoint.dy);
    myPath.lineTo(topRight.dx, topRight.dy);
    myPath.lineTo(bottomRight.dx, bottomRight.dy);
    myPath.lineTo(bottomLeft.dx, bottomLeft.dy);
    myPath.lineTo(startPoint.dx, startPoint.dy);

    canvas.drawPath(myPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

}
/*
class FezaiGridView extends StatelessWidget {
  final int itemCount;
  final int columnCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  const FezaiGridView({required this.itemCount, required this.itemBuilder, this.columnCount : 2});

  Widget build(BuildContext context, index) {
    List<Widget> Row= [];
    int a = itemCount; //kayıt sayısı
    int row = 0; // kaç row gelir.
    int column = 3; // sutün sayısı
    for(int row = 0; row < (a / column).toInt() ; row ++){

    }
    while (row < (a / column).toInt()) {
      //Row.add(itemBuilder(context, index));
      row++;
    }
    //stdout.write("* " * (a % column));

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

        ],
      ),
    );
  }

}

 */
