



# SIA Health - Internal Quality Control Dashboard
A Flutter-based internal tool for SIA Health nutritionists and health coaches to perform quality checks on personalized meal plans for women's hormonal health (PCOS, thyroid, cycle health).
## 📹 Demo Video

Watch the application walkthrough:








https://github.com/user-attachments/assets/a3668d46-0eea-46aa-88cb-3e4c4de3abfb


The video demonstrates the complete workflow including dashboard navigation, quality checks, client profile management, and AI-assisted analysis features.

## 🎯 Approach and Assumptions

### Our Approach

This application follows a **rule-based validation with AI enhancement** approach:

1. **Rule-Based Quality Checks First**: We implement reliable, consistent, and explainable checks for protein content, portion sizes, carbohydrate levels, and formatting
2. **AI as Enhancement**: AI provides nuanced insights and context-aware recommendations that complement automated checks
3. **Health Coach Focus**: The UI is designed for quick scanning and decision-making by professional health coaches
4. **Clear Communication**: Every check explains "why" not just "what" to support informed decisions
5. **Actionable Feedback**: Specific, prioritized recommendations for meal plan improvements

### Key Assumptions

#### Business Assumptions
1. **Protein Range**: 10-14g is optimal for main meals (can be adjusted per client needs)
2. **Low-Carb Threshold**: ≤30g carbs for strict PCOS management, ≤45g for moderate approach
3. **Portion Specificity**: Any measurement (grams, bowls, pieces) is acceptable if clearly defined
4. **Formatting Standards**: Basic checks for spaces and capitalization (not comprehensive spell-checking)

#### Technical Assumptions
1. **Sample Data**: Application uses hardcoded sample data for demonstration purposes
2. **Role-Based Access**: Three distinct user roles (Client, Nutritionist, Health Coach) with specific permissions
3. **Target Users**: Internal tool for nutritionists and health coaches, not client-facing

## Getting Started

### Prerequisites
- Flutter SDK (^3.9.2)
- Dart SDK
- IDE: VS Code, Android Studio, or IntelliJ IDEA

### Installation

1. Clone the repository:
```bash
git clone https://github.com/punithsai18/siaHealth.git
cd sia
```

2. Get dependencies:
```bash
flutter pub get
```

3. Run the application:
```bash
flutter run
```

### Running on Different Platforms

```bash
# Web
flutter run -d chrome

# iOS
flutter run -d ios

# Android
flutter run -d android

# macOS
flutter run -d macos
```

## Overview

This application provides an intuitive dashboard that:
- Displays client health profiles and conditions
- Shows detailed meal plans with nutritional information
- Performs automated quality checks on meal plans
- Provides clear, actionable feedback for health coaches
- Includes AI-assisted plan analysis framework (optional)
- Implements role-based access control for different user types

## User Roles

SIA Health supports three distinct user roles, each with specific responsibilities:

### 1. **Client (End User)**
- Women receiving care for PCOS, thyroid, and cycle health
- **Provides:** Health history and daily health logs (energy, cravings, bloating, etc.)
- **Access:** Does NOT interact with this internal tool directly
- **Note:** Clients may have a separate client-facing portal

### 2. **Nutritionist (Internal User)**
- **Primary Role:** Content creator for meal plans
- **Responsibilities:**
  - Creates personalized meal plans
  - Updates or revises plans based on feedback from health coaches
  - Uses quality check results to improve plans
- **Permissions:** Full edit capabilities for meal plans

### 3. **Health Coach (Internal User)**
- **Primary Role:** Reviews client progress and makes decisions
- **Responsibilities:**
  - Reviews client progress and health patterns
  - Uses QC results and AI insights for decision making
  - Approves or requests revisions to meal plans
  - Escalates complex cases when needed
- **Permissions:** Review and approval capabilities, but cannot edit meal plans directly

## Features

### 1. Client Profile Management
- **Client Information**: Name, age, condition (PCOS, thyroid, etc.)
- **Health History**: Diagnosis, symptoms, medications, dietary preferences
- **Health Log Patterns**: Tracks cravings, bloating, energy levels, sleep, and stress

### 2. Meal Plan Display
- **Structured Layout**: Breakfast, lunch, dinner, and snacks
- **Nutritional Details**: Protein, carbs, fats, and calories per item
- **Portion Sizes**: Clearly defined portions for each food item
- **Plan Notes**: Special instructions and dietary focus

