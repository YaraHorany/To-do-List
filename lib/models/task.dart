class Task {
  int? id;
  String? title;
  String? note;
  int? isCompleted;
  String? date;
  String? startTime;
  int? color;
  int? remind;
  String? repeat;

  Task({
    this.id,
    this.title,
    this.note,
    this.isCompleted,
    this.date,
    this.startTime,
    this.color,
    this.remind,
    this.repeat,
  });

  Task copy({
    int? id,
    String? title,
    String? note,
    int? isCompleted,
    String? date,
    String? startTime,
    int? color,
    int? remind,
    String? repeat,
  }) =>
      Task(
        id: id ?? this.id,
        title: title ?? this.title,
        note: note ?? this.note,
        isCompleted: isCompleted ?? this.isCompleted,
        date: date ?? this.date,
        startTime: startTime ?? this.startTime,
        color: color ?? this.color,
        remind: remind ?? this.remind,
        repeat: repeat ?? this.repeat,
      );

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    note = json['note'];
    isCompleted = json['isCompleted'];
    date = json['date'];
    startTime = json['startTime'];
    color = json['color'];
    remind = json['remind'];
    repeat = json['repeat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['title'] = title;
    data['note'] = note;
    data['isCompleted'] = isCompleted;
    data['date'] = date;
    data['startTime'] = startTime;
    data['color'] = color;
    data['remind'] = remind;
    data['repeat'] = repeat;
    return data;
  }
}
