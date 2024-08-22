import 'package:intl/intl.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as html_dom;

class AppFormat {
  static String date(String stringDate) {
    if (stringDate.isNotEmpty) {
      DateTime dateTime = DateTime.parse(stringDate);
      return DateFormat('d/M/y', 'id_ID').format(dateTime);
    } else {
      return '--/--/----';
    }
  }

  static String dateTime(String stringDate) {
    DateTime dateTime = DateTime.parse(stringDate);
    return DateFormat('d/M/y', 'id_ID').format(dateTime);
  }

  static String date2(String stringDate) {
    DateTime dateTime = DateTime.parse(stringDate);
    return DateFormat('d MMMM yyyy', 'id_ID').format(dateTime);
  }

  static String dateMonth(String stringDate) {
    DateTime dateTime = DateTime.parse(stringDate);
    return DateFormat('d MMM', 'id_ID').format(dateTime);
  }

  static String dateYear(String stringDate) {
    DateTime dateTime = DateTime.parse(stringDate);
    return DateFormat('yyyy', 'id_ID').format(dateTime);
  }

  static String currency(double number) {
    return NumberFormat.currency(
      decimalDigits: 0,
      locale: 'id_ID',
      symbol: 'Rp. ',
    ).format(number);
  }

  static String removeHtmlTags(String htmlString) {
    if (htmlString.isNotEmpty) {
      html_dom.Document document = html_parser.parse(htmlString);
      return document.body?.text ?? '';
    } else {
      return '-----';
    }
  }

  static String formatThousand(int views) {
    if (views >= 1000000) {
      return '${(views / 1000000).toStringAsFixed(1)}M';
    } else if (views >= 1000) {
      return '${(views / 1000).toStringAsFixed(1)}K';
    } else {
      return views.toString();
    }
  }
}
