name : debugging

description: Helps test, debug, and validate Flutter applications including Firebase services, API integrations, and application logic. Use only when testing, troubleshooting, or debugging is required.
---

# Flutter, Firebase & API Testing and Debugging Skill

This skill focuses on systematically testing, troubleshooting, and debugging application behavior across frontend interaction, backend services, Firebase integration, and Gemini API communication.

The primary goal is to detect bugs early, maintain application stability, ensure accurate data flow, and prevent production failures.

This skill MUST focus only on testing, debugging, logging, and validation. It must NOT introduce new features or UI redesign unless required to resolve a bug.

---

## When to use this skill

- Use when application crashes or behaves unexpectedly.
- Use when Firebase read/write operations fail.
- Use when authentication or authorization issues occur.
- Use when API responses are incorrect, slow, or failing.
- Use when debugging data inconsistency or synchronization issues.
- Use when validating application logic or workflow correctness.
- Use when performing pre-release stability testing.
- Use when diagnosing performance or latency issues.

---

## When NOT to use this skill

- Do not use when creating new features.
- Do not use when redesigning UI or styling.
- Do not use when restructuring architecture unless debugging requires it.
- Do not use for performance optimization unrelated to bug fixing.

---

## How to use it

### Step 1: Reproduce the Issue

- Identify exact steps that trigger the bug.
- Record expected behavior vs actual behavior.
- Determine if the issue occurs consistently or intermittently.
- Identify environment conditions:
  - Device type
  - Network condition
  - User authentication state
  - Firebase environment (production or test)

---

### Step 2: Categorize the Bug

Determine bug category:

- UI Rendering Bug
- Business Logic Bug
- Firebase Integration Bug
- Authentication Bug
- Database Structure Bug
- API Communication Bug
- Performance or Memory Bug

---

### Step 3: Debugging Process

#### Flutter Debugging

- Check console logs and stack traces.
- Use Flutter Inspector and DevTools.
- Validate widget rebuild behavior.
- Verify state updates and asynchronous operations.
- Check for null safety violations.

---

#### Firebase Debugging

Verify:

- Firebase initialization
- Authentication token validity
- Firestore or Realtime Database queries
- Firebase security rules conflicts
- Cloud Function execution logs
- Data structure correctness

Use Firebase Console and logs to verify backend behavior.

---

#### Gemini API Debugging

Verify:

- API request formatting
- API key validity and security
- Network connectivity
- Response structure and data format
- Timeout or quota limitations
- AI output validation and error fallback handling

---

### Step 4: Apply Fix Safely

Follow debugging best practices:

- Fix root cause instead of temporary workaround
- Maintain backward compatibility
- Avoid introducing new risks or side effects
- Ensure proper error handling is implemented
- Validate data before processing

---

### Step 5: Logging and Monitoring

Implement structured logging:

- Log error conditions clearly
- Log API responses for debugging
- Log authentication state changes
- Log database read/write operations when necessary
- Avoid logging sensitive user data

---

### Step 6: Testing Validation

Perform the following testing types:

#### Functional Testing
- Verify feature behaves according to requirements.
- Confirm correct data processing and storage.

#### Integration Testing
- Verify Firebase and API services communicate properly.
- Validate end-to-end workflow functionality.

#### Edge Case Testing
- Test invalid user input.
- Test network failure scenarios.
- Test API timeout or failure response.
- Test unauthorized access attempts.

#### Performance Testing
- Test large data operations.
- Monitor API latency.
- Verify database query efficiency.

---

### Step 7: Regression Testing

- Ensure bug fixes do not break existing features.
- Re-test related modules after applying fix.
- Confirm UI and backend consistency remains intact.

---

### Step 8: Document Debugging Results

Document:

- Bug description
- Steps to reproduce
- Root cause analysis
- Fix applied
- Testing performed
- Remaining known limitations (if any)

---

## Debugging Best Practices

- Always reproduce bug before attempting fix.
- Avoid guessing solutions without evidence.
- Use structured error handling for async operations.
- Keep logs readable and meaningful.
- Maintain clean separation between UI, logic, and services.
- Test in both development and staging environments when possible.

---

## Stability and Safety Guidelines

- Validate all external data before usage.
- Implement fallback behavior for API failures.
- Prevent application crashes due to null or unexpected values.
- Ensure Firebase queries are optimized and secure.
- Avoid excessive API or database calls.

---

## Output Expectations

When using this skill, responses should:

1. Identify and classify the bug clearly
2. Explain reproduction steps
3. Provide root cause analysis
4. Suggest stable and safe fixes
5. Include testing and validation steps
6. Avoid introducing new unrelated features
