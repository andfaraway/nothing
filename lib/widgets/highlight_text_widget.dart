import 'package:flutter/material.dart';

class HighlightTextWidget extends StatelessWidget {
  final TextStyle style;
  final String originalText;
  final List<String> highlightRegexList;
  final List<TextStyle> highlightStyles;

  const HighlightTextWidget({
    super.key,
    required this.style,
    required this.originalText,
    required this.highlightRegexList,
    required this.highlightStyles,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, TextStyle> textStyles = {};

    // 使用正则表达式找到并拆分高亮字符串
    List<TextSpan> textSpans = [];
    int previousEnd = 0;

    List<Match> matches = [];
    for (int i = 0; i < highlightRegexList.length; i++) {
      String highlightRegex = highlightRegexList[i];
      RegExp regExp = RegExp(highlightRegex);
      Iterable<Match> tempMatch = regExp.allMatches(originalText);
      if (tempMatch.isNotEmpty) {
        textStyles[tempMatch.first.pattern.toString()] = highlightStyles[i];
        matches.addAll(tempMatch);
      }
    }

    matches.sort((a, b) => a.start.compareTo(b.start));
    for (Match match in matches) {
      String nonHighlightedText = originalText.substring(previousEnd, match.start);
      String highlightedText = match.group(0)!;

      // 添加非高亮文本
      if (nonHighlightedText.isNotEmpty) {
        textSpans.add(TextSpan(
          text: nonHighlightedText,
        ));
      }

      // 添加高亮文本，应用自定义样式
      textSpans.add(TextSpan(
        text: highlightedText,
        style: textStyles[match.pattern.toString()],
      ));

      previousEnd = match.end;
    }

    // 添加剩余的非高亮文本
    String remainingText = originalText.substring(previousEnd);
    if (remainingText.isNotEmpty) {
      textSpans.add(TextSpan(
        text: remainingText,
      ));
    }

    return RichText(
      text: TextSpan(
        style: style,
        children: textSpans,
      ),
    );
  }
}
