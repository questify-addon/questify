#!/usr/bin/env python3
"""Guides de talents et macros de classicwowforever.com -> données de Questify.

Usage (depuis la racine du projet) :
  python3 tools/classguides/build.py --fetch   # télécharge les pages et les tables DB2 dans cache/, puis génère
  python3 tools/classguides/build.py           # génère depuis cache/ (aucun accès réseau)

Écrit Questify/Data/ClassGuides.lua, Questify/Data/ClassMacros.lua et Questify/Data/ClassText_<locale>.lua
(frFR, deDE, esES). Sortie déterministe : mêmes pages en cache -> mêmes fichiers, octet pour octet (aucune
date de relevé dans les fichiers ; la date affichée est celle de la mise à jour du guide sur le site).

Source : Classic WoW Forever (https://classicwowforever.com), licence CC BY 4.0. Voir README.md.
Bibliothèque standard seulement. Les pages téléchargées sont des données : rien n'y est exécuté.
"""
import argparse
import csv
import html
import json
import re
import sys
import time
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
TOOL = ROOT / "tools" / "classguides"
CACHE = TOOL / "cache"
DATA = ROOT / "Questify" / "Data"

SITE = "https://classicwowforever.com"
LICENSE = "CC BY 4.0"
LICENSE_URL = "https://creativecommons.org/licenses/by/4.0/"
DB2_BUILD = "1.60.1.70862"
DB2_TABLES = ["SpellName", "Talent", "TalentTab", "TraitDefinition", "ItemSparse", "SkillLineAbility"]
USER_AGENT = "Questify-classguides/1.0 (offline data tool for a WoW addon)"

# langue du site -> locale du jeu ; "" = anglais (adresse sans préfixe)
LANGS = [("", "enUS"), ("fr", "frFR"), ("de", "deDE"), ("es", "esES")]
# (adresse du site, classe du jeu, bit de ClassMask)
CLASSES = [
    ("warrior", "WARRIOR", 1), ("paladin", "PALADIN", 2), ("hunter", "HUNTER", 4), ("rogue", "ROGUE", 8),
    ("priest", "PRIEST", 16), ("shaman", "SHAMAN", 64), ("mage", "MAGE", 128), ("warlock", "WARLOCK", 256),
    ("druid", "DRUID", 1024),
]
MACRO_MAX = 255           # longueur maximale du texte d'une macro dans le jeu
FIRST_TALENT_LEVEL = 10
LAST_LEVEL = 60
POINTS_PER_TIER = 5


class BuildError(Exception):
    pass


warnings = []


def warn(msg):
    warnings.append(msg)


# ---------------------------------------------------------------------------------------------- réseau
def page_path(lang, path):
    sub = lang or "en"
    return CACHE / sub / (path.strip("/") or "index") / "index.html"


def fetch_url(url, dest):
    req = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
    with urllib.request.urlopen(req, timeout=60) as r:
        if r.status != 200:
            raise BuildError(f"{url} : HTTP {r.status}")
        body = r.read()
    dest.parent.mkdir(parents=True, exist_ok=True)
    tmp = dest.with_suffix(dest.suffix + ".tmp")
    tmp.write_bytes(body)
    tmp.replace(dest)


def fetch_all():
    paths = ["/class-guides/"]
    for cls, _, _ in CLASSES:
        paths.append(f"/macros/{cls}/")
    en_index = None
    for lang, _ in LANGS:
        prefix = f"/{lang}" if lang else ""
        for p in paths:
            fetch_url(SITE + prefix + p, page_path(lang, p))
            time.sleep(0.4)
        if not lang:
            en_index = page_path("", "/class-guides/").read_text(encoding="utf-8")
        for p in guide_paths(en_index):
            fetch_url(SITE + prefix + p, page_path(lang, p))
            time.sleep(0.4)
    for t in DB2_TABLES:
        fetch_url(f"https://wago.tools/db2/{t}/csv?build={DB2_BUILD}", CACHE / "db2" / f"{t}.csv")
        time.sleep(0.4)


