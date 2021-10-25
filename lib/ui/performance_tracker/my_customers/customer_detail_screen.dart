import 'package:flutter/material.dart';
import 'package:vendor/main.dart';
import 'package:vendor/model/get_customer_product_response.dart';
import 'package:vendor/model/get_my_customer_response.dart';
import 'package:vendor/ui/custom_widget/app_bar.dart';
import 'package:vendor/utility/color.dart';
import 'package:vendor/utility/network.dart';
import 'package:vendor/utility/sharedpref.dart';
import 'package:vendor/utility/utility.dart';

class CustomerDetailScreen extends StatefulWidget {
  final Customer customer;

  const CustomerDetailScreen({required this.customer, Key? key}) : super(key: key);

  @override
  _CustomerDetailScreenState createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  double totalPay = 0.0;
  double redeemedCoin = 0.0;
  double earnCoin = 0.0;
  double total = 0.0;
  String s = "";
  String htmlText =
      "<h1> <strong> गोपनीयता नीति </strong> </h1> <p> अंतिम अपडेट: मार्च 13, 2021 </p> <p> जब आप सेवा का उपयोग करते हैं तो आपकी जानकारी एकत्र करने, उपयोग करने और प्रकट करने के लिए यह गोपनीयता नीति हमारी नीतियों और प्रक्रियाओं का वर्णन करती है और आपको आपके गोपनीयता अधिकारों के बारे में बताती है और कानून आपकी सुरक्षा कैसे करता है। </p><p> हम सेवा प्रदान करने और उसे बेहतर बनाने के लिए आपकी व्यक्तिगत जानकारी का उपयोग करते हैं। सेवा का उपयोग करके, आप इस गोपनीयता नीति के अनुसार डेटा के संग्रह और उपयोग के लिए सहमति देते हैं। </p> <h1> <strong> व्याख्या और परिभाषाएं </strong> </h1> <h2> <strong> व्याख्या </strong> </h2> "
      "<p> बड़े अक्षर वाले शब्दों के अर्थ निम्नलिखित शर्तों के तहत परिभाषित होते हैं। निम्नलिखित परिभाषाओं का एक ही अर्थ होगा चाहे वे एकवचन में हों या बहुवचन में। </p>"
      "<h2> <strong> परिभाषाएं </strong> </h2> <p> इस गोपनीयता नीति के प्रयोजनों के लिए: </p>"
      "<ul> <li> <strong> खाता </strong> का अर्थ है हमारी सेवा या हमारी सेवा के कुछ हिस्सों तक पहुंचने के लिए आपके लिए बनाया गया एक अनूठा खाता। </li>"
      "<li> <strong> एसोसिएटेड </strong> कंपनी का मतलब एक ऐसी इकाई से है जो किसी पार्टी के साथ नियंत्रण, नियंत्रण या संयुक्त नियंत्रण में है, जहां नियंत्रण का मतलब 50% या अधिक शेयरों, इक्विटी या अन्य मतदान प्रतिभूतियों के निदेशक या अन्य शासी निकाय का स्वामित्व है। . </li>"
      "<li> <strong> एप्लिकेशन </strong> का अर्थ कंपनी द्वारा प्रदान किया गया सॉफ़्टवेयर है जिसे आपने मुद्रा से मुद्रा परिवर्तक ऐप नामक किसी भी इलेक्ट्रॉनिक उपकरण पर डाउनलोड किया है। विकी </li>"
      " <li><strong>Društvo </strong>(u daljnjem tekstu bilo Društvo, mi, nas ili naš u ovom Sporazumu) se odnosi na Currency.Wiki , 122 15TH ST # 431 Del Mar, CA 92014. </li> "
      "<li><strong>Država se </strong>odnosi na: Kalifornija, Sjedinjene Države </li>"
      " <li><strong>Uređaj </strong>znači bilo koji uređaj koji može pristupiti Usluzi, poput računala, mobitela ili digitalnog tableta. </li> "
      "<li><strong>Osobni podaci </strong>su bilo koji podaci koji se odnose na identificiranu ili utvrdivu osobu. </li> "
      "<li><strong>Usluga se </strong>odnosi na Zahtjev. </li> <li><strong>Pružatelj usluge </strong>znači bilo koju fizičku ili pravnu osobu koja obrađuje podatke u ime Tvrtke. Odnosi se na treće strane ili pojedince zaposlene u tvrtki radi olakšavanja usluge, pružanja usluge u ime tvrtke, obavljanja usluga povezanih sa uslugom ili pružanja pomoći tvrtki u analizi načina na koji se usluga koristi. </li> "
      "<li><strong>Usluga društvenih medija treće strane </strong>odnosi se na bilo koju web stranicu ili bilo koju web stranicu društvene mreže putem koje se Korisnik može prijaviti ili stvoriti račun za korištenje Usluge. </li>"
      " <li><strong>Podaci o upotrebi </strong>odnose se na podatke prikupljene automatski, generirane korištenjem Usluge ili iz same infrastrukture Usluge (na primjer, trajanje posjeta stranici). </li> "
      "<li><strong>Ti </strong>znači pojedinačni pristupa ili korištenja usluge, ili tvrtku ili drugu pravnu osobu u ime kojih kao pojedinac pristupa ili koristi usluge, kao što je primjenjivo. </li> </ul> "
      "<h1><strong>Prikupljanje i korištenje vaših osobnih podataka</strong></h1> "
      "<h2><strong>Vrste prikupljenih podataka</strong></h2> <h3><strong>Osobni podaci</strong></h3>"
      " <p>Tijekom korištenja Naše usluge možemo zatražiti da nam pružite određene podatke koji mogu identificirati osobe pomoću kojih vas možemo kontaktirati ili identificirati. Podaci koji mogu osobno identificirati mogu uključivati, ali nisu ograničeni na:</p>"
      " <ul> <li>Email adresa</li> <li>Podaci o upotrebi</li> </ul> <h3><strong>Podaci o upotrebi</strong></h3> "
      "<p>Podaci o upotrebi prikupljaju se automatski prilikom korištenja Usluge.</p>"
      " <p>Podaci o upotrebi mogu sadržavati podatke poput adrese internetskog protokola vašeg uređaja (npr. IP adresa), vrstu preglednika, verziju preglednika, stranice naše usluge koju posjetite, vrijeme i datum vašeg posjeta, vrijeme provedeno na tim stranicama, jedinstveni uređaj identifikatore i druge dijagnostičke podatke.</p> "
      "<p>Kada Usluzi pristupite putem mobilnog uređaja ili putem njega, možemo automatski prikupiti određene podatke, uključujući, ali ne ograničavajući se na vrstu mobilnog uređaja koji koristite, jedinstveni ID vašeg mobilnog uređaja, IP adresu vašeg mobilnog uređaja, vaš mobilni uređaj operativni sustav, vrsta mobilnog internetskog preglednika koji upotrebljavate, jedinstveni identifikatori uređaja i drugi dijagnostički podaci.</p>"
      " <p>Također možemo prikupljati podatke koje vaš preglednik šalje kad god posjetite našu uslugu ili kada joj pristupite putem mobilnog uređaja.</p>"
      " <h2><strong>Korištenje vaših osobnih podataka</strong></h2> "
      "<p>Tvrtka može koristiti Osobne podatke u sljedeće svrhe:</p>"
      " <ul> <li><strong>Pružanje i održavanje naše Usluge </strong>, uključujući praćenje korištenja naše Usluge.</li> "
      "<li><strong>Za upravljanje Vašim računom: </strong>za upravljanje Vašom registracijom kao korisnika Usluge. Osobni podaci koje pružate mogu vam omogućiti pristup različitim funkcionalnostima Usluge koje su vam dostupne kao registrirani korisnik. </li> "
      "<li><strong>Za izvršenje ugovora: </strong>razvoj, usklađenost i poduzimanje ugovora o kupnji proizvoda, predmeta ili usluga koje ste kupili ili bilo kojeg drugog ugovora s nama putem Usluge. </li>"
      " <li><strong>Da vas kontaktiram: </strong>da vas kontaktiram e-poštom, telefonskim pozivima, SMS-om ili drugim ekvivalentnim oblicima elektroničke komunikacije, kao što su push obavijesti mobilne aplikacije u vezi s ažuriranjima ili informativne komunikacije povezane s funkcionalnostima, proizvodima ili ugovorenim uslugama, uključujući sigurnosna ažuriranja, kada je to potrebno ili razumno za njihovu provedbu. </li> "
      "<li><strong>Da bismo vam pružili </strong>vijesti, posebne ponude i opće informacije o drugoj robi, uslugama i događajima koje nudimo slične onima koje ste već kupili ili ste se raspitali o njima, osim ako niste odlučili da nećete primati takve informacije. </li> "
      "<li><strong>Za upravljanje Vašim zahtjevima: </strong>Prisustvovati i upravljati Vašim zahtjevima za nas. </li>"
      " <li><strong>Za poslovne transfere: </strong>Vaše podatke možemo koristiti za procjenu ili provođenje spajanja, otuđenja, restrukturiranja, reorganizacije, raspuštanja ili druge prodaje ili prijenosa neke ili cijele naše imovine, bilo kao trajno poslovanje ili kao dio bankrota, likvidacije, ili sličan postupak, u kojem su Osobni podaci koje posjedujemo o korisnicima naših usluga među prenesenom imovinom. </li> "
      "<li><strong>U druge svrhe </strong>: Vaše podatke možemo koristiti u druge svrhe, kao što su analiza podataka, identificiranje trendova korištenja, određivanje učinkovitosti naših promotivnih kampanja te za procjenu i poboljšanje naše Usluge, proizvoda, usluga, marketinga i vašeg iskustva.</li> </ul>";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Details",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.grey.shade200, width: 1)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text(
                        widget.customer.customerName,
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                      )),
                      Text(
                        Utility.getFormatDate1(widget.customer.date),
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "+91 ${widget.customer.mobile}",
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            FutureBuilder<List<CustomerProduct>>(
                future: getCustomerProduct(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }
                  if (snapshot.hasData) {
                    return Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.grey.shade200, width: 1)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "All items",
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Column(
                            children: List.generate(
                                snapshot.data!.length,
                                (index) => Stack(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          margin: EdgeInsets.symmetric(vertical: 10),
                                          decoration:
                                              BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.grey.shade100),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Image(
                                                image: NetworkImage(snapshot.data![index].productImages.isNotEmpty
                                                    ? snapshot.data![index].productImages.first.productImage
                                                    : "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTDIC2m4o5Ff_s_BOIL0-y7uq8m_Kqrn0Yq1Q&usqp=CAU"),
                                                height: 70,
                                                width: 70,
                                                fit: BoxFit.contain,
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                child: Container(
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisSize: MainAxisSize.max,
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                            "${snapshot.data![index].productName}",
                                                            style: TextStyle(
                                                                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                                                          ),
                                                          Text(
                                                            "${snapshot.data![index].total}",
                                                            style: TextStyle(color: Colors.black, fontSize: 14),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(
                                                            "${snapshot.data![index].qty} x ${snapshot.data![index].price}",
                                                            style: TextStyle(
                                                                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Image(
                                                                image: AssetImage("assets/images/point.png"),
                                                                width: 15,
                                                                height: 15,
                                                              ),
                                                              Text(
                                                                "${snapshot.data![index].earningCoins}",
                                                                style: TextStyle(color: Colors.black, fontSize: 14),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        snapshot.data![index].redeemCoins.isEmpty || snapshot.data![index].redeemCoins == "0"
                                            ? Container()
                                            : Positioned(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: ColorPrimary.withOpacity(0.2),
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: Text(
                                                    "\tRedeemed\t",
                                                    style: TextStyle(color: ColorPrimary),
                                                  ),
                                                ),
                                                top: 0,
                                                right: 15,
                                              )
                                      ],
                                    )),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total Amount",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text("₹ ${total.toStringAsFixed(2)}"),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Redeemed Amount",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text("₹ ${redeemedCoin.toStringAsFixed(2)}"),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Earn Coins",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image(
                                    image: AssetImage("assets/images/point.png"),
                                    width: 15,
                                    height: 15,
                                  ),
                                  Text("${earnCoin.toStringAsFixed(2)}"),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Pay Amount",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text("₹ ${totalPay.toStringAsFixed(2)}"),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                  return Container();
                }),
            // Html(
            //   data: htmlText,
            //   style: {
            //     "div": Style(
            //       color: Colors.yellow,
            //       fontSize: FontSize(16),
            //     ),
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  Future<List<CustomerProduct>> getCustomerProduct() async {
    if (await Network.isConnected()) {
      Map<String, dynamic> input = {
        "customer_id": widget.customer.customerId,
        "vendor_id": await SharedPref.getIntegerPreference(SharedPref.VENDORID)
      };

      GetCustomerProductResponse response = await apiProvider.getCustomerProduct(input);
      if (response.success) {
        response.data!.forEach((product) {
          totalPay += double.parse(product.total);
          total += double.parse(product.price);
          redeemedCoin += double.parse(product.redeemCoins);
          earnCoin += double.parse(product.earningCoins);
        });

        return response.data!;
      } else {
        return [];
      }
    } else {
      return [];
    }
  }
}
