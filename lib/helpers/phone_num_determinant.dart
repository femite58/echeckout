class PhoneNumDeterminant {
  static bool isMatch(String num, String network) {
    Map networks = {
      'mtn': [
        '0803',
        '0806',
        '0703',
        '0706',
        '0813',
        '0816',
        '0810',
        '0814',
        '0903',
        '0906',
        '0913',
        '0916',
        '07025',
        '07026',
        '0704'
      ],
      'glo': ['0805', '0807', '0705', '0815', '0811', '0905', '0915'],
      'airtel': [
        '0802',
        '0808',
        '0708',
        '0812',
        '0701',
        '0902',
        '0901',
        '0904',
        '0907',
        '0912'
      ],
      '9mobile': ['0809', '0818', '0817', '0909', '0908'],
      'etisalat': ['0809', '0818', '0817', '0909', '0908'],
    };
    num = num.replaceAll(' ', '');
    for (String pref in networks[network]) {
      if (RegExp(r'^(\+234|0)'+pref.substring(1)).hasMatch(num)) {
        return true;
      }
    }
    return false;
  }
}
