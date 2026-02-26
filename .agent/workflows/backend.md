---
description: Backend skills
---

name : Backend handling

description: Helps design, debug, and maintain backend logic, Firebase services, API integration, and data handling. Use only when backend-related changes or fixes are required.
---

# Backend Logic, Firebase & API Integration Skill

This skill focuses on building, debugging, and maintaining backend functionality including Firebase services, external API integrations (such as Gemini API), authentication flows, database operations, and data processing logic.

This skill MUST only operate on backend-related functionality. It must NOT modify UI layout, visual styling, or front-end design unless required to support backend data integration.

The primary goal is to produce stable, scalable, maintainable, and low-bug backend implementation.

---

## When to use this skill

- Use when implementing or debugging Firebase services.
- Use when integrating external APIs such as Gemini API.
- Use when handling authentication and authorization.
- Use when working with database operations (Firestore or Realtime Database).
- Use when handling cloud functions or backend automation.
- Use when fixing data synchronization or storage issues.
- Use when improving backend performance and reliability.
- Use when validating or sanitizing user input data.
- Use when structuring backend architecture or service layers.

---

## When NOT to use this skill

- Do not use when modifying UI layout or visual design.
- Do not use when performing styling or responsiveness changes.
- Do not use when handling purely front-end widget rendering.
- Do not use when creating UI animations or visual enhancements.

---

## How to use it

### Step 1: Identify Backend Issue or Requirement

Determine the backend scope clearly.

Check for:

- Firebase configuration issues
- Authentication failures
- Database read/write errors
- API request failures
- Data inconsistency
- Performance bottlenecks
- Security vulnerabilities
- Incorrect data structure or schema

---

### Step 2: Analyze Root Cause

Investigate backend architecture and service implementation.

Verify:

- Firebase initialization and configuration
- Authentication flow correctness
- Firestore or Realtime Database query structure
- API request formatting and response handling
- Error handling and fallback logic
- Proper async and await usage
- Secure data access and validation
- Rate limiting or quota restrictions

---

### Step 3: Apply Backend Fix or Implementation

#### Firebase Integration

Follow these guidelines:

- Ensure Firebase is initialized properly
- Use structured collections and document hierarchy
- Prevent unnecessary nested data
- Use indexing and optimized queries
- Implement proper security rules
- Avoid excessive read/write operations

Recommended Firebase services:

- Firebase Authentication
- Cloud Firestore or Realtime Database
- Firebase Storage
- Firebase Cloud Functions
- Firebase Messaging if applicable

---

#### API Integration (Gemini API)

Ensure:

- Proper request formatting
- Secure API key storage
- Robust error handling
- Timeout and retry mechanisms
- Response validation before usage
- Efficient API usage to reduce cost and latency

Always sanitize and validate API responses before processing.

---

#### Data Handling & State Safety

- Validate user inputs before database submission
- Use structured models or data classes
- Prevent null or malformed data usage
- Ensure consistent data serialization and deserialization
- Implement caching if necessary for performance

---

#### Error Handling & Stability

- Implement try-catch blocks for all async operations
- Provide meaningful error messages and logging
- Prevent application crashes due to unexpected data
- Implement fallback mechanisms for API or database failure

---

#### Security Best Practices

- Never expose API keys in frontend code
- Use environment variables or secure storage
- Apply Firebase security rules properly
- Validate authentication tokens
- Prevent unauthorized database access
- Sanitize user-generated content

---

### Step 4: Validate Backend Changes

Perform:

- Authentication testing
- Database read and write testing
- API request and response testing
- Error scenario simulation
- Performance testing for large data operations
- Security validation

---

### Step 5: Document Changes

Document:

- Backend issue identified
- Root cause explanation
- Changes implemented
- Security or performance considerations
- Future improvement recommendations

---

## Best Practices & Conventions

- Follow clean architecture or layered service structure
- Separate backend services from UI logic
- Use repository or service pattern for Firebase operations
- Maintain reusable and modular backend code
- Avoid duplicated database queries
- Keep API integrations isolated in service classes
- Use strongly typed data models
- Maintain consistent naming conventions

---

## Firebase Data Design Guidelines

- Use normalized and scalable data structure
- Avoid storing large or redundant data inside single documents
- Use subcollections when necessary
- Optimize database reads and writes
- Implement pagination for large datasets

---

## Gemini API Integration Guidelines

- Always validate AI-generated responses
- Implement fallback logic for failed AI responses
- Avoid excessive API calls
- Log AI interaction for debugging if necessary
- Ensure user data privacy before sending to AI service

---

## Output Expectations

When using this skill, responses should:

1. Clearly identify backend issue or requirement
2. Explain root cause of the issue
3. Provide stable backend solution
4. Ensure Firebase and API usage follows best practices
5. Maintain clean architecture and modular code
6. Avoid modifying UI components unless required for backend integration
