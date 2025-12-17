# Testing AI Analysis Feature

## Overview

This document provides testing scenarios and expected results for the AI Meal Plan Analysis feature.

## Test Setup

The implementation uses sample data from `ClientProfile.getSampleClient()` and `MealPlan.getSampleMealPlan()`.

### Sample Client: Priya Sharma
- **Age**: 28 years old
- **Primary Conditions**: PCOS, Insulin Resistance
- **Health Patterns**:
  - Energy Levels: "Low in mornings, fluctuating throughout day"
  - Cravings: "Frequent evening sugar cravings"
  - Bloating: "Post-lunch bloating"
- **Dietary Preference**: Vegetarian
- **Activity Level**: Moderate

### Sample Meal Plan
- **Total Carbs**: ~200g across all meals
- **Total Protein**: ~105g across all meals
- **Total Calories**: ~1994 kcal
- **Main Meals**: 3 (Breakfast, Lunch, Dinner)
- **Snacks**: 3 (Mid-morning, Evening, Late evening)

## Test Scenarios

### Scenario 1: Medical History Alignment

**Test**: Open Client Profile → Navigate to "AI Analysis" tab → Check Medical History Alignment section

**Expected Results**:

✅ **Strengths** should include:
- "Low-carb approach aligns well with PCOS management" (because average carbs per main meal < 50g)
- "Adequate protein supports hormonal balance" (because total protein / main meals ≥ 15g)
- "Respects vegetarian dietary preference" (no meat items in meal plan)

⚠️ **No concerns** expected for this sample data because:
- Carbs are appropriate for PCOS
- Protein levels are adequate
- No food allergies violated
- Dietary preference respected

**Alignment Status**: ✅ Aligned (isAligned = true)

### Scenario 2: Health Log Contradictions

**Test**: Check "Health Log Contradictions" section

**Expected Results**:

⚠️ **Contradictions** should include:
- "Client reports sugar cravings, but meal protein levels may be insufficient for satiety"
  - Because client reports "Frequent evening sugar cravings"
  - And some meals have protein < 12g

💡 **Suggestions** should include:
- "Increase protein in main meals to 12-15g to help manage sugar cravings"
- Possibly suggestions about evening meal timing

⚠️ **For Post-lunch Bloating**:
- May flag if lunch carbs > 50g
- Suggestion: "Reduce lunch carbohydrates and increase vegetables for better digestion"

**Contradiction Status**: ⚠️ Has Contradictions (hasContradictions = true)

### Scenario 3: High-Level Recommendations

**Test**: Check "High-Level Recommendations" section

**Expected Results**:

Should display **2-3 recommendations**, prioritized by importance:

**1. 🔴 or 🟡 Priority: Related to PCOS Management**
- Title includes "PCOS" or "Carbohydrate"
- Description explains insulin sensitivity
- Actionable steps include:
  - Adjusting carb portions
  - Increasing protein
  - Adding vegetables
  - Monitoring client response

**2. 🟡 Priority: Address Craving Management**
- Title includes "Craving"
- Description about meal timing and composition
- Actionable steps include:
  - Ensuring adequate protein (12-15g)
  - Adding healthy fats
  - Timing evening snacks
  - Blood sugar stabilization strategies

**3. 🟡 or 🟢 Priority: Based on other factors**
- Could be about energy levels (if detected as priority)
- Or bloating management
- Or general wellness monitoring

### Scenario 4: Overall Summary

**Test**: Check the "Overall Summary" section at the top

**Expected Results**:

Summary should include:
- Client name: "Priya Sharma"
- Age: "28"
- Conditions: "PCOS, Insulin Resistance"
- Overall assessment starting with ✅, ⚠️, or ❌
- Mention of high-priority recommendations (if any)

Example:
```
"AI Analysis for Priya Sharma (Age: 28, Conditions: PCOS, Insulin Resistance)

⚠️ Overall Assessment: The meal plan has good alignment with medical needs but shows some contradictions with health patterns. 1 high-priority recommendation(s) require immediate attention."
```

## Visual Testing

### Layout Tests

**Desktop/Tablet View** (width > 600px):
- [ ] AI Analysis tab appears as third tab
- [ ] Full-width layout with proper spacing
- [ ] All sections visible without excessive scrolling
- [ ] Priority badges clearly visible
- [ ] Color coding distinct (green, orange, red)

