enum UserStepEnum {
  completed,
  healthInfo,
}

class UserStep {
  final UserStepEnum step;

  UserStep({required this.step});

  factory UserStep.fromString(String stepString) {
    UserStepEnum step;
    switch (stepString.toUpperCase()) {
      case 'COMPLETED':
        step = UserStepEnum.completed;
        break;
      case 'HEALTH_INFO':
        step = UserStepEnum.healthInfo;
        break;
      default:
        throw ArgumentError('Invalid step string: $stepString');
    }
    return UserStep(step: step);
  }

  @override
  String toString() {
    switch (step) {
      case UserStepEnum.completed:
        return "COMPLETED";
      case UserStepEnum.healthInfo:
        return "HEALTH_INFO";
    }
  }
}
