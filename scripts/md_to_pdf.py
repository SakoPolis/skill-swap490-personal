#!/usr/bin/env python3
"""Simple Markdown to PDF converter using reportlab.

This converter does a basic, readable conversion (strips most Markdown
syntax and preserves headings and code blocks as plain text). It is
intended for quick assignment exports; for full fidelity use pandoc/weasyprint.
"""

from __future__ import annotations
import sys
import re
from pathlib import Path
from reportlab.lib.pagesizes import letter
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import inch


def md_to_paragraphs(text: str):
    # Remove code fences but keep their content
    text = re.sub(r"```[\s\S]*?```", lambda m: m.group(0).replace('```', ''), text)
    lines = text.splitlines()
    paras = []
    buf = []
    for line in lines:
        if line.strip() == '':
            if buf:
                paras.append('\n'.join(buf))
                buf = []
            else:
                continue
        else:
            # convert headings
            if line.startswith('#'):
                if buf:
                    paras.append('\n'.join(buf))
                    buf = []
                paras.append(line)
            else:
                buf.append(line)
    if buf:
        paras.append('\n'.join(buf))
    return paras


def render(md_path: Path, out_path: Path) -> None:
    text = md_path.read_text(encoding='utf-8')
    paras = md_to_paragraphs(text)

    doc = SimpleDocTemplate(str(out_path), pagesize=letter,
                            rightMargin=72, leftMargin=72,
                            topMargin=72, bottomMargin=72)
    styles = getSampleStyleSheet()
    style_h = ParagraphStyle('Heading', parent=styles['Heading1'], spaceAfter=6)
    style_p = ParagraphStyle('Body', parent=styles['Normal'], spaceAfter=6)
    story = []
    for p in paras:
        p = p.strip()
        if not p:
            continue
        if p.startswith('#'):
            # count hashes
            level = len(p) - len(p.lstrip('#'))
            text = p.lstrip('#').strip()
            # map to heading size by level (simplified)
            story.append(Paragraph(text, style_h))
        else:
            # escape special XML chars
            safe = p.replace('&', '&amp;').replace('<', '&lt;').replace('>', '&gt;')
            # collapse multiple spaces
            safe = re.sub(r'\s+', ' ', safe)
            story.append(Paragraph(safe, style_p))
        story.append(Spacer(1, 6))

    doc.build(story)


def main(argv=None):
    argv = argv or sys.argv[1:]
    if len(argv) < 2:
        print('Usage: md_to_pdf.py <input.md> <output.pdf>')
        return 2
    md = Path(argv[0])
    out = Path(argv[1])
    if not md.exists():
        print('Input file not found:', md)
        return 3
    render(md, out)
    print('Wrote PDF:', out)
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
