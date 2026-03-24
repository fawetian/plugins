---
name: prd-writer
description: Professional PRD (Product Requirements Document) writing assistant. Use when creating product requirement documents, feature specifications, or detailed product documentation. Triggers: prd, "product requirement", "write prd", "create prd", "feature spec".
userInvocable: true
---

# PRD Writer

A systematic workflow for writing professional Product Requirements Documents.

## Core Philosophy

**User-centric approach**: Start from user needs, then define solutions. Clear problem statement before solution design.

## Constraints

- **ALL output must be in Chinese (中文)**: All documents must be written in Chinese.
- **Use Mermaid for diagrams**: All flowcharts and system diagrams must use Mermaid syntax.

## PRD Structure

### 1. Document Header
- Document title and version
- Author and stakeholders
- Last updated date
- Status (Draft/Review/Approved)

### 2. Background & Problem Statement
- Market context
- User pain points
- Business opportunity
- Why now?

### 3. Goals & Success Metrics
- Primary objectives
- Key Results (OKRs)
- Success criteria (measurable)

### 4. User Stories & Scenarios
- Target user personas
- User journey maps
- Core user stories with acceptance criteria

### 5. Functional Requirements
- Feature list with priority (P0/P1/P2)
- Detailed specifications
- User flow diagrams
- Edge cases

### 6. Non-functional Requirements
- Performance requirements
- Security requirements
- Scalability requirements
- Compatibility requirements

### 7. Technical Considerations
- Architecture overview
- Dependencies
- Risks and mitigation

### 8. Timeline & Milestones
- Phase breakdown
- Key milestones
- Dependencies

### 9. Open Questions
- Items needing clarification
- Decisions pending

---

## Workflow

### Step 1: Gather Requirements
Interview stakeholders, review existing documentation, analyze competitors.

### Step 2: Create Draft
Use the PRD template, fill in each section systematically.

### Step 3: Review & Iterate
Share with stakeholders, collect feedback, refine.

### Step 4: Finalize
Get approval, publish to team.

---

## Output

Generate `docs/prd/{feature-name}.md` following the standard structure.