def guide_paths(index_html):
    out = []
    for cls, _, _ in CLASSES:
        found = sorted(set(re.findall(rf'href="(/class-guides/{cls}/[a-z-]+/)"', index_html)),
                       key=lambda p: index_html.find(f'href="{p}"'))
        if len(found) != 3:
            raise BuildError(f"{cls} : {len(found)} guides trouvés sur /class-guides/ (3 attendus)")
        out.extend(found)
    return out


def read_page(lang, path):
    p = page_path(lang, path)
    if not p.exists():
        raise BuildError(f"page absente du cache : {p.relative_to(ROOT)} (lancer avec --fetch)")
    return p.read_text(encoding="utf-8")


# ---------------------------------------------------------------------------------------------- RSC
DEC = json.JSONDecoder()


def rsc_text(page):
    """Texte du flux RSC (Next/Vinext) : concaténation des chaînes passées à .rsc.push("...")."""
    out = []
    pos = 0
    while True:
        i = page.find(".rsc.push(", pos)
        if i < 0:
            break
        j = i + len(".rsc.push(")
        if page[j] != '"':
            pos = j
            continue
        s, end = DEC.raw_decode(page, j)
        out.append(s)
        pos = end
    return "".join(out)


def json_after(txt, key, start=0):
    """Valeur JSON qui suit la clé "key": (première occurrence après start)."""
    i = txt.find(f'"{key}":', start)
    if i < 0:
        return None, -1
    j = i + len(key) + 3
    v, _ = DEC.raw_decode(txt, j)
    return v, i


# ---------------------------------------------------------------------------------------------- HTML
def strip_tags(s):
    s = re.sub(r"<!--.*?-->", "", s, flags=re.S)
    s = re.sub(r"<[^>]+>", "", s)
    s = html.unescape(s)
    return re.sub(r"\s+", " ", s).strip()


def balanced(page, start, tag):
    """Contenu de l'élément <tag ...> qui commence à start (balises de même nom imbriquées comprises)."""
    open_end = page.index(">", start) + 1
    depth, pos = 1, open_end
    pat = re.compile(rf"<(/?){tag}\b[^>]*>")
    while depth:
        m = pat.search(page, pos)
        if not m:
            raise BuildError(f"<{tag}> non fermé")
        depth += -1 if m.group(1) else 1
        pos = m.end()
    return page[open_end:m.start()]


def no_scripts(page):
    return re.sub(r"<script\b.*?</script>", "", page, flags=re.S)


# ---------------------------------------------------------------------------------------------- DB2
def read_csv(name):
    p = CACHE / "db2" / f"{name}.csv"
    if not p.exists():
        raise BuildError(f"table absente du cache : {p.relative_to(ROOT)} (lancer avec --fetch)")
    with p.open(encoding="utf-8", newline="") as f:
        return list(csv.DictReader(f))


