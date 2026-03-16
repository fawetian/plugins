# File Exclusion Rules
Rules for excluding files and directories during source code scanning.
## Exclusion Patterns
When scanning projects for annotation, exclude the following:
### Test Files
```
*_test.*, *_spec.*, test_*.*, *Test.*, *Spec.*
__tests__/, tests/, test/, spec/
```
### Dependencies and Build Directories
```
node_modules/, vendor/, dist/, build/, out/
.next/, .nuxt/, .output/, __pycache__/, .cache/
target/, bin/, obj/, packages/
```
### Configuration Files
```
*.json, *.yaml, *.yml, *.toml, *.ini, *.env*
*.config.js, *.config.ts, *.rc, *.lock
```
### Documentation and Resources
```
*.md, *.mdx, *.txt, *.rst, *.html
assets/, images/, public/, static/, fonts/
*.png, *.jpg, *.jpeg, *.gif, *.svg, *.ico
*.css, *.scss, *.less (unless core styling logic)
```
### Generated Files
```
*.min.js, *.map, *.d.ts, package-lock.json, pnpm-lock.yaml
*.log
```
### Version Control
```
.git/, .svn/, .hg/, .idea/, .vscode/
```
## Rationale
### Why Exclude Tests?
- Tests already have descriptive names and assertions
- Focus on production code for learning purposes
- Reduces scope to manageable size
### Why Exclude Build Artifacts?
- Generated code, not source code
- Large file counts slow down processing
- No value in annotating compiled/bundled output
### Why Exclude Configuration?
- Often self-explanatory or standard formats
- Focus on business logic and algorithms
- Can be documented separately if needed
### Why Exclude Assets?
- Binary files cannot be annotated
- CSS files rarely benefit from code comments
- Images and fonts are not code
## Exceptions
Some configuration files may warrant annotation if they contain:
- Complex deployment configurations
- Custom build scripts with significant logic
- Environment-specific settings that need explanation
When in doubt, include the file and let the annotation agent decide based on content complexity.
