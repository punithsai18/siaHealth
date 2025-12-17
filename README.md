



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