class DB2:
    def __init__(self):
        self.spell_name = {}
        self.spells_by_name = {}
        for r in read_csv("SpellName"):
            sid = int(r["ID"])
            self.spell_name[sid] = r["Name_lang"]
            self.spells_by_name.setdefault(r["Name_lang"].lower(), []).append(sid)
        self.class_spells = {}      # bit de classe -> set(spellID)
        for r in read_csv("SkillLineAbility"):
            mask = int(r["ClassMask"] or 0)
            if mask:
                for _, _, bit in CLASSES:
                    if mask & bit:
                        self.class_spells.setdefault(bit, set()).add(int(r["Spell"]))
        self.tabs = {}              # (bit, nom anglais) -> { id, order }
        for r in read_csv("TalentTab"):
            mask = int(r["ClassMask"] or 0)
            for _, _, bit in CLASSES:
                if mask == bit:
                    self.tabs[(bit, r["Name_lang"].lower())] = {"id": int(r["ID"]), "order": int(r["OrderIndex"])}
        self.talents = {}           # (tabID, palier, colonne) -> rangée de Talent
        self.talent_spells = set()
        for r in read_csv("Talent"):
            ranks = [int(r[f"SpellRank_{i}"] or 0) for i in range(9)]
            ranks = [s for s in ranks if s]
            if not ranks:
                continue
            self.talents[(int(r["TabID"]), int(r["TierID"]), int(r["ColumnIndex"]))] = {"ranks": ranks}
            self.talent_spells.update(ranks)
        self.trait_spells = set()
        for r in read_csv("TraitDefinition"):
            for k in ("SpellID", "OverridesSpellID", "VisibleSpellID"):
                if int(r[k] or 0):
                    self.trait_spells.add(int(r[k]))
        self.items_by_name = {}
        for r in read_csv("ItemSparse"):
            self.items_by_name.setdefault(r["Display_lang"].lower(), []).append(int(r["ID"]))

    def spell_for(self, name, bit):
        ids = self.spells_by_name.get(name.lower())
        if not ids:
            return None
        mine = sorted(i for i in ids if i in self.class_spells.get(bit, ()))
        if mine:
            return mine[0]
        tal = sorted(i for i in ids if i in self.talent_spells)
        if tal:
            return tal[0]
        anyclass = sorted(i for i in ids if any(i in s for s in self.class_spells.values()))
        if anyclass:
            return anyclass[0]
        return min(ids)

    def talent_for(self, name, bit):
        """Sort de talent par son nom (talents propres à Forever, absents de la table Talent)."""
        ids = self.spells_by_name.get(name.lower()) or []
        for pool in (self.talent_spells, self.trait_spells):
            hit = sorted(i for i in ids if i in pool)
            if hit:
                return hit[0]
        return None

    def item_for(self, name):
        ids = self.items_by_name.get(name.lower())
        return min(ids) if ids else None


# ---------------------------------------------------------------------------------------------- guides
def icon_name(path):
    return Path(path).stem.lower() if path else None


def parse_guide_en(page, cls, spec_slug):
    txt = rsc_text(page)
    model, _ = json_after(txt, "model")
    if not model or model.get("id") != f"{cls}-{spec_slug}":
        raise BuildError(f"{cls}/{spec_slug} : modèle du guide introuvable")
    i = txt.find('"stages":[')
    k = txt.rfind('{"title":', 0, i)
    talents, _ = DEC.raw_decode(txt, k)
    if "stages" not in talents:
        raise BuildError(f"{cls}/{spec_slug} : chemin de talents introuvable")
    steps, _ = json_after(txt, "steps", k)
    tree, _ = json_after(txt, "tree", k)
    m = re.search(r'"author":\{"@type":"Person"[^}]*?"name":"([^"]+)"', page)
    return {
        "name": model["name"], "icon": icon_name(model.get("specIcon")),
        "build": model.get("talentBuild") or model.get("build"), "reviewed": model.get("reviewed"),
        "author": m.group(1) if m else None,
        "tagline": talents.get("title"), "stages": talents["stages"], "steps": steps, "tree": tree,
    }


def parse_guide_local(page):
    """Textes traduits d'un guide : nom de la spé et, dans l'ordre, l'explication de chaque étape."""
    body = no_scripts(page)
    whys = []
    for m in re.finditer(r'<li data-level="(\d+)">', body):
        li = balanced(body, m.start(), "li")
        t = li.find('class="sg-level-talent"')
        if t < 0:
            continue
        w = li.find('<span class="sg-why">', t)
        whys.append((int(m.group(1)), strip_tags(balanced(li, w, "span")) if w >= 0 else ""))
    return whys


