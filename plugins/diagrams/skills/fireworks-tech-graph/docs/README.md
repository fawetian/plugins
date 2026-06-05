# Fireworks Tech Graph

Create polished standalone SVG technical diagrams and export them as PNG.

## Use When

- The user wants a styled SVG/PNG technical illustration for documentation, README, slides, technical articles, or architecture explanation.
- The diagram is an architecture graph, data flow, flowchart, sequence diagram, agent/memory diagram, concept map, comparison matrix, timeline, mind map, UML-style class/use-case/state-machine, ERD, or network graph.
- The user wants a specific visual style such as flat icon, dark terminal, blueprint, Notion clean, glassmorphism, Claude-style, OpenAI-style, or dark luxury.

## Prefer Another Skill When

- The user needs an editable draw.io/diagrams.net file, exact vendor shape library, or manual post-editing in draw.io. Use `drawio-skill`.

## Output

The skill writes SVG first, validates XML/SVG syntax, then exports PNG with `cairosvg`, `rsvg-convert`, or Puppeteer when available.

## Source

Integrated from [yizhiyanhua-ai/fireworks-tech-graph](https://github.com/yizhiyanhua-ai/fireworks-tech-graph) under the MIT License.
