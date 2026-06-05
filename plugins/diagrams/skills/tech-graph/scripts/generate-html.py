#!/usr/bin/env python3
"""Generate a standalone HTML technical diagram from fireworks SVG output.

Two modes are supported:

1. Template mode:
   python3 generate-html.py architecture ./out/diagram.html '{"title":"System","nodes":[],"arrows":[]}'

2. SVG wrapper mode:
   python3 generate-html.py --svg ./out/diagram.svg ./out/diagram.html

The output is a single self-contained HTML file with inline CSS, inline SVG, and
small optional controls for zoom/reset/download. No external CDN or runtime is
required.
"""

from __future__ import annotations

import argparse
import html
import importlib.util
import os
import re
import sys
from pathlib import Path
from typing import Optional, Tuple


SCRIPT_DIR = Path(__file__).resolve().parent
GENERATOR_PATH = SCRIPT_DIR / "generate-from-template.py"


def load_template_generator():
    spec = importlib.util.spec_from_file_location("fireworks_template_generator", GENERATOR_PATH)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"cannot load template generator at {GENERATOR_PATH}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


def read_stdin_or_arg(value: Optional[str]) -> str:
    if value is not None:
        return value
    return sys.stdin.read()


def clean_svg(svg: str) -> str:
    svg = re.sub(r"^\s*<\?xml[^>]*>\s*", "", svg)
    svg = re.sub(r"^\s*<!DOCTYPE[^>]*>\s*", "", svg, flags=re.I)
    return svg.strip()


def extract_dimensions(svg: str) -> Tuple[int, int]:
    viewbox = re.search(r'viewBox="[^"]*?([0-9]+(?:\.[0-9]+)?)\s+([0-9]+(?:\.[0-9]+)?)"', svg)
    if viewbox:
        return int(float(viewbox.group(1))), int(float(viewbox.group(2)))
    width = re.search(r'width="([0-9]+(?:\.[0-9]+)?)', svg)
    height = re.search(r'height="([0-9]+(?:\.[0-9]+)?)', svg)
    if width and height:
        return int(float(width.group(1))), int(float(height.group(1)))
    return 960, 600


def infer_title(svg: str, fallback: str) -> str:
    title = re.search(r'<text[^>]*class="title"[^>]*>(.*?)</text>', svg, flags=re.S)
    if title:
        return re.sub(r"<[^>]+>", "", title.group(1)).strip() or fallback
    return fallback


