---
name: gen-doc
description: Use when the user invokes "gen-doc", "/gen-doc", or mentions "generate API docs", "update API documentation", "API changed", "generate OpenAPI", or "sync swagger". Automatically detects REST API changes and generates/updates an OpenAPI 3.0 document.
---

# gen-doc

Detect REST API interface changes and generate or update an `openapi.yaml` file following the OpenAPI 3.0 specification.

## Phase 1: Determine Mode

Read the mode from the invocation argument:

- `/gen-doc` or `/gen-doc diff` → **diff mode**: analyze only files changed in `git diff HEAD`
- `/gen-doc full` → **full mode**: scan the entire codebase for all API definitions

No need to ask the user — proceed immediately based on the argument. Default to diff mode when no argument is given.

For diff mode, run `git diff HEAD` to get the list of modified files.
For full mode, scan all source files using keywords like: `router`, `handler`, `controller`, `endpoint`, `route`, `@GetMapping`, `@PostMapping`, `app.get`, `app.post`, `Route::`.

## Phase 2: Identify API Changes

Use language-agnostic pattern recognition to identify REST interfaces:

**Route/Handler patterns to look for:**
- JavaScript/TypeScript: `router.get/post/put/delete/patch`, `app.get/post/put/delete`, `express.Router`
- Python: `@app.route`, `@router.get/post`, FastAPI/Flask decorators
- Java/Kotlin: `@GetMapping`, `@PostMapping`, `@RequestMapping`, `@RestController`
- Go: `http.HandleFunc`, `r.GET/POST`, gin/echo/fiber route registrations
- PHP: `Route::get/post`, Laravel route definitions
- Ruby: `get/post/put/delete` in routes.rb, Rails resource routes

**For each identified endpoint, extract:**
- HTTP method (GET, POST, PUT, DELETE, PATCH)
- Path (e.g., `/api/v1/users/{id}`)
- Path parameters
- Query parameters
- Request body schema (if present)
- Response body schema (if present)
- Authentication requirements (if visible)

Build a structured list: `{ method, path, params, request_body, responses, summary }`

## Phase 3: Generate or Update openapi.yaml

**Check for existing file:**
- Look for `openapi.yaml` or `openapi.yml` in project root, `docs/`, `api/`, or `src/`
- Also check for `swagger.yaml` / `swagger.yml`

**If file exists — update mode:**
- Parse the existing YAML
- For each changed endpoint: update only the relevant `paths` entry
- For removed endpoints (if detectable from diff): mark as deprecated or remove
- Preserve all hand-written descriptions, examples, and non-changed paths

**If file does not exist — create mode:**
- Initialize using the template at `./templates/openapi_init.yaml`

**OpenAPI 3.0 path entry format:**
- Use `./templates/path_entry.yaml` as the structure reference for each path block

Write the final YAML to the discovered path, or default to `./openapi.yaml` in the project root.

## Phase 4: Verify Documentation Against Code

For each endpoint written in `openapi.yaml`, re-read the corresponding source code and verify:

- **HTTP method**: matches the route definition exactly
- **Path**: matches the registered route string (including path parameters like `{id}`)
- **Path parameters**: every `{param}` in the path has a corresponding parameter entry with correct type
- **Query parameters**: all query params in the handler signature are documented; no extras
- **Request body**: fields, types, and required flags match the actual struct/schema parsed from code
- **Response body**: documented response structure matches what the handler actually returns
- **Auth**: if the route is behind auth middleware, `security` field is present; if public, it is absent

For each discrepancy found, fix it in `openapi.yaml` before proceeding.

If a field cannot be determined from code alone (e.g., deeply nested dynamic response), annotate with `description: "TODO: verify manually"` rather than guessing.

## Phase 5: Summary Output

Report the results:

```
gen-doc complete

File: ./openapi.yaml
Added:    N endpoints
Updated:  N endpoints
Removed:  N endpoints

Preview with:
  npx @redocly/cli preview-docs openapi.yaml
  npx swagger-ui-express  (or any Swagger UI)
```

## Notes

- Do not assume a specific language or framework — use pattern matching
- Preserve manually written descriptions; only update what changed
- If the diff contains no API-related changes, report that and exit
- For ambiguous patterns, prefer to include rather than skip (avoid false negatives)
- Always output valid OpenAPI 3.0 YAML
