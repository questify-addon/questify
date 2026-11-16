#!/usr/bin/env python3
# Rend les SVG des thèmes (tools/themes/export_svgs.js) en textures TGA du jeu.
# Usage : python3 tools/themes/build_textures.py <dossier des SVG> <dossier Media de Questify> [noms…]
#   (noms : ne rendre que ceux-là, par exemple glyph-check banner-dwarf)
# Chrome sans interface rend chaque SVG en PNG transparent (4x, réduit ensuite pour lisser les bords),
# Pillow l'écrit en TGA 32 bits non compressé. Profil Chrome jetable dans le dossier des SVG.
import os
import subprocess
import sys

from PIL import Image

CHROME = os.environ.get("CHROME", "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome")
SCALE = 4


def render(svg_dir, name, w, h):
    html = os.path.join(svg_dir, name + ".html")
    png = os.path.join(svg_dir, name + ".png")
    with open(html, "w") as f:
        f.write(f'<!doctype html><html><head><style>html,body{{margin:0;background:transparent}}'
                f'img{{display:block;width:{w * SCALE}px;height:{h * SCALE}px}}</style></head>'
                f'<body><img src="{name}.svg"></body></html>')
    win_w, win_h = max(w * SCALE, 64), max(h * SCALE, 64)
    subprocess.run([CHROME, "--headless=new", "--user-data-dir=" + os.path.join(svg_dir, ".chrome"),
                    "--no-first-run", "--hide-scrollbars", "--force-device-scale-factor=1",
                    "--default-background-color=00000000", f"--window-size={win_w},{win_h}",
                    "--virtual-time-budget=2000", "--screenshot=" + png, "file://" + html],
                   check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    im = Image.open(png).convert("RGBA").crop((0, 0, w * SCALE, h * SCALE))
    return im.resize((w, h), Image.LANCZOS)


def main():
    svg_dir, media = sys.argv[1], sys.argv[2]
    out_dir = os.path.join(media, "Themes")
    os.makedirs(out_dir, exist_ok=True)
    with open(os.path.join(svg_dir, "list.txt")) as f:
        items = [line.split() for line in f if line.strip()]
    only = set(sys.argv[3:])
    if only:
        items = [it for it in items if it[0] in only]
    for name, w, h in items:
        im = render(svg_dir, name, int(w), int(h))
        dest = os.path.join(media, "Icon.tga") if name == "icon" else os.path.join(out_dir, name + ".tga")
        im.save(dest)
        print(dest)


if __name__ == "__main__":
    main()