def parse_index_taglines(page, lang):
    """/class-guides/ : (classe, spé) -> (nom de la spé, accroche), dans la langue de la page."""
    body = no_scripts(page)
    prefix = f"/{lang}" if lang else ""
    out = {}
    for m in re.finditer(rf'<a[^>]+href="{prefix}/class-guides/([a-z]+)/([a-z-]+)/"[^>]*>(.*?)</a>', body, flags=re.S):
        inner = m.group(3)
        name = re.search(r"<strong>(.*?)</strong>", inner, flags=re.S)
        tag = re.search(r"<small>(.*?)</small>", inner, flags=re.S)
        if name and tag and (m.group(1), m.group(2)) not in out:
            out[(m.group(1), m.group(2))] = (strip_tags(name.group(1)), strip_tags(tag.group(1)))
    return out


def build_guides(db):
    index = {lang: parse_index_taglines(read_page(lang, "/class-guides/"), lang) for lang, _ in LANGS}
    en_index = read_page("", "/class-guides/")
    paths = guide_paths(en_index)
    guides, texts = {}, {loc: {} for _, loc in LANGS if loc != "enUS"}
    for cls, CLS, bit in CLASSES:
        specs = []
        for p in [p for p in paths if p.split("/")[2] == cls]:
            slug = p.split("/")[3]
            g = parse_guide_en(read_page("", p), cls, slug)
            tab = db.tabs.get((bit, g["name"].lower()))
            if not tab:     # « Feral » sur le site, « Feral Combat » dans le jeu
                near = [v for (b, n), v in db.tabs.items() if b == bit and n.startswith(g["name"].lower() + " ")]
                tab = near[0] if len(near) == 1 else None
            if not tab:
                raise BuildError(f"{cls}/{slug} : arbre « {g['name']} » absent de TalentTab")
            nodes, unmatched, ranks_diff = [], [], []
            for n in g["tree"]["nodes"]:
                row = db.talents.get((tab["id"], n["row"], n["col"]))
                spell = row["ranks"][0] if row else None
                if spell and db.spell_name.get(spell, "").lower() != n["name"].lower():
                    spell = None    # case occupée par un autre talent dans Talent : Forever l'a changée
                if not spell:
                    spell = db.talent_for(n["name"], bit)
                    if not spell:
                        raise BuildError(f"{cls}/{slug} : talent « {n['name']} » introuvable (Talent, TraitDefinition)")
                    unmatched.append(n["name"])
                elif len(row["ranks"]) != n["maxRanks"]:
                    ranks_diff.append(f"{n['name']} {n['maxRanks']}/{len(row['ranks'])}")
                nodes.append({"id": n["id"], "spell": spell, "row": n["row"], "col": n["col"], "max": n["maxRanks"],
                              "icon": icon_name(n["icon"]), "name": n["name"]})
            if unmatched:
                warn(f"{cls}/{slug} : trouvés par leur nom (hors table Talent) : {', '.join(unmatched)}")
            if ranks_diff:
                warn(f"{cls}/{slug} : rangs site/Talent différents : {', '.join(ranks_diff)}")
            specs.append({"slug": slug, "group": tab["order"] + 1, "url": SITE + p, **g, "nodes": nodes})
        specs.sort(key=lambda s: s["group"])
        if [s["group"] for s in specs] != [1, 2, 3]:
            raise BuildError(f"{cls} : ordre des arbres inattendu {[s['group'] for s in specs]}")
        by_id = {n["id"]: (s["group"], n) for s in specs for n in s["nodes"]}
        out_specs = []
        for s in specs:
            out_specs.append(check_and_pack(cls, s, by_id))
            for lang, loc in LANGS:
                if loc == "enUS":
                    continue
                name, tagline = index[lang].get((cls, s["slug"]), (None, None))
                whys = parse_guide_local(read_page(lang, f"/class-guides/{cls}/{s['slug']}/"))
                if len(whys) != len(s["stages"]) or any(a[0] != b["level"] for a, b in zip(whys, s["stages"])):
                    warn(f"{cls}/{s['slug']} ({loc}) : étapes traduites non alignées ({len(whys)} / {len(s['stages'])}), anglais gardé")
                    whys = []
                texts[loc].setdefault(CLS, {"guides": {}, "macros": {}})["guides"][s["slug"]] = {
                    "name": name, "tagline": tagline, "why": [w for _, w in whys]}
        guides[CLS] = out_specs
    return guides, texts