### 3. Quality Checks (Rule-Based)

The system implements four automated quality checks:

#### Check 1: Protein Content Check ✓
- **Criteria**: Main meals (breakfast, lunch, dinner) should contain 10-14g of protein
- **Purpose**: Ensures adequate protein for satiety and muscle maintenance
- **Status Levels**:
  - ✅ **OK**: All meals have 10-14g protein
  - ⚠️ **Warning**: Meals are 8-10g or 14-20g (close but not optimal)
  - ❌ **Needs Improvement**: Meals significantly outside range

#### Check 2: Portion Size Check ✓
- **Criteria**: All meal items must have clearly defined portions
- **Purpose**: Ensures accurate tracking and consistency
- **Examples**: "2 medium pieces", "1 bowl (100g)", "10 pieces"
- **Status Levels**:
  - ✅ **OK**: All items have specific measurements
  - ⚠️ **Warning**: Some portions are vague (e.g., "handful")
  - ❌ **Needs Improvement**: Items missing portion sizes

#### Check 3: Low-Carb Consistency Check ✓
- **Criteria**: For PCOS management, main meals should have ≤30-45g carbs
- **Purpose**: Supports insulin sensitivity for hormonal health
- **Status Levels**:
  - ✅ **OK**: All main meals ≤30g carbs
  - ⚠️ **Warning**: Some meals 30-45g carbs (moderate)
  - ❌ **Needs Improvement**: Meals >45g carbs (high for PCOS)

#### Check 4: Formatting & Quality Check ✓
- **Criteria**: Professional formatting, no typos, consistent structure
- **Purpose**: Ensures professional delivery to clients
- **Checks**: Proper capitalization, no extra spaces, complete information
- **Status Levels**:
  - ✅ **OK**: Professionally formatted
  - ⚠️ **Warning**: Minor formatting issues
  - ❌ **Needs Improvement**: Multiple formatting problems

### 4. AI-Assisted Meal Plan Analysis ✨

The application includes a comprehensive AI-powered analysis feature that evaluates meal plans using a three-question framework:

#### Three-Question Framework
```
Analyze this meal plan for a [age]-year-old client with [condition].
Health patterns: [cravings], [bloating], [energy levels]

Questions addressed:
1. Does the plan align with the client's medical history?
   - Evaluates condition-specific requirements (PCOS, Thyroid, etc.)
   - Checks dietary preferences and allergies
   - Identifies strengths and concerns

2. Are there contradictions between the plan and health log?
   - Correlates cravings with meal composition
   - Matches bloating patterns with food choices
   - Validates energy levels vs meal timing
   - Provides specific suggestions for resolution

3. What are 2-3 high-level concerns or recommendations?
   - Prioritized recommendations (High, Medium, Low)
   - Actionable steps for each recommendation
   - Context-aware based on client goals
```

#### Implementation Features
- **Comprehensive Analysis**: Evaluates multiple aspects of meal plan quality
- **Client-Specific Logic**: Tailored to individual medical history and health patterns
- **Actionable Insights**: Provides specific steps, not just observations
- **Prioritized Recommendations**: Focuses attention on most important issues
- **Visual Presentation**: Color-coded status indicators and priority badges
- **Responsive UI**: Dedicated "AI Analysis" tab in Client Profile Screen

#### Sample AI Analysis Output
For a 28-year-old client with PCOS:
- ✅ **Medical History Alignment**: Low-carb approach aligns well with PCOS management
- ⚠️ **Health Log Contradictions**: Protein levels may be insufficient for managing sugar cravings
- 🔴 **High Priority Recommendation**: Optimize carbohydrate distribution for better insulin sensitivity
- 🟡 **Medium Priority Recommendation**: Address craving management through strategic meal timing

For detailed documentation, see [AI_ANALYSIS_FEATURE.md](docs/AI_ANALYSIS_FEATURE.md)

## Project Structure

