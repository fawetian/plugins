---
name: requirement-analysis
description: Systematic requirement analysis and validation. Use when analyzing user needs, validating product ideas, or breaking down complex requirements. Triggers: "analyze requirements", "requirement analysis", "validate requirements", "break down requirements".
userInvocable: true
---

# Requirement Analysis

A systematic approach to analyze, validate, and break down product requirements.

## Core Philosophy

**First principles thinking**: Understand the root cause before proposing solutions. Ask "why" five times.

## Constraints

- **ALL output must be in Chinese (中文)**: All analysis documents must be written in Chinese.
- **Use Mermaid for diagrams**: All relationship and flow diagrams must use Mermaid syntax.

## Analysis Framework

### 1. Problem Discovery
- What is the core problem?
- Who has this problem?
- How are they solving it today?
- What is the impact of this problem?

### 2. Stakeholder Mapping
- Who are the stakeholders?
- What are their interests?
- How do they influence the product?

### 3. Requirement Classification
- **Functional**: What the system must do
- **Non-functional**: How the system must perform
- **Business**: Business rules and constraints
- **User**: User expectations and preferences

### 4. Priority Matrix
| Criteria | Weight | Score | Weighted |
|----------|--------|-------|----------|
| Business value | | | |
| User impact | | | |
| Technical feasibility | | | |
| Cost | | | |

### 5. Risk Assessment
- Technical risks
- Business risks
- Timeline risks
- Resource risks

---

## Workflow

### Step 1: Collect
Gather requirements from all sources (interviews, documents, analytics).

### Step 2: Clarify
Ask clarifying questions, resolve ambiguities, define scope.

### Step 3: Validate
Cross-check with stakeholders, verify against business goals.

### Step 4: Document
Create requirement specification document.

### Step 5: Prioritize
Use MoSCoW (Must/Should/Could/Won't) or RICE scoring.

---

## Output

Generate `docs/requirements/{feature-name}-analysis.md` with complete analysis.
