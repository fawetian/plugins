# Architecture Overview

## Project Overview

**What is it**: [What this project is, explain in one sentence]
**Why does it exist**: [What problem does it solve? Without it, how would developers/users handle this problem?]
**Core design philosophy**: [What is the most critical design decision in the entire project]

---

## Module Breakdown

Each module is explained with the following structure:

### [Module Name]

**What is it**: [What is the responsibility of this module/directory, one sentence]
**Why does it exist**: [Why separate this part out? What would happen if its logic was stuffed into other modules?]
**Main files**: [List core files and their specific responsibilities]

---

## Module Dependencies

```mermaid
graph TD
    [Use Mermaid to draw dependencies between modules]
```

---

## Core Abstractions

[List the most important interfaces/classes/types in the project, explain why they are core - usually the most referenced or defining system boundaries]

---

## Extension Mechanisms

**What is it**: [What extension points does the project provide - plugins, middleware, hooks, interfaces, etc.]
**Why designed this way**: [Why choose this extension method over others]