```
lib/
├── main.dart                           # App entry point
├── models/
│   ├── client_profile.dart             # Client data model
│   ├── meal_item.dart                  # Meal plan data models
│   ├── quality_check.dart              # Quality check result model
│   ├── user.dart                       # User model with role information
│   ├── user_role.dart                  # User role enum and permissions
│   └── user_permission.dart            # Permission enum for type-safe access control
├── services/
│   └── quality_check_service.dart      # Quality check logic
├── screens/
│   ├── dashboard_screen.dart           # Main dashboard UI
│   ├── overview_dashboard_screen.dart  # Dashboard overview
│   ├── clients_screen.dart             # Clients list
│   ├── settings_screen.dart            # Settings
│   ├── notifications_screen.dart       # Notifications
│   └── rules_check_screen.dart         # Quality rules configuration
└── widgets/
    ├── client_summary_card.dart        # Client profile display
    ├── meal_plan_card.dart             # Meal plan display
    └── quality_check_card.dart         # Quality check results display
```

## Sample Data

The application includes hardcoded sample data for demonstration:

**Sample Client**: Priya Sharma, 28 years old, PCOS patient
- Goals: Weight management, cycle health, energy balance
- Health patterns: High sugar cravings, frequent bloating, low morning energy
- Dietary preference: Vegetarian

**Sample Meal Plan**: Low-carb PCOS management plan
- Breakfast: Moong dal cheela with green chutney
- Lunch: Roti, paneer curry, mixed vegetable salad
- Dinner: Grilled paneer, stir-fried vegetables, tomato soup
- Snacks: Almonds, sprouts chaat

## Technical Implementation

### Design Decisions

1. **Modular Architecture**: Separation of models, services, widgets, and screens for maintainability
2. **Role-Based Access Control**: Formal user role system with permissions for Clients, Nutritionists, and Health Coaches
3. **Reusable Widgets**: Custom widgets for client summary, meal plans, and quality checks
4. **Clear Status System**: OK/Warning/Needs Improvement with color-coded indicators
5. **Detailed Feedback**: Each check provides 1-2 line explanations with expandable details
6. **Health Coach Focus**: UI designed for quick scanning and decision-making

### Role-Based Features

The application implements a comprehensive user role system:

**User Roles (`UserRole` enum):**
- `client` - End users who provide health data (no direct tool access)
- `nutritionist` - Creates and edits meal plans
- `healthCoach` - Reviews and approves meal plans, uses AI insights

**Permission System:**
```dart
// Type-safe permission checks using UserPermission enum
bool canEdit = currentUser.hasPermission(UserPermission.editMealPlans);        // Nutritionists only
bool canApprove = currentUser.hasPermission(UserPermission.reviewMealPlans);   // Health Coaches only
bool canViewAI = currentUser.hasPermission(UserPermission.viewAIInsights);     // Health Coaches only
```

**Role-Specific UI:**
- User role badge displayed in top bar with color coding
- Navigation and features adapt based on user role
- Edit capabilities shown only to nutritionists
- Approval workflow shown only to health coaches

### Quality Check Logic

The `QualityCheckService` implements logical checks based on:
- **Nutritional Guidelines**: Standard protein requirements (10-14g per meal)
- **PCOS Management**: Low-carb thresholds for insulin sensitivity
- **Professional Standards**: Portion specification requirements
- **User Experience**: Clear formatting and presentation

## Future Enhancements

1. **Real Data Integration**: Connect to backend API for client and meal plan data
2. **AI API Integration**: Implement actual AI service (OpenAI, Anthropic) for plan analysis
3. **Export Functionality**: Generate PDF reports for health coaches
4. **Historical Tracking**: View past meal plans and quality check results
5. **Custom Check Rules**: Allow coaches to configure check thresholds
6. **Multi-client Dashboard**: View and compare multiple clients
7. **Notification System**: Alert coaches when plans need review
8. **Collaborative Features**: Comments and approvals workflow

## Documentation

Additional technical documentation is available in the `docs/` folder:

- **[AI_ANALYSIS_FEATURE.md](docs/AI_ANALYSIS_FEATURE.md)** - Detailed documentation of the AI analysis feature
- **[IMPLEMENTATION_SUMMARY.md](docs/IMPLEMENTATION_SUMMARY.md)** - Technical implementation summary
- **[TESTING_AI_ANALYSIS.md](docs/TESTING_AI_ANALYSIS.md)** - Testing guide for AI analysis features

## License

This project is for educational and assignment purposes.

## Contact

For questions or feedback about this implementation, please open an issue on GitHub.
