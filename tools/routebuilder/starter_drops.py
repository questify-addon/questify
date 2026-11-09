#!/usr/bin/env python3
"""Écrit tools/routebuilder/data/StarterDrops.lua depuis la sortie du scraper Wowhead de Questie.

QuestieDB ne donne de taux de butin que pour les objets d'objectif ; sans taux, le générateur supposait 20 %
pour un objet qui démarre une quête. Les taux viennent de l'onglet « dropped-by » de Wowhead Classic, lu par le
scraper de Questie (Scrapy). Procédure complète (tools/routebuilder/README.md, « Drop rates of quest starters ») :

    luajit tools/routebuilder/starter_items.lua > .cache/starter_items.txt
    # copie du scraper (le clone .cache/questie reste intact), liste d'objets, User-Agent honnête :
    #   Wowhead répond 403 au faux User-Agent Chrome du scraper
    python3 tools/routebuilder/starter_drops.py --prepare .cache/starter_items.txt
    (cd .cache/questie-scraper && ../venv-scrapy/bin/python runner.py --item-drops -ex classic)
    python3 tools/routebuilder/starter_drops.py .cache/questie-scraper/item_drop/item_drop_data.json \\
        --ids .cache/starter_items.txt

Bibliothèque standard seulement. Un objet sans page Wowhead Classic (objets propres à Forever) ou sans butin
connu est listé dans `missing` et garde le taux par défaut du générateur.
"""
import argparse
import json
import os
import re
import shutil

SCRAPER_SRC = ".cache/questie/ExternalScripts(DONOTINCLUDEINRELEASE)/scraper"
SCRAPER = ".cache/questie-scraper"
USER_AGENT = "questify-routebuilder/0.4 (quest starter drop rates)"


def prepare(ids_path):
    """Copie le scraper de Questie dans .cache/questie-scraper avec la liste d'objets et un User-Agent honnête."""
    if os.path.exists(SCRAPER):
        shutil.rmtree(SCRAPER)
    shutil.copytree(SCRAPER_SRC, SCRAPER)
    with open(ids_path) as f:
        ids = [x for x in f.read().split() if x.isdigit()]
    with open(os.path.join(SCRAPER, "item_drop", "item_ids.py"), "w") as f:
        f.write("ITEM_IDS = [\n" + "".join(f"    {i},\n" for i in ids) + "]\n")
    runner = os.path.join(SCRAPER, "runner.py")
    with open(runner) as f:
        s = f.read()
    s = re.sub(r'"USER_AGENT": .*', f'"USER_AGENT": {USER_AGENT!r}', s)
    s = s.replace('"DOWNLOAD_DELAY": 1,', '"DOWNLOAD_DELAY": 1.5,')
    with open(runner, "w") as f:
        f.write(s)
    print(f"{SCRAPER} ready with {len(ids)} items")


def write(json_path, ids_path, out):
    with open(json_path) as f:
        data = json.load(f)
    ids = []
    if ids_path:
        with open(ids_path) as f:
            ids = [int(x) for x in f.read().split() if x.isdigit()]
    drops, names = {}, {}
    for entry in data:
        item = int(entry["itemId"])
        names[item] = entry.get("name", "?")
        npcs = {int(k): v for k, v in entry.items() if k not in ("itemId", "name")}
        npcs = {k: v for k, v in npcs.items() if v[1] > 0 and v[0] > 0}
        if npcs:
            drops[item] = npcs
    missing = sorted(set(ids) - set(drops))
    with open(out, "w", encoding="utf-8") as f:
        f.write("-- Généré par tools/routebuilder/starter_drops.py depuis Wowhead Classic (onglet « dropped-by », lu par le\n")
        f.write("-- scraper de Questie). Ne pas modifier à la main. drops[objet][pnj] = { count, outof } ; taux = count / outof.\n")
        f.write("-- missing : objets sans page ou sans butin connu sur Wowhead Classic (taux par défaut du générateur).\n")
        f.write("return {\n  drops = {\n")
        for item in sorted(drops):
            f.write(f"    [{item}] = {{ -- {names[item]}\n")
            for npc in sorted(drops[item]):
                count, outof = drops[item][npc]
                f.write(f"      [{npc}] = {{ {count}, {outof} }}, -- {100 * count / outof:.2f} %\n")
            f.write("    },\n")
        f.write("  },\n  missing = { " + ", ".join(str(x) for x in missing) + " },\n}\n")
    print(f"{len(drops)} items with drop data, {len(missing)} missing -> {out}")


def main():
    p = argparse.ArgumentParser()
    p.add_argument("json", nargs="?")
    p.add_argument("--prepare", metavar="IDS")
    p.add_argument("--ids")
    p.add_argument("--out", default="tools/routebuilder/data/StarterDrops.lua")
    a = p.parse_args()
    if a.prepare:
        prepare(a.prepare)
    elif a.json:
        write(a.json, a.ids, a.out)
    else:
        p.error("give the scraper JSON or --prepare IDS")


if __name__ == "__main__":
    main()
