# Draw.io Skill

Create editable `.drawio` diagrams and export them through the native draw.io desktop CLI.

## Use When

- The user asks for draw.io, diagrams.net, editable diagram files, or `.drawio` XML.
- The diagram needs vendor-rich shapes, exact AWS/Azure/GCP/Cisco/Kubernetes icons, swimlanes, UML, ERD, sequence diagrams, ML model figures, or network topology.
- The final output should remain editable in draw.io after PNG/SVG/PDF export.

## Prefer Another Skill When

- The user wants a polished standalone SVG/PNG technical illustration and does not need draw.io editability. Use `fireworks-tech-graph`.
- The user wants diagrams-as-code for Markdown rendering. Use Mermaid or PlantUML if available.

## Requirements

PNG/SVG/PDF/JPG export requires the draw.io desktop CLI (`drawio` or `draw.io`) on PATH. If the CLI is unavailable or blocked by a sandbox, the skill can still produce `.drawio` XML or a diagrams.net browser URL.

## Source

Integrated from [Agents365-ai/drawio-skill](https://github.com/Agents365-ai/drawio-skill) under the MIT License.
