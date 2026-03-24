---
name: user-story
description: User story creation and management assistant. Use when writing user stories, creating acceptance criteria, or managing product backlog. Triggers: "user story", "write stories", "acceptance criteria", "backlog", "user story mapping".
userInvocable: true
---

# User Story

A workflow for creating and managing user stories following agile best practices.

## Core Philosophy

**INVEST principle**: Good user stories are Independent, Negotiable, Valuable, Estimable, Small, and Testable.

## Constraints

- **ALL output must be in Chinese (中文)**: All user stories must be written in Chinese.
- **Use Mermaid for diagrams**: Story maps and relationship diagrams must use Mermaid syntax.

## User Story Format

```
As a [用户角色]
I want to [完成某个目标]
So that [获得某种价值]
```

## Acceptance Criteria Format

```
Given [前置条件]
When [用户行为]
Then [预期结果]
```

## Story Components

### 1. Story Header
- Story ID
- Epic/Feature reference
- Priority (P0/P1/P2/P3)
- Story points (if estimated)

### 2. Story Body
- User story statement
- Acceptance criteria (Gherkin format)
- Assumptions and constraints

### 3. Supporting Info
- UI/UX mockups
- Technical notes
- Dependencies
- Definition of Done checklist

---

## Workflow

### Step 1: Persona Definition
Define user personas with goals, pain points, and behaviors.

### Step 2: Story Mapping
Create user story map showing user journey and story hierarchy.

### Step 3: Story Writing
Write individual stories following INVEST principles.

### Step 4: Refinement
Add acceptance criteria, estimates, and dependencies.

### Step 5: Prioritization
Order stories by business value and dependencies.

---

## Story Mapping Structure

```
User Activities (Level 1)
    └── User Tasks (Level 2)
            └── User Stories (Level 3)
```

---

## Output

Generate stories in `docs/stories/{epic-name}/` with individual story files and story map.
