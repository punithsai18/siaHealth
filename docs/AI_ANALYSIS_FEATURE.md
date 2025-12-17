# AI Meal Plan Analysis Feature

## Overview

The AI Meal Plan Analysis feature provides comprehensive, intelligent evaluation of meal plans based on client profiles, medical history, and health patterns. This feature implements a three-question framework that addresses critical aspects of meal plan quality and client suitability.

## Three-Question Framework

The AI analysis evaluates meal plans by answering three key questions:

### 1. Does the plan align with the client's medical history?

**What it checks:**
- Condition-specific dietary requirements (PCOS, Thyroid, Diabetes, Iron deficiency, etc.)
- Dietary preferences (Vegetarian, Non-vegetarian, etc.)
- Food allergies and intolerances
- Nutritional adequacy for the client's age and conditions

**Output:**
- **Strengths**: Areas where the meal plan aligns well with medical needs
- **Concerns**: Areas that need attention or adjustment
- **Overall alignment status**: Whether the plan is well-suited for the client

**Example Analysis:**
- ✅ Low-carb approach aligns well with PCOS management
- ✅ Adequate protein supports hormonal balance
- ⚠️ Consider adding more iodine-rich foods for thyroid health

### 2. Are there contradictions between the plan and health log?

**What it checks:**
- Craving patterns vs meal composition
- Bloating issues vs food choices
- Energy levels vs meal timing and calorie distribution
- Activity level vs calorie intake

**Output:**
- **Contradictions**: Specific mismatches found
- **Suggestions**: Actionable steps to resolve contradictions

**Example Analysis:**
- ⚠️ Client reports sugar cravings, but meal protein levels may be insufficient for satiety
- 💡 Increase protein in main meals to 12-15g to help manage sugar cravings
- ⚠️ High-carb lunch may contribute to post-lunch bloating
- 💡 Reduce lunch carbohydrates and increase vegetables for better digestion

### 3. What are 2-3 high-level concerns or recommendations?

**What it provides:**
- Prioritized recommendations (High, Medium, Low priority)
- Specific, actionable steps for each recommendation
- Context-aware suggestions based on client goals and conditions

**Output includes:**
- **Priority Level**: Visual indicator of urgency (🔴 High, 🟡 Medium, 🟢 Low)
- **Title**: Clear, concise recommendation name
- **Description**: Detailed explanation of the recommendation
- **Actionable Steps**: 3-4 specific steps to implement the recommendation

**Example Recommendations:**

**🔴 High Priority: Optimize Carbohydrate Distribution for PCOS**
- Reduce roti/rice portions by 25% in lunch and dinner
- Increase protein portions to maintain satiety
- Add more low-carb vegetables to increase volume
- Monitor client's response after 1 week

**🟡 Medium Priority: Address Craving Management Strategy**
- Ensure 12-15g protein in each main meal
- Add healthy fat sources (nuts, seeds) to increase satiety
- Time the evening snack closer to when cravings typically occur
- Include cinnamon or fenugreek to help stabilize blood sugar

## Implementation Details

### Data Models

**AIAnalysisResult**
- Contains complete analysis results
- Includes medical history alignment, health log contradictions, and recommendations

**AlignmentCheck**
- Evaluates medical history alignment
- Provides strengths and concerns

**ContradictionCheck**
- Identifies contradictions with health logs
- Provides suggestions for resolution

**Recommendation**
- Prioritized recommendation with actionable steps
- Includes priority level, title, description, and steps

### Service Architecture

**AIAnalysisService**
- Static service that performs analysis
- Main method: `analyzeMealPlan(client, mealPlan)`
- Returns comprehensive `AIAnalysisResult`

### Logic Implementation

The analysis uses three main logic components:

1. **Medical History Alignment Logic:**
   - Analyzes condition-specific requirements (PCOS → low-carb, Thyroid → iodine-rich foods)
   - Checks dietary preferences and allergies
   - Evaluates nutritional adequacy

