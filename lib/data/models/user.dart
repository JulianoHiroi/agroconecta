// a classe user tera os seguintes campos:
/*
{
    "user": {
        "id": "9c06c732-11a3-4602-b7dc-05abe6363108",
        "name": "João da Silva",
        "email": "teste@teste.com",
        "gender": "male",
        "date_of_birth": "1990-05-15T00:00:00.000Z"
    }
}
 */

class User {
  final String id;
  final String name;
  final String email;
  final String gender;
  final DateTime dateOfBirth;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.gender,
    required this.dateOfBirth,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      gender: json['gender'],
      dateOfBirth: DateTime.parse(json['date_of_birth']),
    );
  }

  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email, gender: $gender, dateOfBirth: $dateOfBirth}';
  }

  static const SQLITE_TABLE_NAME = 'users';
  static const SQLITE_COLUMN_ID = 'id';
  static const SQLITE_COLUMN_NAME = 'name';
  static const SQLITE_COLUMN_EMAIL = 'email';
  static const SQLITE_COLUMN_GENDER = 'gender';
  static const SQLITE_COLUMN_DATE_OF_BIRTH = 'date_of_birth';

  static const SQLITE_CREATE_TABLE =
      '''
  CREATE TABLE $SQLITE_TABLE_NAME (
    $SQLITE_COLUMN_ID TEXT PRIMARY KEY,
    $SQLITE_COLUMN_NAME TEXT NOT NULL,
    $SQLITE_COLUMN_EMAIL TEXT NOT NULL,
    $SQLITE_COLUMN_GENDER TEXT NOT NULL,
    $SQLITE_COLUMN_DATE_OF_BIRTH TEXT NOT NULL
  )
''';
  static const SQLITE_DROP_TABLE = 'DROP TABLE IF EXISTS $SQLITE_TABLE_NAME';
}
