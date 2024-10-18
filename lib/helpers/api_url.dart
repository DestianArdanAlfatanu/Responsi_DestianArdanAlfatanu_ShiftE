class ApiUrl {
  static const String baseUrl = 'http://responsi.webwizards.my.id/api';
  static const String registrasi = baseUrl + '/registrasi';
  static const String login = baseUrl + '/login';
  static const String listStress = baseUrl + '/kesehatan/manajemen_stres';
  static const String createStress = baseUrl + '/kesehatan/manajemen_stres';
  static String updateStress(int id) {
    return baseUrl + '/kesehatan/manajemen_stres/' + id.toString() + '/update';
  }

  static String showStress(int id) {
    return baseUrl + '/kesehatan/manajemen_stres/' + id.toString();
  }

  static String deleteStress(int id) {
    return baseUrl + '/kesehatan/manajemen_stres/' + id.toString() + '/delete';
  }
}