def check_and_pack(cls, s, by_id):
    """Vérifie le chemin (un point par niveau de 10 à 60, rangs, paliers) et prépare la sortie."""
    where = f"{cls}/{s['slug']}"
    steps = s["steps"] or []
    levels = [st["level"] for st in steps]
    if levels != list(range(FIRST_TALENT_LEVEL, LAST_LEVEL + 1)):
        raise BuildError(f"{where} : niveaux du chemin inattendus ({levels[:3]}…)")
    ranks, spent = {}, {1: 0, 2: 0, 3: 0}
    order = []
    for st in steps:
        if st["id"] not in by_id:
            raise BuildError(f"{where} : talent {st['id']} absent des arbres")
        group, node = by_id[st["id"]]
        ranks[st["id"]] = ranks.get(st["id"], 0) + 1
        if ranks[st["id"]] != st["rank"]:
            raise BuildError(f"{where} : niveau {st['level']}, {st['id']} rang {st['rank']} (attendu {ranks[st['id']]})")
        if ranks[st["id"]] > node["max"]:
            raise BuildError(f"{where} : {st['id']} dépasse son rang maximal")
        if spent[group] < node["row"] * POINTS_PER_TIER:
            warn(f"{where} : niveau {st['level']}, {node['name']} pris avant {node['row'] * POINTS_PER_TIER} points dans son arbre")
        spent[group] += 1
        order.append(node["spell"])
    stages = []
    for st in s["stages"]:
        if st["id"] not in by_id:
            raise BuildError(f"{where} : étape {st['id']} absente des arbres")
        stages.append({"level": st["level"], "to": st.get("toLevel") or st["level"],
                       "spell": by_id[st["id"]][1]["spell"], "rank": st["rank"], "why": st.get("why") or ""})
    return {"key": s["slug"], "group": s["group"], "name": s["name"], "icon": s["icon"], "url": s["url"],
            "author": s["author"], "build": s["build"], "reviewed": s["reviewed"], "tagline": s["tagline"],
            "nodes": s["nodes"], "steps": order, "stages": stages}


# ---------------------------------------------------------------------------------------------- macros
NAME_CMDS = {"/cast", "/castsequence", "/castrandom", "/cancelaura", "/use", "#showtooltip", "#show",
             "/equip", "/equipslot", "/userandom"}
ITEM_CMDS = {"/use", "/equip", "/equipslot", "/userandom"}


def macro_template(code, bit, db, names, unknown):
    """Remplace les noms anglais de sorts et d'objets par {sID} / {iID} ; « (Rank N) » -> « ({r} N) »."""
    out_lines = []
    for line in code.split("\n"):
        m = re.match(r"^\s*([#/][A-Za-z]+)(\s+)(.*)$", line)
        if not m or m.group(1).lower() not in NAME_CMDS:
            out_lines.append(line)
            continue
        cmd, sp, rest = m.group(1), m.group(2), m.group(3)
        is_item_cmd = cmd.lower() in ITEM_CMDS
        out = []
        # segments séparés par ; (options), chacun : [conditions]... reste
        for seg_i, seg in enumerate(rest.split(";")):
            pre = re.match(r"^(\s*(?:\[[^\]]*\]\s*)*)(.*)$", seg)
            conds, body = pre.group(1), pre.group(2)
            if cmd.lower() == "/castsequence":
                r = re.match(r"^(reset=\S+\s+)?(.*)$", body)
                reset, body = r.group(1) or "", r.group(2)
                parts = body.split(",")
                body = reset + ",".join(name_token(p, bit, db, names, unknown, False) for p in parts)
            elif cmd.lower() == "/equipslot":
                r = re.match(r"^(\d+\s+)(.*)$", body)
                body = (r.group(1) + name_token(r.group(2), bit, db, names, unknown, True)) if r else body
            else:
                body = name_token(body, bit, db, names, unknown, is_item_cmd)
            out.append(conds + body)
        out_lines.append(cmd + sp + ";".join(out))
    return "\n".join(out_lines)


