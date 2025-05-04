import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class InformationWishlistPage extends StatefulWidget {
  final String documentId;

  const InformationWishlistPage({Key? key, required this.documentId})
      : super(key: key);

  @override
  State<InformationWishlistPage> createState() =>
      _InformationWishlistPageState();
}

class _InformationWishlistPageState extends State<InformationWishlistPage> {
  List<String> wishlist = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadwishlist();
  }

  Future<void> _loadwishlist() async {
    try {
      // 1. Получаем ссылку на коллекцию "food" для конкретного мероприятия
      final foodCollection = FirebaseFirestore.instance
          .collection('events')
          .doc(widget.documentId)
          .collection('Wishlist');

      // 2. Получаем все документы из этой коллекции
      final snapshot = await foodCollection.get();

      // 3. Преобразуем документы в список названий блюд
      List<String> loadedFood =
          snapshot.docs.map((doc) => doc['name'] as String).toList();

      // 4. Обновляем состояние виджета
      setState(() {
        wishlist = loadedFood;
        _errorMessage = null;
      });
    } catch (e) {
      print('Error loading food: $e');
      _errorMessage = 'Ошибка при загрузке блюд: $e';
      setState(() {});
    }
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ссылка скопирована в буфер обмена')),
    );
  }

  String? _extractURL(String text) {
    // Функция для извлечения URL из текста
    final RegExp urlRegExp = RegExp(
        r'(?:(?:https?|ftp):\/\/)?[\w.-]+\.[\w.-]+(?:[/[\w-._~:/?#[\]@!$&\()*+,;=.]*)?'); // Более точное регулярное выражение

    final match = urlRegExp.firstMatch(text);
    if (match != null) {
      return text.substring(match.start, match.end); // Возвращаем найденный URL
    }
    return null; // Если URL не найден, возвращаем null
  }

  String _extractText(String text, String? url) {
    // Извлекаем текст до и после URL
    if (url == null) {
      return text;
    }
    int urlIndex = text.indexOf(url);
    if (urlIndex == -1) {
      return text;
    }

    String textBefore = text.substring(0, urlIndex);
    String textAfter = text.substring(urlIndex + url.length);

    return '$textBefore $url $textAfter'; // Добавляем пробелы вокруг URL
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFD0E4F7),
        title: SizedBox(
//            width: 200,
//            height: 60,
//           child: Card(
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(100)),
//            color: const Color(0x993C3C43),
//             child: const Padding(
//               padding: EdgeInsets.all(0),
          child: Text('Вишлист', style: TextStyle(color: Colors.black)),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // 5. Отображаем сообщение об ошибке, если оно есть
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(_errorMessage!),
                ),
              // 6. Отображаем список блюд
              Expanded(
                child: ListView.builder(
                  itemCount: wishlist.length,
                  itemBuilder: (context, index) {
                    String wish = wishlist[index];
                    String? url = _extractURL(wish);
                    bool isURL = url != null;

                    String textBefore = ""; // Инициализируем
                    String textAfter = ""; // Инициализируем

                    if (isURL && url != null) {
                      int urlIndex = wish.indexOf(url); // Находим индекс URL
                      textBefore =
                          wish.substring(0, urlIndex).trim(); // Текст до URL
                      textAfter = wish
                          .substring(urlIndex + url.length)
                          .trim(); // Текст после URL
                    } else {
                      textBefore = wish; // Если URL нет, то все - текст
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Card(
                        color: const Color(0xFFD0E4F7),
                        child: ListTile(
                          title: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 10),
                            child: Wrap(
                              // Теперь у нас Wrap содержит отдельные виджеты
                              children: [
                                if (textBefore
                                    .isNotEmpty) // Отображаем текст до URL, если он есть
                                  Text(
                                    '$textBefore ', // Добавляем пробел после текста
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                if (isURL &&
                                    url !=
                                        null) // Если есть URL, отображаем его
                                  GestureDetector(
                                    onTap: () {
                                      _launchURL(url);
                                    },
                                    onLongPress: () {
                                      _copyToClipboard(url);
                                    },
                                    child: Text(
                                      url,
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                if (textAfter
                                    .isNotEmpty) // Отображаем текст после URL, если он есть
                                  Text(
                                    ' $textAfter', // Добавляем пробел перед текстом
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// // Функция для создания списка TextSpan
// List<TextSpan> _buildTextSpans(String text, String? url) {
//   List<TextSpan> spans = [];

//   if (url == null) {
//     // Если URL не найден, возвращаем один TextSpan со всем текстом
//     spans.add(TextSpan(text: text));
//     return spans;
//   }

//   int urlStartIndex = text.indexOf(url);
//   if (urlStartIndex == -1) {
//     // Если URL не найден (что-то пошло не так), возвращаем один TextSpan со всем текстом
//     spans.add(TextSpan(text: text));
//     return spans;
//   }

//   // Добавляем текст до URL
//   if (urlStartIndex > 0) {
//     spans.add(TextSpan(text: text.substring(0, urlStartIndex)));
//   }

//   // Добавляем URL с нужными стилями
//   spans.add(
//     TextSpan(
//       text: url,
//       style: const TextStyle(
//         color: Colors.blue,
//         decoration: TextDecoration.underline,
//       ),
//     ),
//   );

//   // Добавляем текст после URL
//   if (urlStartIndex + url.length < text.length) {
//     spans.add(TextSpan(text: text.substring(urlStartIndex + url.length)));
//   }

//   return spans;
// }
