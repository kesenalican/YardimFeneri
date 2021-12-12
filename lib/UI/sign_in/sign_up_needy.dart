import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:yardimfeneri/common/alertinfo.dart';
import 'package:yardimfeneri/common/loginscreenindicator.dart';
import 'package:yardimfeneri/common/multilinetextfield.dart';
import 'package:yardimfeneri/common/myButton.dart';
import 'package:yardimfeneri/common/myinput.dart';
import 'package:yardimfeneri/data/cities.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:yardimfeneri/UI/helpful/ilsearch.dart';
import 'package:yardimfeneri/extensions/size_extension.dart';
import 'package:yardimfeneri/model/needy_model.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:yardimfeneri/routing/navigation/navigation_service.dart';
import 'package:yardimfeneri/routing/routeconstants.dart';
import 'package:yardimfeneri/service/needy_service.dart';


class SignUpNeedy extends StatefulWidget {
  final String? getButtonText;
  SignUpNeedy(
      {
        this.getButtonText,
      });
  @override
  _SignUpNeedyState createState() => _SignUpNeedyState();
}

class _SignUpNeedyState extends State<SignUpNeedy> {
  final TextEditingController? _emailcontroller = TextEditingController();
  final TextEditingController? _sifrecontroller = TextEditingController();
  final TextEditingController? _isimcontroller = TextEditingController();
  final TextEditingController? _soyisimcontroller = TextEditingController();
  final TextEditingController? _meslekcontroller = TextEditingController();
  final TextEditingController? _telefoncontroller = TextEditingController();
  final TextEditingController? _adrescontroller = TextEditingController();
  var controllertel = new MaskTextInputFormatter(mask: '### - ### - ## - ##');
  var controller = new MaskTextInputFormatter(mask: '000-000-00-00');
  String il = "İl Seçiniz";
  final _formKey1 = GlobalKey<FormState>();
  bool _loadingVisible = false;
  PickedFile? _image;
  var imageUrl;
  DateTime? _dateTime;
  final f = new DateFormat('yyyy-MM-dd');

  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return LoadingScreen(
      inAsyncCall: _loadingVisible,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Yardım Talep Eden Kayıt",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 26.0.spByWidth,color: Colors.black),),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        resizeToAvoidBottomInset: false,
        body: Container(
          child: ListView(
            children: [

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey1,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10.0.h,
                      ),

                      Myinput(hintText:"İsim" ,icon: Icon(Icons.person,color: Colors.green,),onSaved: validateEmail,controller: _isimcontroller!,keybordType: TextInputType.emailAddress,passwordVisible: false,validate: validateName,),
                      Myinput(hintText:"Soyisim" ,icon: Icon(Icons.person,color: Colors.green,),onSaved: validateEmail,controller: _soyisimcontroller!,keybordType: TextInputType.emailAddress,passwordVisible: false,validate: validateSurname,),
                      Padding(
                        padding:  EdgeInsets.all(16.0.w),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0.w),
                            boxShadow: <BoxShadow>[
                              BoxShadow(color: Colors.grey.withOpacity(0.8), offset: const Offset(4, 4), blurRadius: 8),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10.0.h),
                            child: SizedBox(
                              height: 55.0.h,
                              child: Padding(
                                padding:  EdgeInsets.only(top: 0, left: 20.0.w),
                                child: TextFormField(
                                  inputFormatters: [controllertel],
                                  controller: _telefoncontroller,
                                  validator: validateTelefon,
                                  autocorrect: false,
                                  keyboardType: TextInputType.number,
                                  style: const TextStyle(
                                    color: const Color(0xff343633),
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "OpenSans",
                                    fontStyle: FontStyle.normal,
                                    fontSize: 25.0,
                                  ),
                                  cursorColor: Colors.blue,
                                  decoration: InputDecoration(
                                    errorStyle: TextStyle(fontSize: 15),
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    border: InputBorder.none,
                                    // contentPadding:  const EdgeInsets.only(top: 40,left: 30),
                                    hintText: "5xx - xxx - xx - xx",
                                    hintStyle: TextStyle(
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Myinput(hintText:"E-mail" ,icon: Icon(Icons.email,color: Colors.green,),onSaved: validateEmail,controller: _emailcontroller!,keybordType: TextInputType.emailAddress,passwordVisible: false,validate: validateEmail,),
                      Myinput(hintText:"Şifre" ,icon: Icon(Icons.lock,color: Colors.green,),onSaved: validateSifre,controller: _sifrecontroller!,keybordType: TextInputType.emailAddress,passwordVisible: true,validate: validateSifre,),
                      Myinput(hintText:"Meslek" ,icon: Icon(Icons.work,color: Colors.green,),onSaved: validateSifre,controller: _meslekcontroller!,keybordType: TextInputType.emailAddress,passwordVisible: false),
                      InkWell(
                        onTap: () {
                          var result = showSearch<String>(
                              context: context, delegate: CitySearch(cities));
                          result.then((value) => setState(()=>il=value ?? "İl Seçiniz"));
                        },
                        child: Padding(
                          padding:  EdgeInsets.all(16.0.w),
                          child: Container(

                            height: 55.0.h,
                            padding:  EdgeInsets.only(left:8.0.w),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(40.0.w),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.8),
                                    offset: const Offset(4, 4),
                                    blurRadius: 8),
                              ],
                            ),
                            child: Text(il,style: TextStyle(color: Colors.black,fontSize: 15.0.spByWidth),),
                          ),
                        ),
                      ),
                      MultilineTextField(hintText:"Adres" ,icon: Icon(Icons.home_filled,color: Colors.green,),satir:4,onSaved: validateEmail,controller: _adrescontroller!,keybordType: TextInputType.emailAddress,passwordVisible: false,validate: validateAdres,),
                      InkWell(
                        onTap: () {
                          showCupertinoDatePicker(context);
                        },
                        child: Column(
                          children: [
                            Padding(
                              padding:  EdgeInsets.only(left: 20.0.w),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child:  Text(
                                    "Doğum Tarihi" ,
                                    //_dateTime,
                                    style: TextStyle(
                                        color: const Color(0xd9343633),
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "OpenSans",
                                        fontStyle: FontStyle.normal,
                                        fontSize: 15.0.spByWidth),
                                    textAlign: TextAlign.left),
                              ),
                            ),
                            SizedBox(height: 8.0.h,),
                            Padding(
                              padding:  EdgeInsets.all(16.0.w),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(40.0.w),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: Colors.grey.withOpacity(0.8),
                                        offset: const Offset(4, 4),
                                        blurRadius: 8),
                                  ],
                                ),
                                height: 55.0.h,
                                child: DropdownButtonFormField(
                                  items: [],
                                  hint: Text( _dateTime == null ? "Doğum Tarihinizi Seçiniz" : formatTheDate(_dateTime!, format: DateFormat("dd.MM.y")),),
                                  decoration:InputDecoration(
                                    helperText: "   ",
                                    icon: Padding(
                                      padding:  EdgeInsets.only(top: 13.0.h,left: 10.0.w),
                                      child: Icon(Icons.date_range,color: Colors.green,),
                                    ),
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    border: InputBorder.none,
                                    contentPadding:  const EdgeInsets.only(),
                                    errorStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                                  ),

                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                      SizedBox(height: 10.0.h,),

                      Center(
                        child: MyButton(text: "Kayıt", fontSize: 18.0.spByWidth,butonColor: Colors.green,width: 300.0.w,height: 50.0.h,
                          onPressed: (){
                            _validateInputsRegister(context);
                          }, textColor: Colors.white,),
                      ),
                      SizedBox(height: 30.0.h,),
                      SizedBox(
                        height: 25.0.h,
                      ),
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                            text: 'Hesabınız var mı?',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: '  Giriş Yapın.',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ]),
                      ),
                      SizedBox(
                        height: 30.0.h,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? validateEmail(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value!))
      return 'Email Geçersiz';
    else
      return null;
  }

  String? validateSifre(String? value) {
    if (value!.length<6)
      return 'Şifre Geçersiz';
    else
      return null;
  }

  String? validateName(String? value) {
    if (value!.length < 3)
      return 'İsminiz en az 3 karakter olmalıdır.';
    else
      return null;
  }

  String? validateSurname(String? value) {
    if (value!.length < 3)
      return 'Soyisminiz en az 3 karakter olmalıdır.';
    else
      return null;
  }

  String? validateAdres(String? value) {
    if (value!.length < 6)
      return 'Adres en az 5 karakter olmalıdır.';
    else
      return null;
  }
  String? validateFaaliyet(String? value) {
    if (value!.length < 6)
      return 'Faaliyet Alanı en az 3 karakter olmalıdır.';
    else
      return null;
  }
  String? validateTelefon(String? value) {
    if (value!.length < 11)
      return 'Lütfen Geçerli bir telefon numarası giriniz';
    else
      return null;
  }
  Future<void> _changeLoadingVisible() async {
    setState(() {
      _loadingVisible = !_loadingVisible;
    });
  }

  Future<dynamic> showCupertinoDatePicker(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
              height: MediaQuery.of(context).copyWith().size.height / 3,
              child: CupertinoDatePicker(
                onDateTimeChanged: (DateTime newdate) {
                  setState(() {
                    _dateTime = newdate;
                  });
                },
                maximumYear: DateTime.now().year,
                initialDateTime: DateTime.now(),
                mode: CupertinoDatePickerMode.date,
              ));
        });
  }

  void _validateInputsRegister(BuildContext context) async {
    if (_formKey1.currentState!.validate()) {
      if(il=="İl Seçiniz")
      {
        var dialogBilgi = AlertBilgilendirme(
          icerik: "Lütfen il seçiniz.",
          Pressed: () {
            Navigator.pop(context);
          },
        );
        showDialog(
            context: context,
            builder: (BuildContext context) => dialogBilgi);
      }else if(_dateTime==null)
      {
        var dialogBilgi = AlertBilgilendirme(
          icerik: "Lütfen doğum tarihi seçiniz.",
          Pressed: () {
            Navigator.pop(context);
          },
        );
        showDialog(
            context: context,
            builder: (BuildContext context) => dialogBilgi);
      }else {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
        await _changeLoadingVisible();
        final _userModel = Provider.of<NeedyService>(context, listen: false);
        NeedyModel needyModel =
        new NeedyModel(userId: "userid",
            email: _emailcontroller!.text,
            password: _sifrecontroller!.text,
            isim: _isimcontroller!.text,
            soyisim: _soyisimcontroller!.text,
            meslek: _meslekcontroller!.text,
            il: il,
            adres: _adrescontroller!.text,
            dogumTarihi: _dateTime!,
            telefon: _telefoncontroller!.text,
            hesaponay: false);
        NeedyModel? createuser = await _userModel
            .createUserWithEmailandPasswordNeedy(
            _emailcontroller!.text, _sifrecontroller!.text, needyModel);
        if (createuser != null) {
          NavigationService.instance.navigateToReset(
              RouteConstants.LANDINGPAGE);
        }
      }
    }
  }





  String formatTheDate(DateTime selectedDate, {DateFormat? format}) {
    final DateTime now = selectedDate;
    final DateFormat formatter = format ?? DateFormat('dd.MM.y', "tr_TR");
    final String formatted = formatter.format(now);
    initializeDateFormatting("tr_TR");
    return formatted;
  }

  Future<String> uploadDuyuruImage(String id) async {
    if(_image == null)
      return "";
    String filePath = _image!.path;
    String userId = "_modelYonetici.user.userId";
    String fileName = "${userId}-${id}}.jpg";
    File file = File(filePath);
    try {
      await firebase_storage.FirebaseStorage.instance.ref('duyuru/$fileName').putFile(file);
      String downloadURL =
      await firebase_storage.FirebaseStorage.instance.ref('duyuru/$fileName').getDownloadURL();
      return downloadURL;
    } on FirebaseException catch (e) {
      return "error";
    }
  }

}