def name_token(tok, bit, db, names, unknown, item_first):
    m = re.match(r"^(\s*)(!?)(.*?)(\s*)$", tok)
    lead, bang, name, trail = m.groups()
    if not name or re.fullmatch(r"\d+", name) or "=" in name:
        return tok
    rank = re.match(r"^(.*?)\((?:Rank) (\d+)\)$", name)
    suffix = ""
    if rank:
        name, suffix = rank.group(1), "({r} " + rank.group(2) + ")"
    sid = None if item_first else db.spell_for(name, bit)
    iid = db.item_for(name) if (item_first or not sid) else None
    if item_first and not iid:
        sid = db.spell_for(name, bit)
    if sid:
        key = f"s{sid}"
    elif iid:
        key = f"i{iid}"
    else:
        unknown.add(name)
        return tok
    names[key] = name
    return f"{lead}{bang}{{{key}}}{suffix}{trail}"


def parse_macros_en(page):
    txt = rsc_text(page)
    i = txt.find('{"sections":')
    if i < 0:
        raise BuildError("liste des macros introuvable")
    data, _ = DEC.raw_decode(txt, i)
    out = []
    for sec in data["sections"]:
        spec = None if sec["id"] == "class-wide" else sec["id"]
        for kind in ("pve", "pvp"):
            g = sec.get(kind)
            if not g:
                continue
            for e in g["entries"]:
                en = e["entry"]
                out.append({"uid": f"{g['prefix']}-{en['id']}", "spec": en.get("spec") or spec, "pvp": kind == "pvp",
                            "origin": en["origin"], "level": en.get("level"), "icon": icon_name(e.get("icon")),
                            "code": en["code"], "title": en["title"], "use": en["use"],
                            "requires": en.get("requires") or "", "mods": [(m["key"], m["does"]) for m in en.get("mods") or []]})
    return out


def parse_macros_local(page):
    body = no_scripts(page)
    out = []
    for m in re.finditer(r'<article class="mc" id="([^"]+)"', body):
        art = balanced(body, m.start(), "article")
        code = re.search(r'<pre class="mc-code"><code>(.*?)</code></pre>', art, flags=re.S)
        title = re.search(r"<h3>(.*?)</h3>", art, flags=re.S)
        use = re.search(r"</h3>\s*<p>(.*?)</p>", art, flags=re.S)
        needs = re.search(r'<p class="mc-needs">(.*?)</p>', art, flags=re.S)
        mods = re.findall(r"<li><kbd>.*?</kbd><span>(.*?)</span></li>", art, flags=re.S)
        req = ""
        if needs:
            req = strip_tags(re.sub(r"<strong>.*?</strong>", "", needs.group(1), count=1, flags=re.S))
        out.append({"uid": m.group(1), "code": html.unescape(code.group(1)) if code else None,
                    "title": strip_tags(title.group(1)) if title else "", "use": strip_tags(use.group(1)) if use else "",
                    "requires": req, "mods": [strip_tags(x) for x in mods]})
    return out


