import 'person.dart';

class SplitManager {
  late List<SplitParticipant> splitParticipants;
  late SplitParticipant funder;
  double _amount;
  List<void Function()> splitParticipantsChangeCallbacks = [];

  SplitManager(
      {required List<Person> splitsBetweenPersons, int indexOfFunder = 0})
      : _amount = 0.0 {
    splitParticipants = List.generate(
        splitsBetweenPersons.length,
        (index) => SplitParticipant(
            this, splitsBetweenPersons[index], index == 0, 0.0));
    funder = splitParticipants[indexOfFunder];
  }

  void selectFunder(SplitParticipant newFunder) {
    SplitParticipant oldFunder = funder;
    funder = newFunder;
    oldFunder._executeCallbackFunctions();
    newFunder._executeCallbackFunctions();
    _executeSplitParticipantsChangeCallbacks();
  }

  void borrowerUpdate(SplitParticipant splitParticipant) {
    refreshAmountShareOnParticipants();
    _executeSplitParticipantsChangeCallbacks();
  }

  void refreshAmountShareOnParticipants() {
    int curBorrowerQuantity = borrowerQuantity;
    if (curBorrowerQuantity == 0) curBorrowerQuantity = 1;
    double amountShare = _amount / borrowerQuantity;
    for (SplitParticipant splitParticipant in splitParticipants) {
      splitParticipant.amountShare = amountShare;
    }
  }

  void registerSplitParticipantsChangeCallback(void Function() callback) {
    splitParticipantsChangeCallbacks.add(callback);
  }

  void removeSplitParticipantsChangeCallback(void Function() callback) {
    splitParticipantsChangeCallbacks.remove(callback);
  }

  void _executeSplitParticipantsChangeCallbacks() {
    for (void Function() callback in splitParticipantsChangeCallbacks) {
      callback();
    }
  }

  List<SplitParticipant> get borrowers => splitParticipants
      .where((splitParticipant) => splitParticipant.isBorrower)
      .toList();

  int get borrowerQuantity => borrowers.length;

  List<String> get borrowersNames {
    List<SplitParticipant> curBorrowers = borrowers;
    return List<String>.generate(
        curBorrowers.length, (index) => curBorrowers[index].person.name);
  }

  set amount(double amount) {
    _amount = amount;
    refreshAmountShareOnParticipants();
  }
}

class SplitParticipant {
  final Person _person;
  final SplitManager _splitManager;
  bool _isBorrower;
  double _amountShare;
  List<void Function(SplitParticipant)> callbacks = [];

  SplitParticipant(SplitManager splitManager, Person person, bool isBorrower,
      double amountShare,
      [bool isFunder = false])
      : _splitManager = splitManager,
        _person = person,
        _isBorrower = isBorrower,
        _amountShare = amountShare {
    if (isFunder) {
      selectAsFunder();
    }
  }

  void selectAsFunder() {
    splitManager.selectFunder(this);
  }

  void registerCallback(void Function(SplitParticipant) callback) {
    callbacks.add(callback);
  }

  void removeCallback(void Function(SplitParticipant) callback) {
    callbacks.remove(callback);
  }

  void _executeCallbackFunctions() {
    for (void Function(SplitParticipant) callback in callbacks) {
      callback(this);
    }
  }

  set amountShare(double value) {
    _amountShare = value;
    if (!isBorrower) _amountShare = 0;
    _executeCallbackFunctions();
  }

  void setAsBorrower(bool? value) {
    if (value != null) _isBorrower = value;
    splitManager.borrowerUpdate(this);
    _executeCallbackFunctions();
  }

  bool get isFunder => this == splitManager.funder;

  double get amountShare => _amountShare;

  bool get isBorrower => _isBorrower;

  SplitManager get splitManager => _splitManager;

  Person get person => _person;
}