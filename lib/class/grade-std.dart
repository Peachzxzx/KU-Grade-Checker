import 'package:beautifulsoup/beautifulsoup.dart';
import 'package:ku_auto_grade_check/client.dart';

class GradeStd {
  static String _username;
  static String _password;
  static Session client = new Session();

  void setUsername(String a) => _username = a;
  void setPassword(String a) => _password = a;

  Future<bool> login(String captcha) async {
    String url = 'https://grade-std.ku.ac.th/GSTU_login_.php';
    try {
      Session.headers['User-Agent'] =
          "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:83.0) Gecko/20100101 Firefox/83.0";
      Session.headers['Host'] = 'grade-std.ku.ac.th';
      Session.headers['Origin'] = 'https://grade-std.ku.ac.th';
      Session.headers['Referer'] = 'https://grade-std.ku.ac.th/GSTU_login_.php';
      await client.post(url, {
        'UserName': _username,
        'Password': _password,
        'zone': '0',
        'captcha': captcha
      });
      Session.headers.remove('Host');
      Session.headers.remove('Origin');
      Session.headers.remove('Referer');
      if (await chkLogout()) {
        return false;
      }
    } finally {}
    return true;
  }

  Future logout() async => await client.post(
          "https://grade-std.ku.ac.th/GSTU_login_.php",
          {'mode': 'LOGOUT'}).then((response) {
        if (response.statusCode != 302) {/*error*/} else {}
      });

  Future<Map> gradeOf(int yearS, int yearSem) async =>
      await client.post("https://grade-std.ku.ac.th/GSTU_course_.php", {
        'YearS': yearS.toString(),
        'YearSem': yearSem.toString(),
        'UserName': _username,
        'Password': '',
        'Campus': '',
        'Requery': 'Y'
      }).then((response) {
        print(response.body);
        Beautifulsoup soup = new Beautifulsoup(response.body);
        var sub_Grade = soup.find_all('dd');
        int num_Sub_Grade = sub_Grade.length;
        Map data = {};
        for (var i = 0; i < num_Sub_Grade; i += 2) {
          data[sub_Grade[i].text] = sub_Grade[i + 1].text;
        }
        print(data);
        return data;
      });

  static Future<bool> chkLogout() async => await client
      .get('https://grade-std.ku.ac.th/GSTU_course_.php')
      .then((response) => response.body == '''!!!! Wrong Code Entered !!!!''');
}