def build_macros(db, texts):
    names = {}
    macros = {}
    for cls, CLS, bit in CLASSES:
        en = parse_macros_en(read_page("", f"/macros/{cls}/"))
        unknown = set()
        rows = []
        for e in en:
            mine = set()
            tpl = macro_template(e["code"], bit, db, names, mine)
            unknown |= mine
            if len(e["code"]) > MACRO_MAX:
                warn(f"macro {cls}/{e['uid']} : {len(e['code'])} caractères (max {MACRO_MAX})")
            # « Off-Hand Name » : nom d'objet à écrire par le joueur
            rows.append({**e, "code": tpl, "fill": any(n.endswith(" Name") for n in mine)})
        if unknown:
            warn(f"macros {cls} : noms non reconnus (laissés en anglais) : {', '.join(sorted(unknown))}")
        macros[CLS] = {"url": f"{SITE}/macros/{cls}/", "list": rows}
        for lang, loc in LANGS:
            if loc == "enUS":
                continue
            local = {x["uid"]: x for x in parse_macros_local(read_page(lang, f"/macros/{cls}/"))}
            out = texts[loc].setdefault(CLS, {"guides": {}, "macros": {}})["macros"]
            for e in en:
                x = local.get(e["uid"])
                if not x or x["code"] != e["code"]:
                    warn(f"macro {cls}/{e['uid']} ({loc}) : texte traduit introuvable, anglais gardé")
                    continue
                if len(x["mods"]) != len(e["mods"]):
                    x["mods"] = []
                out[e["uid"]] = {"title": x["title"], "use": x["use"], "requires": x["requires"], "mods": x["mods"]}
    return macros, names


# ---------------------------------------------------------------------------------------------- Lua
def lua_str(s):
    if s is None:
        return "nil"
    s = str(s).replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n").replace("\r", "")
    return f'"{s}"'


HEADER = """local addonName, Q = ...

-- GÉNÉRÉ par tools/classguides/build.py : ne pas modifier à la main, relancer l'outil.
-- Source : Classic WoW Forever, https://classicwowforever.com ({what}).
-- Licence : Creative Commons Attribution 4.0 International (CC BY 4.0),
-- https://creativecommons.org/licenses/by/4.0/ . © Classic WoW Forever et ses auteurs.
-- Modifié par Questify : données réorganisées pour l'addon (talents désignés par leur sort de rang 1,
-- noms anglais des sorts et objets des macros remplacés par des marqueurs traduits par le jeu), textes
-- repris tels quels dans chaque langue du site, mise en page propre à Questify.
"""


def write(path, text):
    path.write_text(text, encoding="utf-8")


def gen_guides(guides):
    L = [HEADER.format(what="/class-guides/"), "Q.ClassGuideData = {",
         f"  source = {{ name = \"Classic WoW Forever\", url = {lua_str(SITE + '/class-guides/')}, "
         f"license = {lua_str(LICENSE)}, licenseUrl = {lua_str(LICENSE_URL)} }},"]
    for _, CLS, _ in CLASSES:
        L.append(f"  {CLS} = {{")
        for s in guides[CLS]:
            L.append(f"    {{ key = {lua_str(s['key'])}, group = {s['group']}, name = {lua_str(s['name'])}, "
                     f"icon = {lua_str(s['icon'])},")
            L.append(f"      url = {lua_str(s['url'])}, author = {lua_str(s['author'])}, build = {lua_str(s['build'])}, "
                     f"reviewed = {lua_str(s['reviewed'])},")
            L.append(f"      tagline = {lua_str(s['tagline'])},")
            L.append("      nodes = {")
            for n in s["nodes"]:
                L.append(f"        {{ spell = {n['spell']}, row = {n['row']}, col = {n['col']}, max = {n['max']}, "
                         f"icon = {lua_str(n['icon'])}, name = {lua_str(n['name'])} }},")
            L.append("      },")
            L.append("      -- un sort de talent par niveau, du niveau 10 au niveau 60")
            steps = ", ".join(str(x) for x in s["steps"])
            L.append(f"      steps = {{ {steps} }},")
            L.append("      stages = {")
            for st in s["stages"]:
                L.append(f"        {{ level = {st['level']}, to = {st['to']}, spell = {st['spell']}, rank = {st['rank']}, "
                         f"why = {lua_str(st['why'])} }},")
            L.append("      },")
            L.append("    },")
        L.append("  },")
    L.append("}")
    return "\n".join(L) + "\n"


