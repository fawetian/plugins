# Tech Graph

Create polished standalone HTML technical diagrams.

## Use When

- The user wants a styled standalone HTML technical illustration for documentation, README, slides, technical articles, or architecture explanation.
- The user asks for a browser-openable single-file HTML diagram, web page artifact, or lightweight interactive diagram.
- The diagram is an architecture graph, data flow, flowchart, sequence diagram, agent/memory diagram, concept map, comparison matrix, timeline, mind map, UML-style class/use-case/state-machine, ERD, or network graph.
- The user wants a specific visual style such as flat icon, dark terminal, blueprint, Notion clean, glassmorphism, Claude-style, OpenAI-style, or dark luxury.

## Output

The skill writes SVG as an internal drawing layer, validates XML/SVG syntax, then wraps the SVG into a standalone HTML page with `scripts/generate-html.py`. The generated HTML toolbar can download both the normal SVG and a high-resolution SVG.

HTML examples:

```bash
python3 scripts/generate-html.py architecture ./output/arch.html '{"title":"Architecture","nodes":[],"arrows":[]}'
python3 scripts/generate-html.py --svg ./output/arch.svg ./output/arch.html --title "Architecture"
python3 scripts/generate-html.py architecture ./output/arch.html '{"title":"Architecture","nodes":[],"arrows":[]}' --download-svg-scale 3
```

## Source

Derived from [yizhiyanhua-ai/fireworks-tech-graph](https://github.com/yizhiyanhua-ai/fireworks-tech-graph) under the MIT License, with this plugin exposing only the standalone HTML diagram workflow.
