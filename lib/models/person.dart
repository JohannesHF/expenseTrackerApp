import 'expense.dart';

class Person {
  static final List<Person> registeredPersons = [
    Person(name: 'Johannes'),
    Person(name: 'Sarah'),
    Person(name: 'Ben')
  ];

  final String name;
  final String id;

  Person({required this.name}) : id = uuid.v4();
}