2. **Health Log Contradiction Logic:**
   - Correlates cravings with protein/satiety levels
   - Matches bloating patterns with meal composition
   - Aligns energy patterns with meal timing
   - Validates calorie intake vs activity level

3. **Recommendation Generation Logic:**
   - Prioritizes based on client conditions and goals
   - Provides specific, actionable steps
   - Limits to 2-3 most important recommendations
   - Sorts by priority (High → Medium → Low)

## User Interface

### AI Analysis Tab

The AI Analysis is presented in a dedicated tab within the Client Profile Screen:

**Layout:**
1. **Header Section**: Introduces the AI analysis feature
2. **Client Context**: Displays age, conditions, and health patterns
3. **AI Analysis Card**: Shows comprehensive analysis with:
   - Overall summary
   - Medical history alignment
   - Health log contradictions
   - High-level recommendations
4. **Disclaimer**: Notes that AI analysis is a decision support tool

**Visual Design:**
- Color-coded status indicators (✅ Green for good, ⚠️ Orange for concerns)
- Priority badges for recommendations (🔴 🟡 🟢)
- Expandable sections for detailed information
- Responsive design for mobile and desktop

## Usage Workflow

### For Health Coaches:

1. Open client profile
2. Navigate to "AI Analysis" tab
3. Review overall summary
4. Check medical history alignment
5. Identify contradictions with health logs
6. Prioritize recommendations based on urgency
7. Use insights to make informed decisions or request plan revisions

### For Nutritionists:

1. View AI analysis feedback
2. Understand areas needing adjustment
3. Implement recommended changes
4. Re-run analysis to verify improvements

## Sample Output

For a 28-year-old client with PCOS reporting sugar cravings and bloating:

**Overall Summary:**
"⚠️ Overall Assessment: The meal plan has good alignment with medical needs but shows some contradictions with health patterns. 1 high-priority recommendation(s) require immediate attention."

**Medical History Alignment:** ✅
- ✅ Low-carb approach aligns well with PCOS management
- ✅ Adequate protein supports hormonal balance
- ✅ Respects vegetarian dietary preference

**Health Log Contradictions:** ⚠️
- ⚠️ Client reports sugar cravings, but meal protein levels may be insufficient for satiety
- 💡 Increase protein in main meals to 12-15g to help manage sugar cravings

**Recommendations:**
1. 🔴 **Optimize Carbohydrate Distribution for PCOS** - Adjust meal composition for better insulin sensitivity
2. 🟡 **Address Craving Management Strategy** - Strategic meal timing and composition to reduce cravings

## Benefits

1. **Comprehensive Analysis**: Evaluates multiple aspects of meal plan quality
2. **Client-Specific**: Tailored to individual medical history and health patterns
3. **Actionable Insights**: Provides specific steps, not just observations
4. **Prioritized Recommendations**: Focuses attention on most important issues
5. **Decision Support**: Helps health coaches make informed decisions
6. **Quality Assurance**: Ensures meal plans meet nutritional guidelines

## Future Enhancements

1. **Machine Learning Integration**: Train models on historical client outcomes
2. **Real-time Analysis**: Update analysis as meal plans are edited
3. **Comparative Analysis**: Compare multiple meal plan options
4. **Trend Analysis**: Track analysis patterns over time
5. **Custom Rules**: Allow health coaches to configure analysis criteria
6. **Export Reports**: Generate PDF reports with analysis results

## Technical Notes

- Analysis runs client-side for instant feedback
- No external API calls required (currently rule-based)
- Extensible architecture for future ML integration
- Type-safe implementation using Dart models
- Responsive UI design for all device sizes

## Permissions

- **View AI Analysis**: Health Coaches only (as per user role system)
- **Nutritionists**: Can view analysis results to understand feedback
- **Clients**: No direct access (internal tool only)
