class QuestionModel {
  final String id;
  final String quizId;
  final String question;
  final String type;
  final List<OptionModel> options;
  final int orderIndex;
  final int? points;

  QuestionModel({
    required this.id,
    required this.quizId,
    required this.question,
    this.type = 'multiple_choice',
    this.options = const [],
    this.orderIndex = 0,
    this.points,
  });

  static int _parseIntSafe(dynamic value, [int defaultValue = 0]) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id']?.toString() ?? '',
      quizId: json['quiz_id']?.toString() ?? json['quizId']?.toString() ?? '',
      question: json['question'] ?? json['question_text'] ?? json['text'] ?? '',
      type: json['type'] ?? json['question_type'] ?? 'multiple_choice',
      options: (json['options'] as List? ?? [])
          .map((e) => OptionModel.fromJson(e))
          .toList(),
      orderIndex: _parseIntSafe(json['order_index'] ?? json['orderIndex']),
      points: json['points'] != null ? _parseIntSafe(json['points']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quiz_id': quizId,
      'question': question,
      'type': type,
      'order_index': orderIndex,
      'points': points,
    };
  }

  bool get isMultipleChoice => type == 'multiple_choice';
  bool get isTrueFalse => type == 'true_false';
  bool get isEssay => type == 'essay';
}

class OptionModel {
  final String id;
  final String questionId;
  final String text;
  final bool isCorrect;
  final int orderIndex;

  OptionModel({
    required this.id,
    required this.questionId,
    required this.text,
    this.isCorrect = false,
    this.orderIndex = 0,
  });

  static int _parseIntSafe(dynamic value, [int defaultValue = 0]) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(
      id: json['id']?.toString() ?? '',
      questionId: json['question_id']?.toString() ?? json['questionId']?.toString() ?? '',
      text: json['text'] ?? json['option'] ?? json['option_text'] ?? '',
      isCorrect: json['is_correct'] ?? json['isCorrect'] ?? false,
      orderIndex: _parseIntSafe(json['order_index'] ?? json['orderIndex']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question_id': questionId,
      'text': text,
      'order_index': orderIndex,
    };
  }
}

class QuizAnswerModel {
  final String questionId;
  final String? selectedOptionId;
  final String? textAnswer;

  QuizAnswerModel({
    required this.questionId,
    this.selectedOptionId,
    this.textAnswer,
  });

  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      if (selectedOptionId != null) 'selected_option_id': selectedOptionId,
      if (textAnswer != null) 'text_answer': textAnswer,
    };
  }
}
