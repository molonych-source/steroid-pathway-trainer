"""Regenerates the logo, the link preview card and the home-screen icon.

Writes assets/logo.svg, assets/logo-512.png, assets/logo-120.png,
preview.png (1200x630 link preview) and icon-180.png (apple-touch icon).
The favicon in index.html and privacy.html is an inline copy of assets/logo.svg;
paste the new SVG there by hand if the logo changes.

Run from the repo root: python3 tools/make_images.py
(needs: pip install playwright; playwright install chromium)
"""
import math, re
from pathlib import Path
from playwright.sync_api import sync_playwright

ROOT = Path(__file__).resolve().parent.parent
TEAL, INK = "#0b6b6b", "#fbfaf7"

# Four-ring steroid nucleus: rings A, B, C (hexagons) and D (pentagon).
s = 1.0; r3 = math.sqrt(3)
def hexa(cx, cy):
    return [(cx + s*math.cos(math.radians(a)), cy + s*math.sin(math.radians(a))) for a in (-90, -30, 30, 90, 150, 210)]
A = hexa(0, 0); B = hexa(r3, 0); C = hexa(1.5*r3, -1.5)
x0 = 1.5*r3 + r3/2; ap = s/(2*math.tan(math.radians(36))); R = s/(2*math.sin(math.radians(36)))
pc = (x0 + ap, -1.5)
D = [(pc[0] + R*math.cos(math.radians(a)), pc[1] + R*math.sin(math.radians(a))) for a in (144, 216, 288, 0, 72)]
pts = [p for poly in (A, B, C, D) for p in poly]
minx = min(p[0] for p in pts); maxx = max(p[0] for p in pts); miny = min(p[1] for p in pts); maxy = max(p[1] for p in pts)
W = 512; pad = 92; sc = min((W-2*pad)/(maxx-minx), (W-2*pad)/(maxy-miny))
ox = (W-(maxx-minx)*sc)/2 - minx*sc; oy = (W-(maxy-miny)*sc)/2 - miny*sc
def path(poly): return "M" + " L".join(f"{x*sc+ox:.1f},{y*sc+oy:.1f}" for x, y in poly) + "Z"
rings = "".join(f'<path d="{path(p)}"/>' for p in (A, B, C, D))
svg = (f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {W} {W}" width="{W}" height="{W}">\n'
       f'<rect width="{W}" height="{W}" fill="{TEAL}"/>\n'
       f'<g fill="none" stroke="{INK}" stroke-width="20" stroke-linejoin="round">\n{rings}\n</g></svg>')
(ROOT/"assets"/"logo.svg").write_text(svg)

def sized(n): return svg.replace(f'width="{W}" height="{W}"', f'width="{n}" height="{n}"')
card = f'''<body style="margin:0;width:1200px;height:630px;background:{TEAL};display:flex;align-items:center;font-family:-apple-system,system-ui,sans-serif;color:{INK}">
<div style="width:420px;height:420px;margin-left:50px;flex:none">{re.sub(r"<rect[^>]*/>", "", sized(420))}</div>
<div style="margin-left:20px;padding-right:60px"><div style="font-size:76px;font-weight:700;line-height:1.05;letter-spacing:-1px">Steroid Pathway Trainer</div>
<div style="font-size:34px;margin-top:26px;opacity:.9;line-height:1.3">A free study game for adrenal steroid pathways and congenital adrenal hyperplasia</div></div></body>'''

with sync_playwright() as p:
    b = p.chromium.launch()
    def shot(html, w, h, out):
        pg = b.new_page(viewport={"width": w, "height": h}); pg.set_content(html); pg.screenshot(path=str(out)); pg.close()
    for n, out in ((512, ROOT/"assets"/"logo-512.png"), (120, ROOT/"assets"/"logo-120.png"), (180, ROOT/"icon-180.png")):
        shot(f'<body style="margin:0">{sized(n)}</body>', n, n, out)
    shot(card, 1200, 630, ROOT/"preview.png")
    b.close()
print("wrote assets/logo.svg, assets/logo-512.png, assets/logo-120.png, preview.png, icon-180.png")