def build_html(
    svg: str,
    title: str,
    *,
    toolbar: bool = True,
    theme: str = "auto",
    download_svg_scale: float = 2.0,
) -> str:
    width, height = extract_dimensions(svg)
    safe_title = html.escape(title, quote=True)
    theme_attr = html.escape(theme, quote=True)
    scale_attr = html.escape(f"{download_svg_scale:g}", quote=True)
    toolbar_markup = ""
    if toolbar:
        toolbar_markup = """
    <div class="toolbar" aria-label="Diagram controls">
      <div class="title" id="diagram-title"></div>
      <div class="controls">
        <button type="button" data-action="zoom-out" title="Zoom out" aria-label="Zoom out">-</button>
        <button type="button" data-action="reset" title="Reset zoom" aria-label="Reset zoom">100%</button>
        <button type="button" data-action="zoom-in" title="Zoom in" aria-label="Zoom in">+</button>
        <button type="button" data-action="download-svg" title="Download SVG" aria-label="Download SVG">SVG</button>
        <button type="button" data-action="download-svg-hd" title="Download high-resolution SVG" aria-label="Download high-resolution SVG">HD SVG</button>
      </div>
    </div>"""

    script = ""
    if toolbar:
        script = """
  <script>
    (() => {
      const root = document.documentElement;
      const stage = document.querySelector('.diagram-stage');
      const svg = stage.querySelector('svg');
      const title = document.getElementById('diagram-title');
      const hdScale = Number.parseFloat(root.dataset.svgScale || '2') || 2;
      let zoom = 1;

      if (title) title.textContent = document.title;
      if (svg) {
        svg.setAttribute('role', 'img');
        svg.setAttribute('aria-label', document.title);
      }

      function setZoom(next) {
        zoom = Math.min(2.5, Math.max(0.4, next));
        root.style.setProperty('--zoom', zoom.toFixed(2));
      }

      function svgBaseSize(svgElement) {
        const viewBox = svgElement.getAttribute('viewBox');
        if (viewBox) {
          const parts = viewBox.trim().split(/\\s+/).map(Number);
          if (parts.length === 4 && parts.every(Number.isFinite)) {
            return { width: parts[2], height: parts[3] };
          }
        }
        const width = Number.parseFloat(svgElement.getAttribute('width'));
        const height = Number.parseFloat(svgElement.getAttribute('height'));
        return {
          width: Number.isFinite(width) ? width : svgElement.getBoundingClientRect().width,
          height: Number.isFinite(height) ? height : svgElement.getBoundingClientRect().height
        };
      }

      function downloadSvg(scale = 1) {
        if (!svg) return;
        const clone = svg.cloneNode(true);
        const size = svgBaseSize(svg);
        if (scale !== 1) {
          clone.setAttribute('width', Math.round(size.width * scale));
          clone.setAttribute('height', Math.round(size.height * scale));
          if (!clone.getAttribute('viewBox')) {
            clone.setAttribute('viewBox', `0 0 ${size.width} ${size.height}`);
          }
        }
        clone.setAttribute('xmlns', 'http://www.w3.org/2000/svg');
        const source = new XMLSerializer().serializeToString(clone);
        const blob = new Blob([source], { type: 'image/svg+xml;charset=utf-8' });
        const url = URL.createObjectURL(blob);
        const link = document.createElement('a');
        link.href = url;
        const suffix = scale === 1 ? '' : `@${scale}x`;
        link.download = (document.title || 'diagram').replace(/[^a-z0-9._-]+/gi, '-').toLowerCase() + suffix + '.svg';
        document.body.appendChild(link);
        link.click();
        link.remove();
        URL.revokeObjectURL(url);
      }

      document.addEventListener('click', (event) => {
        const button = event.target.closest('button[data-action]');
        if (!button) return;
        const action = button.dataset.action;
        if (action === 'zoom-in') setZoom(zoom + 0.1);
        if (action === 'zoom-out') setZoom(zoom - 0.1);
        if (action === 'reset') setZoom(1);
        if (action === 'download-svg') downloadSvg(1);
        if (action === 'download-svg-hd') downloadSvg(hdScale);
      });
    })();
  </script>"""

    return f"""<!doctype html>
<html lang="en" data-theme="{theme_attr}" data-svg-scale="{scale_attr}">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>{safe_title}</title>
  <style>
    :root {{
      color-scheme: light dark;
      --bg: #f8fafc;
      --panel: #ffffff;
      --ink: #0f172a;
      --muted: #64748b;
      --line: #dbe3ef;
      --button: #ffffff;
      --button-hover: #f1f5f9;
      --shadow: 0 18px 45px rgba(15, 23, 42, 0.12);
      --zoom: 1;
    }}

    @media (prefers-color-scheme: dark) {{
      :root:not([data-theme="light"]) {{
        --bg: #0b1020;
        --panel: #101827;
        --ink: #e5edf7;
        --muted: #93a4b8;
        --line: #233047;
        --button: #121c2e;
        --button-hover: #17243a;
        --shadow: 0 22px 55px rgba(0, 0, 0, 0.38);
      }}
    }}

    :root[data-theme="dark"] {{
      --bg: #0b1020;
      --panel: #101827;
      --ink: #e5edf7;
      --muted: #93a4b8;
      --line: #233047;
      --button: #121c2e;
      --button-hover: #17243a;
      --shadow: 0 22px 55px rgba(0, 0, 0, 0.38);
    }}

    * {{ box-sizing: border-box; }}

    body {{
      margin: 0;
      min-height: 100vh;
      background: var(--bg);
      color: var(--ink);
      font-family: Inter, ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
    }}

    .page {{
      min-height: 100vh;
      display: grid;
      grid-template-rows: auto 1fr;
    }}

    .toolbar {{
      position: sticky;
      top: 0;
      z-index: 2;
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 16px;
      padding: 12px 18px;
      background: color-mix(in srgb, var(--panel) 92%, transparent);
      border-bottom: 1px solid var(--line);
      backdrop-filter: blur(14px);
    }}

    .toolbar .title {{
      min-width: 0;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
      font-size: 14px;
      font-weight: 650;
      color: var(--ink);
    }}

    .controls {{
      display: flex;
      align-items: center;
      gap: 6px;
      flex: none;
    }}

    button {{
      min-width: 36px;
      height: 32px;
      padding: 0 10px;
      border: 1px solid var(--line);
      border-radius: 6px;
      background: var(--button);
      color: var(--ink);
      font: inherit;
      font-size: 12px;
      font-weight: 650;
      cursor: pointer;
    }}

    button:hover {{ background: var(--button-hover); }}
    button:focus-visible {{ outline: 2px solid #2563eb; outline-offset: 2px; }}

    .viewport {{
      overflow: auto;
      padding: clamp(16px, 4vw, 44px);
    }}

    .diagram-shell {{
      width: max-content;
      min-width: min(100%, {width}px);
      margin: 0 auto;
      transform: scale(var(--zoom));
      transform-origin: top center;
      transition: transform 140ms ease;
    }}

    .diagram-stage {{
      width: min(calc(100vw - clamp(32px, 8vw, 88px)), {width}px);
      aspect-ratio: {width} / {height};
      min-width: min(100%, 320px);
      border: 1px solid var(--line);
      border-radius: 8px;
      background: var(--panel);
      box-shadow: var(--shadow);
      overflow: hidden;
    }}

    .diagram-stage > svg {{
      display: block;
      width: 100%;
      height: 100%;
    }}

    @media (max-width: 640px) {{
      .toolbar {{
        align-items: stretch;
        flex-direction: column;
      }}

      .controls {{
        justify-content: space-between;
      }}

      button {{
        flex: 1;
      }}
    }}
  </style>
</head>
<body>
  <main class="page">{toolbar_markup}
    <div class="viewport">
      <div class="diagram-shell">
        <div class="diagram-stage">
{svg}
        </div>
      </div>
    </div>
  </main>{script}
</body>
</html>
"""


