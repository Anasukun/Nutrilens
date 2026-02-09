name: uidesign

description: Helps debug, improve, and modify Flutter UI elements including widget layout, visual consistency, and responsiveness. Use only when UI-related changes or fixes are required.
---

# Flutter UI Debugging & Responsiveness Skill

This skill focuses strictly on identifying, fixing, and improving User Interface (UI) issues in Flutter applications. It ensures widgets render correctly, maintain design consistency, and adapt properly across different screen sizes and devices.

This skill MUST only operate on UI components such as widgets, layout structure, styling, and responsiveness. It must NOT modify backend logic, services, state management logic, database structure, or API functionality unless it directly affects UI rendering.

---

## When to use this skill

- Use when Flutter UI widgets appear broken or misaligned.
- Use when layout spacing, padding, or positioning is incorrect.
- Use when design or visual improvements are requested.
- Use when UI needs to support multiple screen sizes.
- Use when widgets overflow or cause rendering errors.
- Use when accessibility or usability improvements are required.
- Use when updating theme, typography, color, or styling consistency.

---

## When NOT to use this skill

- Do not use when modifying backend logic or services.
- Do not use when changing application business logic.
- Do not use when creating new non-UI features.
- Do not use when debugging API or database issues unrelated to UI.
- Do not modify state management logic unless it directly affects UI rendering.

---

## How to use it

### Step 1: Identify UI Issues

Inspect Flutter widget structure and layout behavior.

Check for:

- Widget overflow errors (RenderFlex overflow, layout exceptions)
- Misaligned UI components
- Incorrect spacing or padding
- Improper widget hierarchy
- Theme or styling inconsistency
- Responsiveness issues across screen sizes

Use Flutter debugging tools such as:

- Flutter Inspector
- Debug Paint
- Layout Explorer

---

### Step 2: Analyze Root Cause

Review widget tree structure and layout constraints.

Check for:

- Improper use of `Expanded`, `Flexible`, or `SizedBox`
- Incorrect `Row`, `Column`, or `Stack` layout usage
- Missing responsive layout handling
- Hardcoded width or height values
- Theme or style conflicts
- MediaQuery or LayoutBuilder misuse

---

### Step 3: Apply UI Fix or Improvement

#### Layout & Widget Structure

- Maintain clean and readable widget hierarchy
- Replace hardcoded sizes with flexible layouts
- Use `Expanded` or `Flexible` to prevent overflow
- Use `Padding`, `Margin`, and alignment consistently
- Avoid deeply nested widget trees when possible

---

#### Responsiveness

Ensure UI works across:

- Mobile phones
- Tablets
- Different screen orientations

Recommended Flutter tools:

- `MediaQuery`
- `LayoutBuilder`
- `Flexible` and `Expanded`
- Responsive design packages if applicable

Avoid fixed pixel dimensions unless necessary.

---

#### Visual Design Consistency

- Follow application theme using `ThemeData`
- Maintain consistent color palette and typography
- Ensure spacing follows design system guidelines
- Reuse custom widgets to maintain consistency

---

#### Accessibility & Usability

- Ensure text readability and sufficient contrast
- Maintain accessible touch target sizes
- Provide semantic labels for accessibility
- Ensure smooth and intuitive user interaction

---

### Step 4: Validate UI Changes

- Test across multiple device screen sizes
- Test portrait and landscape orientation
- Verify no new layout overflow occurs
- Confirm UI matches design expectations
- Ensure UI changes do not break interaction behavior

---

### Step 5: Document Changes

Document:

- UI issue discovered
- Root cause explanation
- Changes applied
- Recommended UI improvements if necessary

---

## Best Practices & Conventions

- Follow Flutter widget composition best practices
- Prefer reusable widgets over duplicated UI code
- Maintain separation between UI and logic
- Use responsive design as default approach
- Avoid unnecessary widget rebuilds
- Follow Material or Cupertino design consistency based on app style

---

## Output Expectations

When using this skill, responses should:

1. Identify the UI issue clearly
2. Explain the cause of the issue
3. Provide Flutter-based UI solution
4. Ensure responsiveness is preserved
5. Avoid modifying non-UI application logic
