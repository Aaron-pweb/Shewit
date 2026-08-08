# Flutter E-Commerce Challenge — Design & Software Architecture Specification

## Role

Act as a **Senior Flutter Software Architect, Mobile UI/UX Designer, and Technical Product Designer**.

You are designing and architecting a production-quality Flutter e-commerce mobile application built around the **Fake Store API**.

The goal is not merely to make an app that satisfies the functional requirements. The project will be evaluated heavily on:

- Code quality
- Architecture
- State management
- UI/UX quality
- Responsiveness
- Error handling
- Edge cases
- Maintainability
- Local persistence
- API integration
- Project organization
- Git workflow

Your job is to produce a **complete implementation blueprint** that another Flutter developer or AI coding agent can follow without having to make major architectural or design decisions themselves.

Do **not** write the Flutter implementation yet.

Instead, create a detailed specification covering:

1. Product definition
2. User experience
3. Complete screen structure
4. UI design system
5. Navigation architecture
6. API architecture
7. State management architecture
8. Local persistence architecture
9. Data models
10. Repository/service architecture
11. Folder structure
12. Error/loading/empty states
13. Authentication flow
14. Cart architecture
15. Responsive behavior
16. Security considerations
17. Testing strategy
18. Git workflow
19. Development phases
20. Acceptance criteria

---

# 1. Project Context

The application is a Flutter-based e-commerce mobile application using the Fake Store API.

API:

[https://fakestoreapi.com](https://fakestoreapi.com)

Documentation:

[https://medium.com/@okonidorenyin73/demo-store-api-documentation-a-sample-rest-api-for-e-commerce-applications-4b99d7f55f2b](https://medium.com/@okonidorenyin73/demo-store-api-documentation-a-sample-rest-api-for-e-commerce-applications-4b99d7f55f2b)

The application must support:

- User login
- Product listing
- Product details
- Categories
- Category filtering
- Product search
- Shopping cart
- Cart quantity management
- Persistent cart
- User profile
- Persistent login session
- Loading states
- Empty states
- Error states
- Responsive layouts
- State management
- Clean architecture
- Local storage
- Git-based development

---

# 2. Important Architectural Constraint

Use **Flutter** and select one state-management solution:

- Riverpod
- Bloc
- Provider

Choose the solution you believe is most appropriate for this project.

Do not simply say that multiple solutions are possible.

Select **ONE**, explain why it is the best choice, and design the entire architecture consistently around it.

Prefer an architecture that is:

- Easy to understand
- Scalable
- Testable
- Modular
- Maintainable
- Appropriate for a medium-sized Flutter application

Avoid unnecessary enterprise-level complexity.

---

# 3. First Analyze the API

Before designing the application architecture, analyze the Fake Store API.

Identify:

- Available endpoints
- HTTP methods
- Request structures
- Response structures
- Authentication mechanism
- Product fields
- Category information
- User fields
- Cart fields
- Login response
- Error behavior
- Limitations of the API
- Data relationships
- What must be handled locally because the API does not provide sufficient functionality

Create a table similar to:

| Feature | Endpoint | Method | Request | Response | Local Handling Required |
| ------- | -------- | ------ | ------- | -------- | ----------------------- |

Clearly distinguish between:

### Server state

Data coming from the API, such as:

- Products
- Categories
- User information
- Authentication response

### Local/client state

Data that should be managed locally, such as:

- Cart
- Cart quantities
- Authentication session/token
- Search state
- Selected category
- UI state

Explain exactly why each piece belongs where it does.

---

# 4. Product Vision

Define the application's overall product experience.

Describe:

- Target user
- Primary use case
- Main user journey
- Design personality
- UX principles
- Navigation philosophy
- Visual hierarchy
- Interaction philosophy

The app should feel like a **real modern e-commerce application**, not a basic API demo.

Avoid making it visually overloaded.

Prioritize:

- Clean layouts
- Clear hierarchy
- Good spacing
- Strong typography
- Intuitive navigation
- Fast interactions
- Useful feedback
- Consistent components

---

# 5. Application Navigation

Design the complete navigation structure.

Determine whether the application should use:

- Bottom navigation
- Navigation drawer
- Tabs
- Nested navigation
- Modal routes
- Full-screen routes

Create a navigation map such as:

```text
App
│
├── Splash
│
├── Authentication
│   └── Login
│
└── Main Application
    │
    ├── Home
    │   ├── Categories
    │   ├── Product Search
    │   └── Product Details
    │
    ├── Categories
    │   ├── Category Products
    │   └── Product Details
    │
    ├── Cart
    │   └── Product Details
    │
    └── Profile
        └── Logout
```

Adjust this structure if you believe another navigation model provides a better UX.

For every route define:

- Route name
- Purpose
- Entry points
- Exit behavior
- Required data
- Authentication requirements
- State dependencies

---

# 6. Screen-by-Screen UI/UX Specification

Create a detailed specification for **every screen**.

At minimum include:

## Splash / App Initialization

Define:

- Layout
- Branding
- Animation
- Duration
- Session checking
- Loading behavior
- Navigation decision

Explain what happens if:

- User is logged in
- User is logged out
- Local storage cannot be accessed
- Network is unavailable

---

## Login Screen

Define:

- Layout
- Logo/branding
- Email/username field
- Password field
- Password visibility
- Login button
- Loading state
- Validation
- API error handling
- Keyboard behavior
- Accessibility
- Responsive layout

Explain the complete login flow.

For example:

```text
User enters credentials
        ↓
Client-side validation
        ↓
Login API request
        ↓
Loading state
        ↓
Success ─────→ Store session ─────→ Main app
        │
        └── Failure ─────→ Error feedback
```

---

## Home Screen

Design the main shopping experience.

Include:

- App bar
- Greeting/profile shortcut if appropriate
- Search
- Categories
- Featured products
- Product grid/list
- Cart shortcut
- Refresh
- Loading state
- Empty state
- Error state

Explain how products should be visually displayed.

---

## Search

Design:

- Search entry point
- Search field
- Search behavior
- Search filtering
- Debouncing if applicable
- Case sensitivity
- Search result layout
- No-results state
- Clear-search behavior
- Loading behavior

Explain whether search should happen:

- Locally
- Through the API
- Or through a hybrid approach

Choose one based on the actual Fake Store API capabilities.

---

## Categories

Design:

- Category selector
- Category cards/chips
- Category products
- Active category state
- Loading state
- Error state
- Empty state

Include the transition between:

```text
All Products
      ↓
Category
      ↓
Filtered Product Results
```

---

## Product Details

Include:

- Product image
- Title
- Rating
- Review count if available
- Price
- Category
- Description
- Quantity selector
- Add-to-cart button
- Cart feedback
- Back navigation

Define behavior when:

- Product image fails
- Product no longer exists
- API request fails
- Product is already in cart
- User changes quantity

---

# 7. Shopping Cart UX

Design the complete cart experience.

The cart should support:

- Add product
- Remove product
- Increase quantity
- Decrease quantity
- Remove all
- Persistent storage
- Total calculation
- Empty cart state

Define the cart layout.

For example:

```text
Cart
────────────────────────

Product
Image | Name
      | Price
      | [-] 2 [+]

────────────────────────

Subtotal
$XX.XX

Total items
X

[ Checkout ]
```

There is no requirement to implement real payment processing.

If you include checkout, clearly identify it as a UI-only flow.

Define:

- Cart item model
- Quantity rules
- Price calculation
- Persistence
- Synchronization
- Recovery from corrupted local data

---

# 8. Profile Screen

Design the user profile.

Use the Users endpoint.

Include:

- Avatar
- Name
- Username
- Email
- Phone if available
- Address if available
- Logout
- Session information if appropriate

Handle:

- Loading
- API errors
- Missing fields
- Logout failure
- Offline behavior

---

# 9. UI Design System

Create a complete design system.

Define:

## Colors

Specify:

- Primary
- Secondary
- Background
- Surface
- Text primary
- Text secondary
- Border
- Error
- Success
- Warning

Provide both:

- Light theme
- Dark theme

Do not randomly choose colors.

Explain why the palette fits an e-commerce application.

---

## Typography

Define:

- Font family
- Display
- Headline
- Title
- Body
- Caption
- Button

Specify:

- Font size
- Weight
- Line height

---

## Spacing

Create a spacing scale.

For example:

```text
4
8
12
16
20
24
32
40
48
```

Explain where each level should be used.

---

## Border Radius

Define consistent values for:

- Buttons
- Cards
- Inputs
- Images
- Bottom sheets
- Dialogs

---

## Shadows / Elevation

Define how elevation should be used without making the UI visually heavy.

---

# 10. Reusable UI Components

Create a component inventory.

Examples:

```text
AppButton
AppTextField
ProductCard
ProductGrid
CategoryChip
CategoryCard
CartItem
QuantitySelector
PriceText
RatingWidget
LoadingIndicator
ErrorView
EmptyState
ProductImage
AppBar
BottomNavigationBar
```

For each component define:

- Purpose
- Inputs
- States
- Variations
- Reusability requirements

Avoid duplicating UI logic across screens.

---

# 11. State Management Architecture

Use the selected state management solution consistently.

Define the state architecture.

Separate:

### UI state

Examples:

- Loading
- Selected category
- Search query
- Current screen state

### Server state

Examples:

- Products
- Categories
- User

### Persistent client state

Examples:

- Cart
- Authentication session

Create a dependency flow such as:

```text
UI
 ↓
Provider / Controller
 ↓
Repository
 ↓
Data Source
 ↓
API / Local Storage
```

Explain responsibilities at every layer.

Do not allow widgets to directly call HTTP APIs.

---

# 12. Clean Architecture

Use a clean but practical architecture.

Recommended conceptual structure:

```text
Presentation
    ↓
Domain
    ↓
Data
```

Explain each layer.

### Presentation

Contains:

- Screens
- Widgets
- Controllers
- Providers
- UI state

### Domain

Contains:

- Entities
- Repository contracts
- Business logic
- Use cases where justified

### Data

Contains:

- Models
- API services
- Local storage
- Repository implementations
- DTO mapping

Explain where each responsibility belongs.

---

# 13. Folder Structure

Create the complete recommended Flutter folder structure.

For example:

```text
lib/
├── core/
│   ├── constants/
│   ├── errors/
│   ├── network/
│   ├── storage/
│   ├── theme/
│   ├── utils/
│   └── widgets/
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── products/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── categories/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── cart/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   └── profile/
│       ├── data/
│       ├── domain/
│       └── presentation/
│
└── main.dart
```

Modify it if necessary.

For every directory explain:

- Why it exists
- What belongs there
- What must NOT belong there

---

# 14. Data Models

Define the application's models.

At minimum analyze:

### Product

Potential fields:

```text
id
title
price
description
category
image
rating
```

### Rating

```text
rate
count
```

### User

Analyze the actual API response and define the correct model.

### Cart

Define whether the API cart model should be reused or whether a separate local cart model is better.

### Authentication Session

Define what must be stored locally.

For every model specify:

- API representation
- Domain representation
- Local representation
- Serialization/deserialization
- Nullability
- Validation

---

# 15. API Layer

Design the networking architecture.

Define:

- HTTP client
- Base URL
- Endpoints
- Request methods
- Headers
- Timeout
- Error mapping
- JSON parsing
- Response validation

Decide whether to use:

- `http`
- Dio
- another appropriate Flutter networking package

Select one and explain why.

Create an endpoint table.

---

# 16. Local Storage

Select an appropriate local storage solution.

Possible options:

- SharedPreferences
- Hive
- Isar
- SQLite
- Secure storage

Do not use one technology for everything automatically.

Explain what should be stored where.

At minimum:

```text
Authentication/session
Cart
```

Define:

- Storage keys
- Serialization
- Initialization
- Read
- Write
- Delete
- Corrupted-data handling
- Versioning considerations

For authentication credentials/tokens, explain the security implications and select an appropriate approach.

---

# 17. Authentication Architecture

Document the complete authentication lifecycle.

Example:

```text
App Start
   ↓
Read local session
   ↓
Session exists?
   ├── No → Login
   │
   └── Yes
        ↓
   Restore session
        ↓
   Main Application
```

Also define:

```text
Login
 ↓
Validate credentials
 ↓
POST /auth/login
 ↓
Receive token
 ↓
Persist token/session
 ↓
Update auth state
 ↓
Navigate to application
```

Define logout:

```text
Logout
 ↓
Clear local session
 ↓
Reset user state
 ↓
Reset protected state if necessary
 ↓
Navigate to login
```

Handle expired/invalid authentication.

---

# 18. Error Handling

Create a consistent error architecture.

Differentiate:

- Network error
- Timeout
- HTTP error
- Authentication error
- Parsing error
- Local storage error
- Unknown error

Create user-friendly messages.

Never expose raw exceptions directly to users.

Define reusable error states.

---

# 19. Loading States

Do not simply use a generic spinner everywhere.

Define appropriate loading UX for:

- App initialization
- Login
- Product list
- Categories
- Product details
- Profile
- Cart operations

Consider:

- Skeleton loaders
- Shimmer
- Progress indicators
- Button loading states

Use loading indicators that preserve layout stability.

---

# 20. Empty States

Define dedicated empty states for:

- Empty cart
- No search results
- No category products
- No products
- Missing profile data

Each should contain:

- Icon/illustration
- Short explanation
- Appropriate action where useful

---

# 21. Offline and Failure Behavior

Even though the Fake Store API is online, design graceful failure behavior.

Define what happens when:

- Device has no internet
- API is unavailable
- Request times out
- Local storage fails
- Product data is malformed
- Image URL fails
- User profile cannot load

The cart should remain usable even if the API is unavailable because it is stored locally.

---

# 22. Responsive Design

The app must work across different mobile screen sizes.

Define responsive behavior for:

- Small phones
- Standard phones
- Large phones
- Tablets

Define:

- Grid column counts
- Padding
- Product card sizes
- Typography adjustments
- Navigation changes
- Image aspect ratios

Avoid hardcoded screen dimensions.

Use:

- LayoutBuilder
- MediaQuery
- Flexible
- Expanded
- Slivers
- Responsive breakpoints

where appropriate.

---

# 23. Accessibility

Include accessibility requirements.

Cover:

- Semantic labels
- Touch target sizes
- Color contrast
- Text scaling
- Screen readers
- Keyboard navigation where applicable
- Error messaging
- Focus behavior

---

# 24. Performance

Define performance considerations.

Cover:

- Image caching
- Lazy loading
- List/grid rendering
- Avoiding unnecessary rebuilds
- Provider optimization
- JSON parsing
- Local storage access
- Network request duplication

Explain how to prevent:

- Rebuilding the entire product grid unnecessarily
- Repeated API requests
- Excessive local storage reads
- Large widget trees

---

# 25. Testing Architecture

Create a testing strategy.

Include:

### Unit tests

Test:

- Models
- Parsers
- Repositories
- Cart calculations
- Authentication logic
- Search logic

### Widget tests

Test:

- Login
- Product cards
- Cart
- Quantity controls
- Empty states
- Error states

### Integration tests

Test:

```text
Login
 ↓
Browse products
 ↓
Open product
 ↓
Add to cart
 ↓
Change quantity
 ↓
Restart app
 ↓
Verify cart persistence
```

Define important test cases and edge cases.

---

# 26. Edge Cases

Create a comprehensive edge-case checklist.

At minimum consider:

- Empty API response
- Duplicate cart items
- Quantity reaches zero
- Very long product titles
- Very long descriptions
- Missing product image
- Invalid image URL
- Missing rating
- Price with decimals
- Network timeout
- API server failure
- Invalid login
- Missing user data
- Corrupted local storage
- App restart
- Very small screen
- Tablet screen
- Dark mode
- Large text accessibility setting

Add any other important cases you identify.

---

# 27. Git Strategy

Design a professional Git workflow.

The repository should contain meaningful commits.

Do NOT recommend vague commits such as:

```text
update
changes
fix
stuff
final
```

Instead recommend commits such as:

```text
chore: initialize Flutter project
feat: add API client
feat: implement product repository
feat: add product listing screen
feat: implement product details
feat: add category filtering
feat: implement authentication flow
feat: add persistent cart
feat: add profile screen
feat: add loading and error states
test: add cart unit tests
refactor: improve product state management
style: refine product card layout
```

Create a suggested commit sequence for the entire project.

---

# 28. Development Phases

Break the project into implementation phases.

Example:

### Phase 1 — Project Foundation

- Flutter setup
- Dependencies
- Folder structure
- Theme
- Routing
- Core utilities

### Phase 2 — API

- HTTP client
- Models
- API services
- Repositories

### Phase 3 — Authentication

- Login
- Session persistence
- Auth state

### Phase 4 — Products

- Product listing
- Product details
- Categories
- Search

### Phase 5 — Cart

- Cart state
- Quantity management
- Persistence

### Phase 6 — Profile

- User API
- Profile UI
- Logout

### Phase 7 — UX Polish

- Loading
- Errors
- Empty states
- Animations
- Responsive design

### Phase 8 — Testing

- Unit tests
- Widget tests
- Integration tests

### Phase 9 — Final Review

- Architecture review
- Performance
- Accessibility
- Code cleanup
- Git cleanup

Expand each phase with exact implementation tasks.

---

# 29. Animation and Interaction Design

Define subtle animations.

Include recommendations for:

- Splash animation
- Screen transitions
- Product card interaction
- Add-to-cart feedback
- Quantity changes
- Cart badge updates
- Search interaction
- Error appearance
- Loading transitions
- Bottom navigation transitions

Animations must improve UX rather than become distracting.

Specify:

- Duration
- Curve
- Trigger
- Expected behavior

Avoid excessive animations.

---

# 30. UX Edge-Case Rules

Define exact UX behavior for common situations.

For example:

### Adding an existing product

Should the application:

```text
Increase existing quantity
```

rather than creating another cart item?

Choose the correct behavior.

### Removing an item

Should it:

```text
Immediately remove
```

or require confirmation?

Choose based on good mobile UX.

### Network failure

Should the application:

```text
Show cached data + retry
```

when possible?

Define the behavior.

---

# 31. Architecture Diagram

Create a clear architecture diagram similar to:

```text
                 Flutter UI
                     │
                     ▼
          Presentation Layer
                     │
          State Management
                     │
                     ▼
             Domain Layer
                     │
              Repositories
                     │
                     ▼
               Data Layer
              /           \
             /             \
            ▼               ▼
       REST API         Local Storage
            │               │
            ▼               ▼
       Fake Store API   Cart / Session
```

Explain every arrow.

---

# 32. Dependency Recommendations

Provide the recommended Flutter packages.

For every package include:

| Package | Purpose | Why |
| ------- | ------- | --- |

Only recommend packages that provide meaningful value.

Avoid unnecessary dependencies.

---

# 33. Design Tokens

Create a reusable design-token specification.

Example:

```text
Colors
Typography
Spacing
Radius
Elevation
Animation durations
Breakpoints
Icon sizes
Button heights
Input heights
```

These should later be translated into Flutter theme/constants.

---

# 34. Final Project Blueprint

At the end provide a consolidated blueprint containing:

## Technology Stack

```text
Flutter
Dart
State Management: ______
Networking: ______
Local Storage: ______
Routing: ______
Testing: ______
```

## Architecture

```text
Presentation
Domain
Data
```

## Main Features

```text
Authentication
Products
Categories
Search
Cart
Profile
Persistence
```

## Main Screens

List every screen.

## Main Models

List every model.

## Main Providers/Controllers

List every state-management component.

## Main Repositories

List every repository.

## Main Data Sources

List every remote/local data source.

---

# 35. Acceptance Criteria

Create a detailed acceptance checklist.

The application should not be considered complete until:

### Authentication

- [ ] User can log in
- [ ] Invalid credentials are handled
- [ ] Session persists
- [ ] Logout works
- [ ] Authentication state is restored on restart

### Products

- [ ] Products load
- [ ] Product cards work
- [ ] Product details work
- [ ] Categories work
- [ ] Search works

### Cart

- [ ] Products can be added
- [ ] Quantities can change
- [ ] Products can be removed
- [ ] Total updates correctly
- [ ] Cart persists after restart

### Profile

- [ ] User information loads
- [ ] Missing fields are handled
- [ ] Logout works

### UX

- [ ] Loading states exist
- [ ] Empty states exist
- [ ] Error states exist
- [ ] UI works on different screen sizes
- [ ] Dark/light themes are consistent
- [ ] Accessibility has been considered

### Architecture

- [ ] UI does not directly call APIs
- [ ] State management is centralized
- [ ] Repositories abstract data sources
- [ ] Models are separated appropriately
- [ ] Local persistence is abstracted
- [ ] Code is modular
- [ ] Tests exist for important logic

---

# 36. Important Instructions to the Agent

Do NOT produce a generic Flutter tutorial.

Do NOT simply repeat the challenge requirements.

Do NOT jump directly into writing code.

Do NOT leave major architectural decisions unresolved.

For every important decision:

1. State the decision.
2. Explain why.
3. Explain alternatives briefly.
4. Explain how the decision affects implementation.

When the Fake Store API has limitations, explicitly identify them and design a sensible client-side solution.

Prioritize **simple, professional architecture** over unnecessary abstraction.

The final result should be detailed enough that a developer can open the document and begin implementation feature-by-feature without needing to redesign the application architecture.

The final output should be organized as a professional technical design document with:

- Clear headings
- Tables
- Diagrams
- Data-flow diagrams
- Navigation diagrams
- Folder trees
- State-flow diagrams
- API tables
- Component inventories
- Acceptance checklists

End with a section titled:

# Recommended Implementation Order

Provide the exact order in which the Flutter developer should implement the application, from the first file created to the final testing/review stage.