**Mobile View** (width < 600px):
- [ ] AI Analysis tab accessible
- [ ] Responsive layout with adjusted padding
- [ ] Text wraps appropriately
- [ ] Sections stack vertically
- [ ] Touch targets are adequate size

### Color Coding Tests

- [ ] ✅ Green for aligned/positive results
- [ ] ⚠️ Orange for warnings/concerns
- [ ] ❌ Red for critical issues
- [ ] 🔴 Red badge for high priority
- [ ] 🟡 Yellow badge for medium priority
- [ ] 🟢 Green badge for low priority

## Edge Case Testing

### Test Different Client Conditions

**Test with Thyroid Client** (Anjali Patel):
```dart
ClientProfile.getClientByName("Anjali Patel")
```

**Expected**:
- Medical history section should check for iodine-rich foods
- Should flag if not enough thyroid-supportive nutrients
- Energy-related recommendations (since "Consistently low throughout day")

**Test with Pre-diabetes Client** (Meera Singh):
```dart
ClientProfile.getClientByName("Meera Singh")
```

**Expected**:
- Blood sugar control emphasis
- Carb distribution warnings
- Dairy intolerance respected in analysis

**Test with Iron Deficiency Client** (Kavya Reddy):
```dart
ClientProfile.getClientByName("Kavya Reddy")
```

**Expected**:
- Iron-rich food checks
- Iron supplement interaction considerations
- Constipation (bloating) from supplements addressed

## Integration Testing

### Navigation Flow
1. [ ] Open app → Dashboard
2. [ ] Click on client card
3. [ ] Client profile opens with "Client Profile" tab active
4. [ ] Click "AI Analysis" tab
5. [ ] AI analysis displays immediately (no loading delay)
6. [ ] Can navigate back to other tabs without loss of state

### Data Consistency
- [ ] Analysis reflects current meal plan data
- [ ] Changes to meal plan (if implemented) trigger re-analysis
- [ ] Client profile data correctly used in analysis

## Performance Testing

### Load Time
- [ ] AI analysis generates in < 100ms (runs synchronously)
- [ ] No UI lag when switching to AI Analysis tab
- [ ] Smooth scrolling through analysis sections

### Memory
- [ ] No memory leaks when repeatedly opening/closing profiles
- [ ] Analysis results properly disposed when leaving screen

## Accessibility Testing

- [ ] Screen reader can read all sections
- [ ] Color contrast meets WCAG AA standards
- [ ] Icons have semantic meaning beyond color
- [ ] Text is legible at minimum supported font size

## Bug Testing Checklist

- [ ] No null pointer exceptions
- [ ] Handles empty or missing data gracefully
- [ ] No overflow errors in UI
- [ ] Works with different screen orientations
- [ ] Handles very long text in recommendations

## Success Criteria

✅ **Feature is considered complete when**:
1. All three questions are answered for any client profile
2. Analysis results are accurate and relevant
3. UI displays correctly on mobile and desktop
4. No crashes or errors during normal usage
5. Documentation is clear and comprehensive

## Known Limitations

1. **Flutter/Dart Environment**: Testing requires Flutter SDK to be installed
2. **Sample Data Only**: Currently uses hardcoded sample clients
3. **Rule-Based Logic**: Not ML-powered (future enhancement)
4. **No Real-Time Updates**: Analysis runs once when tab is opened

## Manual Testing Instructions

If Flutter is available:

```bash
# Run the app
cd /home/runner/work/sia/sia
flutter run -d chrome  # For web
# or
flutter run -d macos   # For desktop

# Test Steps:
1. App should load to dashboard
2. Click on "Priya Sharma" client card
3. Click "AI Analysis" tab
4. Verify all sections display correctly
5. Check console for any errors
```

## Automated Testing (Future)

To add automated tests, create `/test/ai_analysis_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:siahealth/models/client_profile.dart';
import 'package:siahealth/models/meal_item.dart';
import 'package:siahealth/services/ai_analysis_service.dart';

void main() {
  group('AI Analysis Service Tests', () {
    test('Should analyze PCOS client correctly', () {
      final client = ClientProfile.getSampleClient();
      final mealPlan = MealPlan.getSampleMealPlan();
      
      final result = AIAnalysisService.analyzeMealPlan(
        client: client,
        mealPlan: mealPlan,
      );
      
      expect(result.medicalHistoryAlignment.strengths.length, greaterThan(0));
      expect(result.recommendations.length, inRange(2, 3));
      expect(result.summary.isNotEmpty, true);
    });
  });
}
```