def gen_macros(macros, names):
    L = [HEADER.format(what="/macros/"), "Q.ClassMacroData = {",
         f"  source = {{ name = \"Classic WoW Forever\", url = {lua_str(SITE + '/macros/')}, "
         f"license = {lua_str(LICENSE)}, licenseUrl = {lua_str(LICENSE_URL)} }},",
         "  -- noms anglais des marqueurs {sID} (sort) et {iID} (objet), si le jeu ne donne pas le sien",
         "  names = {"]
    for k in sorted(names, key=lambda k: (k[0], int(k[1:]))):
        L.append(f"    {k} = {lua_str(names[k])},")
    L.append("  },")
    for _, CLS, _ in CLASSES:
        m = macros[CLS]
        L.append(f"  {CLS} = {{ url = {lua_str(m['url'])},")
        for e in m["list"]:
            mods = ", ".join(f"{{ {lua_str(k)}, {lua_str(d)} }}" for k, d in e["mods"])
            L.append(f"    {{ id = {lua_str(e['uid'])}, spec = {lua_str(e['spec'])}, pvp = {str(e['pvp']).lower()}, "
                     f"origin = {lua_str(e['origin'])}, level = {e['level'] if e['level'] else 'nil'}, "
                     f"icon = {lua_str(e['icon'])},")
            L.append(f"      code = {lua_str(e['code'])},{' fill = true,' if e['fill'] else ''}")
            L.append(f"      title = {lua_str(e['title'])},")
            L.append(f"      use = {lua_str(e['use'])},")
            L.append(f"      requires = {lua_str(e['requires'])},")
            L.append(f"      mods = {{ {mods} }} }},")
        L.append("  },")
    L.append("}")
    return "\n".join(L) + "\n"


def gen_text(loc, texts):
    L = [HEADER.format(what=f"pages {loc[:2]} des guides de classe et des macros"),
         f"-- Textes du site en {loc}, chargés seulement par un client {loc}.",
         f"if (GetLocale and GetLocale() or \"enUS\") ~= \"{loc}\" then return end",
         "Q.ClassGuideText = {"]
    for _, CLS, _ in CLASSES:
        t = texts.get(CLS) or {"guides": {}, "macros": {}}
        L.append(f"  {CLS} = {{")
        L.append("    guides = {")
        for key in sorted(t["guides"]):
            g = t["guides"][key]
            L.append(f"      [{lua_str(key)}] = {{ name = {lua_str(g['name'])}, tagline = {lua_str(g['tagline'])}, why = {{")
            for w in g["why"]:
                L.append(f"        {lua_str(w)},")
            L.append("      } },")
        L.append("    },")
        L.append("    macros = {")
        for uid in sorted(t["macros"]):
            x = t["macros"][uid]
            mods = ", ".join(lua_str(d) for d in x["mods"])
            L.append(f"      [{lua_str(uid)}] = {{ title = {lua_str(x['title'])}, use = {lua_str(x['use'])},")
            L.append(f"        requires = {lua_str(x['requires'])}, mods = {{ {mods} }} }},")
        L.append("    },")
        L.append("  },")
    L.append("}")
    return "\n".join(L) + "\n"


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--fetch", action="store_true", help="télécharger les pages et les tables DB2 avant de générer")
    args = ap.parse_args()
    try:
        if args.fetch:
            fetch_all()
        db = DB2()
        guides, texts = build_guides(db)
        macros, names = build_macros(db, texts)
    except BuildError as e:
        print(f"build.py : {e}", file=sys.stderr)
        return 1
    write(DATA / "ClassGuides.lua", gen_guides(guides))
    write(DATA / "ClassMacros.lua", gen_macros(macros, names))
    for _, loc in LANGS:
        if loc != "enUS":
            write(DATA / f"ClassText_{loc}.lua", gen_text(loc, texts[loc]))
    n_guides = sum(len(v) for v in guides.values())
    n_macros = sum(len(v["list"]) for v in macros.values())
    n_pvp = sum(1 for v in macros.values() for e in v["list"] if e["pvp"])
    print(f"{n_guides} guides, {n_macros} macros ({n_pvp} PvP), {len(names)} noms de sorts et d'objets")
    for w in warnings:
        print(f"  attention : {w}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
