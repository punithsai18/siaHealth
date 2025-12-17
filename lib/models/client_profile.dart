class ClientProfile {
  // Client Overview
  final String clientId;
  final String name;
  final int age;
  final List<String> primaryConditions;
  final List<String> currentGoals;
  final String planStartDate;
  final String planDuration;
  final String assignedNutritionist;
  
  // Medical & Health History
  final List<String> diagnosedConditions;
  final List<String> medications;
  final List<String> foodAllergies;
  final String dietaryPreference;
  final List<String> pastIssues;
  
  // Lifestyle & Habits
  final String activityLevel;
  final String sleepQuality;
  final String workSchedule;
  final String stressLevel;
  final String waterIntake;
  
  // Health Logs & Patterns
  final String energyLevels;
  final String cravings;
  final String bloatingIssues;
  final String moodChanges;
  final String cycleNotes;
  
  // Goals & Success Metrics
  final String primaryGoal;
  final String secondaryGoal;
  final String shortTermExpectations;
  final String longTermOutcomes;
  
  // Risk Flags / Notes
  final List<String> riskFlags;
  final String coachNotes;
  
  // System Metadata
  final String lastUpdated;
  final String dataCompletenessStatus;
  final List<String> systemFlags;

  ClientProfile({
    required this.clientId,
    required this.name,
    required this.age,
    required this.primaryConditions,
    required this.currentGoals,
    required this.planStartDate,
    required this.planDuration,
    required this.assignedNutritionist,
    required this.diagnosedConditions,
    required this.medications,
    required this.foodAllergies,
    required this.dietaryPreference,
    required this.pastIssues,
    required this.activityLevel,
    required this.sleepQuality,
    required this.workSchedule,
    required this.stressLevel,
    required this.waterIntake,
    required this.energyLevels,
    required this.cravings,
    required this.bloatingIssues,
    required this.moodChanges,
    required this.cycleNotes,
    required this.primaryGoal,
    required this.secondaryGoal,
    required this.shortTermExpectations,
    required this.longTermOutcomes,
    required this.riskFlags,
    required this.coachNotes,
    required this.lastUpdated,
    required this.dataCompletenessStatus,
    required this.systemFlags,
  });

  static ClientProfile getSampleClient() {
    return ClientProfile(
      clientId: "CL-2024-001",
      name: "Priya Sharma",
      age: 28,
      primaryConditions: ["PCOS", "Insulin Resistance"],
      currentGoals: ["Improve energy", "Cycle regularity", "Weight management", "Symptom control"],
      planStartDate: "2024-01-01",
      planDuration: "12 weeks",
      assignedNutritionist: "Dr. Anjali Mehta",
      diagnosedConditions: ["PCOS (Polycystic Ovary Syndrome)", "Insulin Resistance"],
      medications: ["Metformin 500mg (2x daily)"],
      foodAllergies: ["None"],
      dietaryPreference: "Vegetarian",
      pastIssues: ["Irregular periods", "Insulin resistance", "Weight gain", "Hormonal imbalance"],
      activityLevel: "Moderate",
      sleepQuality: "Average",
      workSchedule: "Regular (9-6)",
      stressLevel: "High",
      waterIntake: "2-2.5 liters/day",
      energyLevels: "Low in mornings, fluctuating throughout day",
      cravings: "Frequent evening sugar cravings",
      bloatingIssues: "Post-lunch bloating",
      moodChanges: "Mood swings during cycle",
      cycleNotes: "Irregular cycles (30-45 days)",
      primaryGoal: "Improve energy levels",
      secondaryGoal: "Reduce bloating and cravings",
      shortTermExpectations: "Stable energy, reduced cravings (2-4 weeks)",
      longTermOutcomes: "Regular cycles, sustainable weight, hormonal balance",
      riskFlags: ["History of poor compliance with diet plans", "Sensitive to high carb meals"],
      coachNotes: "Requires regular check-ins and motivational support",
      lastUpdated: "2024-01-15",
      dataCompletenessStatus: "95% Complete",
      systemFlags: ["Missed 2 health logs last week"],
    );
  }
  
  // Backward compatibility getters for existing widgets that use single condition/goals
  // These allow the enhanced model to work with legacy code without breaking changes
  String get condition => primaryConditions.isNotEmpty ? primaryConditions.first : "Unknown";
  List<String> get goals => currentGoals;
  
  // Additional sample clients
  static ClientProfile getClientByName(String name) {
    switch (name) {
      case "Priya Sharma":
        return getSampleClient();
      case "Anjali Patel":
        return ClientProfile(
          clientId: "CL-2024-002",
          name: "Anjali Patel",
          age: 32,
          primaryConditions: ["Thyroid (Hypothyroidism)"],
          currentGoals: ["Weight management", "Energy levels", "Metabolism balance"],
          planStartDate: "2023-12-15",
          planDuration: "16 weeks",
          assignedNutritionist: "Dr. Anjali Mehta",
          diagnosedConditions: ["Hypothyroidism"],
          medications: ["Levothyroxine 50mcg (morning)"],
          foodAllergies: ["Shellfish"],
          dietaryPreference: "Non-Vegetarian",
          pastIssues: ["Weight gain", "Fatigue", "Cold intolerance"],
          activityLevel: "Sedentary",
          sleepQuality: "Poor",
          workSchedule: "Regular (10-7)",
          stressLevel: "Medium",
          waterIntake: "1.5-2 liters/day",
          energyLevels: "Consistently low throughout day",
          cravings: "Frequent carb cravings",
          bloatingIssues: "Occasional bloating",
          moodChanges: "Low mood, fatigue",
          cycleNotes: "Regular cycles (28-30 days)",
          primaryGoal: "Improve energy and metabolism",
          secondaryGoal: "Sustainable weight loss",
          shortTermExpectations: "Better energy levels (2-4 weeks)",
          longTermOutcomes: "Optimal thyroid function, healthy weight",
          riskFlags: ["Medication timing conflicts with meals"],
          coachNotes: "Needs morning-friendly meal plans",
          lastUpdated: "2024-01-14",
          dataCompletenessStatus: "88% Complete",
          systemFlags: ["Thyroid medication reminder needed"],
        );
      case "Meera Singh":
        return ClientProfile(
          clientId: "CL-2024-003",
          name: "Meera Singh",
          age: 26,
          primaryConditions: ["PCOS", "Pre-diabetes"],
          currentGoals: ["Cycle health", "Blood sugar control", "Weight loss"],
          planStartDate: "2024-01-05",
          planDuration: "12 weeks",
          assignedNutritionist: "Dr. Anjali Mehta",
          diagnosedConditions: ["PCOS", "Pre-diabetes (HbA1c 5.9)"],
          medications: ["None"],
          foodAllergies: ["Dairy intolerance"],
          dietaryPreference: "Vegetarian",
          pastIssues: ["Irregular periods", "Acne", "High blood sugar"],
          activityLevel: "Active",
          sleepQuality: "Good",
          workSchedule: "Shift-based (Rotating)",
          stressLevel: "Medium",
          waterIntake: "2.5-3 liters/day",
          energyLevels: "Good energy, dips after high carb meals",
          cravings: "Sweet cravings during late shifts",
          bloatingIssues: "Dairy causes severe bloating",
          moodChanges: "Stress eating during night shifts",
          cycleNotes: "Very irregular (35-60 days)",
          primaryGoal: "Regular menstrual cycles",
          secondaryGoal: "Prevent diabetes progression",
          shortTermExpectations: "Stable blood sugar, reduced cravings",
          longTermOutcomes: "Regular cycles, healthy HbA1c levels",
          riskFlags: ["Shift work makes meal timing challenging", "Family history of diabetes"],
          coachNotes: "Shift-friendly meal plans with dairy alternatives",
          lastUpdated: "2024-01-15",
          dataCompletenessStatus: "92% Complete",
          systemFlags: ["Excellent adherence to health logs"],
        );
      case "Kavya Reddy":
        return ClientProfile(
          clientId: "CL-2024-004",
          name: "Kavya Reddy",
          age: 30,
          primaryConditions: ["Cycle Health", "Low iron"],
          currentGoals: ["Improve iron levels", "Energy", "Cycle regularity"],
          planStartDate: "2024-01-10",
          planDuration: "10 weeks",
          assignedNutritionist: "Dr. Anjali Mehta",
          diagnosedConditions: ["Iron deficiency anemia", "Vitamin D deficiency"],
          medications: ["Iron supplement (100mg)", "Vitamin D3 (60000 IU weekly)"],
          foodAllergies: ["None"],
          dietaryPreference: "Non-Vegetarian",
          pastIssues: ["Heavy periods", "Fatigue", "Hair loss"],
          activityLevel: "Moderate",
          sleepQuality: "Average",
          workSchedule: "Regular (9-6)",
          stressLevel: "Low",
          waterIntake: "2 liters/day",
          energyLevels: "Improving with supplements",
          cravings: "Ice cravings (pica)",
          bloatingIssues: "Iron supplements cause constipation",
          moodChanges: "Stable mood",
          cycleNotes: "Regular but heavy flow (26-28 days)",
          primaryGoal: "Increase iron levels naturally",
          secondaryGoal: "Reduce fatigue and improve hair health",
          shortTermExpectations: "Better energy, less hair fall",
          longTermOutcomes: "Normal hemoglobin, healthy ferritin levels",
          riskFlags: ["Iron supplement adherence issues"],
          coachNotes: "Focus on iron-rich foods, vitamin C for absorption",
          lastUpdated: "2024-01-15",
          dataCompletenessStatus: "90% Complete",
          systemFlags: ["Good progress on iron levels"],
        );
      default:
        return getSampleClient();
    }
  }
}
