import 'package:butcekontrol/classes/app_bar_for_page.dart';
import 'package:butcekontrol/constans/text_pref.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constans/material_color.dart';
import '../../riverpod_management.dart';

class PasswordPage extends ConsumerStatefulWidget {
  const PasswordPage({Key? key}) : super(key: key);

  @override
  ConsumerState<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends ConsumerState<PasswordPage> {
  bool status = false;
  bool num1 = false;
  bool num2 = false;
  bool num3 = false;
  bool num4 = false;
  List <String> password1list = [];
  List <String> password2list = [];
  String password1 = "" ;
  String password2 = "" ;
  String info = "Yeni şifre kodunu giriniz";
  String errormessage = "";
  bool security = false ;
  @override
  Widget build(BuildContext context) {
    var readSetting = ref.read(settingsRiverpod);
    CustomColors renkler = CustomColors();
    var size = MediaQuery.of(context).size;
    TextEditingController setanimalController = TextEditingController();
    bool isopen = readSetting.isPassword == 1  ? true : false ;
    return WillPopScope(
      onWillPop: () async{
      if(readSetting.isPassword == 1 && readSetting.Password == "null") {
        bool confirm = await showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                backgroundColor: renkler.koyuuRenk,
                title: Row(
                  children: [
                    Icon(
                        Icons.warning_amber,
                      color: renkler.sariRenk,
                       size: 35,
                    ),
                    const SizedBox(width: 20),
                    const TextMod("Uyarı", Colors.white, 18),
                  ],
                ),
                content:  const TextMod("Herhangi bir şifre belirlemediniz.\nŞifre Koymaktan vaz mı geçiyorsunuz?", Colors.white, 15),
                actions: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20) ,
                    child: Container(
                      height: 30,
                      width: 80,
                      color: renkler.sariRenk,
                      margin: const EdgeInsets.all(5),
                      child:  InkWell(
                        onTap: () => Navigator.pop(context, false),
                          child: SizedBox(
                              child: Center(
                                  child: TextMod("Geri Dön", renkler.koyuuRenk, 16)
                              )
                          )
                      ) ,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20) ,
                    child: Container(
                      height: 30,
                      width: 80,
                      color: renkler.sariRenk,
                      margin: const EdgeInsets.all(5),
                      child:  InkWell(
                          onTap: () {
                            Navigator.pop(context, true);
                            readSetting.setPasswordMode(false);
                            readSetting.setisuseinsert();
                          },
                          child: SizedBox(
                              child: Center(
                                  child: TextMod("Vazgeç", renkler.koyuuRenk, 16)
                              )
                          )
                      ) ,
                    ),
                  ),

                ],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
        );
        // Onaylandıysa sayfadan çık
        if (confirm == true)  {
          Navigator.pop(context);
        }
      }else{
        Navigator.pop(context, true);
        }
      return false;
      },
      child: Container(
        color: renkler.koyuuRenk,
        child: SafeArea(
          child: Scaffold(
            appBar: const AppBarForPage(title: "GİRİŞ ŞİFRESİ"),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: Column(
                children: [
                    SizedBox(height: size.height/80),
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
                                  "Giriş Şifresi Durumu",
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
                                      readSetting.setPasswordMode(value);
                                      readSetting.setisuseinsert();
                                      if(!value){
                                        readSetting.setPassword("null");
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  !isopen
                    ? SizedBox(height: 1)
                    : readSetting.securityQu == "null"
                      ?Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              "En sevdiğiniz hayvan nedir ?",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontFamily: "Nexa4"
                              ),
                            ),
                            SizedBox(height: 20),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 40,
                                width: 150,
                                color: renkler.koyuuRenk,
                                child: TextField(
                                  controller: setanimalController,
                                  keyboardType: TextInputType.text,
                                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"))],
                                  style: const TextStyle(fontSize: 18, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            InkWell(
                              onTap: () {
                                if (setanimalController.text != "" ) {
                                  setState(() {
                                    readSetting.setSecurityQu(setanimalController.text);
                                  });
                                }else if(setanimalController.text == ""){
                                  setState(() {
                                    errormessage = "Lütfen Bir değer giriniz." ;
                                  });
                                }
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  color: renkler.sariRenk,
                                  child: const Center(
                                    child: Icon(
                                      Icons.check_circle_outline,
                                      color: Colors.black,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              errormessage,
                              style: TextStyle(
                                color: renkler.koyuuRenk,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        )
                      :Column(
                        mainAxisAlignment:  MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(height: size.height/20) ,
                          Text(
                            info,
                            style: TextStyle(
                              color: renkler.koyuuRenk,
                              fontFamily: "Nexa4"
                            ),
                          ),
                          SizedBox(height: size.height/30) ,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 25,
                                width: 25,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                                  child: Container(
                                    color: num1 ? Colors.black : const Color(0xffE2E1E1),
                                  ),
                                )
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                                    child: Container(
                                      color: num2 ? Colors.black : const Color(0xffE2E1E1),
                                    ),
                                  )
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                                    child: Container(
                                      color: num3 ? Colors.black : const Color(0xffE2E1E1),
                                    ),
                                  )
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                                    child: Container(
                                      color: num4 ? Colors.black : const Color(0xffE2E1E1),
                                    ),
                                  )
                              ),
                              const SizedBox(width: 10),
                              IconButton(
                                  icon : const Icon(Icons.backspace),
                                onPressed: () {
                                  if(security){
                                    if(num1){
                                      password2list.removeLast();
                                    }
                                    if(num3){
                                      setState(() {
                                        num3 = false;
                                      });
                                    }else if(num2){
                                      setState(() {
                                        num2 = false;
                                      });
                                    }else if(num1){
                                      setState(() {
                                        num1 = false ;
                                      });
                                    }
                                  }else{
                                    if(num1){
                                      password1list.removeLast();
                                    }
                                    if(num3){
                                      setState(() {
                                        num3 = false;
                                      });
                                    }else if(num2){
                                      setState(() {
                                        num2 = false;
                                      });
                                    }else if(num1){
                                      setState(() {
                                        num1 = false ;
                                      });
                                    }
                                  }
                                },
                              )
                            ],
                          ),
                          SizedBox(height: size.height/30) ,
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    button(context, "1"),
                                    button(context, "2"),
                                    button(context, "3"),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    button(context, "4"),
                                    button(context, "5"),
                                    button(context, "6"),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    button(context, "7"),
                                    button(context, "8"),
                                    button(context, "9"),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    button(context, "0"),
                                  ],
                                )
                              ],
                            ),
                          )//
                        ],
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  void temizle(){
    setState(() {
      num1 = false;
      num2 = false;
      num3 = false;
      num4 = false;
    });
  }
  Widget button(BuildContext context,String num ){
    var size = MediaQuery.of(context).size;
    CustomColors renkler = CustomColors();
    return SizedBox(
        height: size.height / 9.5,
        width: size.height / 9.5,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          child: Container(
            color: const Color(0xffE2E1E1),
            child: Center(
              child: SizedBox(
                height: size.height / 12,
                width:  size.height / 12,
                child: InkWell(
                  onTap: () {
                      if (num1 == false) {
                      if(security){
                        password2list.add(num);
                      }else{
                         password1list.add(num);
                      }
                      setState(() {
                        num1 = true ;
                      });
                    }else if(num2 == false){
                      if(security){
                        password2list.add(num);
                      }else{
                        password1list.add(num);
                      }
                      setState(() {
                        num2 = true;
                      });
                    }else if(num3  == false){
                      if(security){
                        password2list.add(num);
                      }else{
                        password1list.add(num);
                      }
                      setState(() {
                        num3 = true;
                      });
                    }else if(num4 == false){
                      if(security){
                        setState(() {
                          security = false ;
                          password1 = "" ;
                          password2 = "" ;
                        });
                        password2list.add(num);
                        if(password2list.length == 4) {
                          for (var i = 0; i < password1list.length ; i++) {
                            password1 = password1 + password1list[i];
                          }
                          for (var i = 0; i < password2list.length ; i++) {
                            password2 = password2 + password2list[i];
                          }
                          if (password1 == password2) {
                            setState(() {
                              info = "şifreniz ayarlandı" ;
                              password1list.clear();
                              password2list.clear();
                              status = true ;
                              ref.read(settingsRiverpod).setPasswordMode(true);
                              ref.read(settingsRiverpod).setPassword(password1);
                              //ref.read(settingsRiverpod).setisuseinsert();
                              Navigator.of(context).pop();
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor:
                                Color(0xff0D1C26),
                                duration: Duration(seconds: 1),
                                content: Text(
                                  'Şifreniz Oluşturuldu.',
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
                            temizle();
                          } else {
                            temizle();
                            password1list.clear();
                            password2list.clear();
                            setState(() {
                              info = "Şifreler Uyuşmuyor." ;
                              status = false;
                            });
                          }
                        }
                      }else{
                        password1list.add(num);
                        setState(() {
                          security = true;
                          num4 = true ;
                          info = "Tekrar gininiz." ;
                        });
                          Future.delayed(const Duration(milliseconds: 150)).then((value) => temizle());
                      }
                    }
                  },
                  child: Center(
                    child: Text(
                      num,
                      style: TextStyle(
                        color: renkler.koyuuRenk,
                        fontSize: 25,
                        fontFamily: "Nexa2"
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
    );
  }
}
