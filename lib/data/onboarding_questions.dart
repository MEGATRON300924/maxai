import '../models/onboarding_question.dart';

const onboardingQuestions = [

  OnboardingQuestion(
    step: 1,
    type: OnboardingQuestionType.name,
    question: "What name should I use?",
    subtitle: "Let's start by getting to know each other.",
  ),

  OnboardingQuestion(
    step: 2,
    type: OnboardingQuestionType.goals,
    question: "What would you like me to help you with?",
    subtitle: "Choose anything that sounds useful.",
    options: [
      "Learning",
      "Productivity",
      "Business",
      "Coding",
      "Creativity",
      "Gaming",
      "Entertainment",
      "Everyday Tasks",
    ],
  ),

  OnboardingQuestion(
    step: 3,
    type: OnboardingQuestionType.interests,
    question: "What are some things you're interested in?",
    subtitle: "Pick as many as you like.",
    options: [
      "Technology",
      "Artificial Intelligence",
      "Music",
      "Design",
      "Business",
      "Photography",
      "Science",
      "Travel",
      "Fitness",
      "Gaming",
      "Books",
      "Movies",
    ],
  ),

  OnboardingQuestion(
    step: 4,
    type: OnboardingQuestionType.religion,
    question: "Would you like me to respect any personal beliefs or preferences while helping you?",
    subtitle: "This helps me respond more thoughtfully.",
    options: [
      "Jehovah's Witness",
      "Christianity",
      "Islam",
      "Judaism",
      "Hinduism",
      "Buddhism",
      "Other",
      "Prefer not to say",
    ],
  ),

  OnboardingQuestion(
    step: 5,
    type: OnboardingQuestionType.personality,
    question: "How would you like me to communicate with you?",
    subtitle: "You can always change this later.",
    options: [
      "Simple",
      "Detailed",
      "Creative",
      "Professional",
      "Friendly",
      "Balanced",
    ],
  ),

];