def write_output(path: Path, content: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content, encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser(description="Generate standalone HTML from fireworks SVG diagrams.")
    parser.add_argument("template_or_output", help="template type, or output HTML path when --svg is used")
    parser.add_argument("output", nargs="?", help="output HTML path in template mode")
    parser.add_argument("data_json", nargs="?", help="diagram JSON; omit to read JSON from stdin")
    parser.add_argument("--svg", help="wrap an existing SVG instead of rendering from a template")
    parser.add_argument("--title", help="HTML document title")
    parser.add_argument("--theme", choices=["auto", "light", "dark"], default="auto")
    parser.add_argument("--no-toolbar", action="store_true", help="omit zoom/download controls")
    parser.add_argument("--download-svg-scale", type=float, default=2.0,
                        help="scale used by the HD SVG download button (default: 2)")
    args = parser.parse_args()

    if args.svg:
        svg_path = Path(args.svg)
        output_path = Path(args.template_or_output)
        svg = clean_svg(svg_path.read_text(encoding="utf-8"))
        title = args.title or infer_title(svg, svg_path.stem)
    else:
        if not args.output:
            parser.error("template mode requires: <template-type> <output.html> [data-json]")
        generator = load_template_generator()
        data_json = read_stdin_or_arg(args.data_json)
        try:
            import json

            data = json.loads(data_json)
        except Exception as exc:  # noqa: BLE001
            raise SystemExit(f"Error: invalid diagram JSON: {exc}") from exc
        svg = clean_svg(generator.build_svg(args.template_or_output, data))
        output_path = Path(args.output)
        title = args.title or str(data.get("title") or output_path.stem)

    if args.download_svg_scale <= 0:
        raise SystemExit("Error: --download-svg-scale must be greater than 0")

    html_doc = build_html(
        svg,
        title,
        toolbar=not args.no_toolbar,
        theme=args.theme,
        download_svg_scale=args.download_svg_scale,
    )
    write_output(output_path, html_doc)
    print(f"HTML generated: {output_path}")


if __name__ == "__main__":
    main()
