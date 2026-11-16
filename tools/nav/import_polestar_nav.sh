#!/usr/bin/env bash
# Copie le routeur de marche de Polestar (Polestar_Nav, _EK, _Kalimdor) en Questify_Nav, _EK, _Kalimdor.
#
# Usage : tools/nav/import_polestar_nav.sh "<dossier AddOns>"
#   ex. : tools/nav/import_polestar_nav.sh "/Applications/World of Warcraft/_forever_/Interface/AddOns"
#
# Rejouable : écrase les trois dossiers cibles. Renomme à l'octet près (perl, LC_ALL=C) les seuls jetons
# de code listés ci-dessous (les en-têtes de copyright et la prose citant Polestar ne changent pas),
# réécrit les trois TOC, recalcule PACK.json (sha256) et copie LICENSE.
# Compte chaque jeton avant et après : si un compte diffère de l'attendu (0.3.7.2), le script échoue
# avant de toucher aux dossiers cibles (mettre alors RENAMES à jour après vérification manuelle).
# Questify_Nav/CREDITS.md est écrit à la main : il doit exister et il est conservé.
set -u
set -o pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SRC="${1:-}"
fail() { echo "import_polestar_nav.sh : $*" >&2; exit 1; }
[ -n "$SRC" ] && [ -d "$SRC/Polestar_Nav" ] || fail "usage : $0 <dossier AddOns contenant Polestar_Nav>"
VERSION_ATTENDUE="0.3.7.2"

grep -q "^## Version: $VERSION_ATTENDUE\$" "$SRC/Polestar_Nav/Polestar_Nav.toc" \
  || fail "Polestar_Nav n'est pas en version $VERSION_ATTENDUE (comptes attendus à revoir)"
[ -f "$ROOT/Questify_Nav/CREDITS.md" ] || fail "Questify_Nav/CREDITS.md absent : l'écrire d'abord (il n'est pas généré)"

# jeton source | jeton cible | occurrences attendues dans Polestar_Nav | _EK | _Kalimdor
RENAMES=(
  'PolestarPathData|QuestifyPathData|26|82|102'
  'Polestar_NavEngine|Questify_NavEngine|2|0|0'
  'Polestar_NavCosts|Questify_NavCosts|1|0|0'
  'PolestarNavChokepoints|QuestifyNavChokepoints|8|0|0'
  '"Polestar_Nav_EK"|"Questify_Nav_EK"|1|0|0'
  '"Polestar_Nav_Kalimdor"|"Questify_Nav_Kalimdor"|1|0|0'
)
DIRS=(Nav EK Kalimdor)
srcDir() { case "$1" in Nav) echo Polestar_Nav ;; EK) echo Polestar_Nav_EK ;; Kalimdor) echo Polestar_Nav_Kalimdor ;; esac; }
newDir() { case "$1" in Nav) echo Questify_Nav ;; EK) echo Questify_Nav_EK ;; Kalimdor) echo Questify_Nav_Kalimdor ;; esac; }

# count <dossier> <jeton> : occurrences dans les .lua du dossier (lecture binaire).
count() { find "$1" -name '*.lua' -print0 | xargs -0 cat | LC_ALL=C grep -a -o -F -- "$2" | wc -l | tr -d ' '; }
# expected <ligne RENAMES> <clé> : compte attendu pour Nav, EK ou Kalimdor.
expected() { local f t a b c; IFS='|' read -r f t a b c <<<"$1"; case "$2" in Nav) echo "$a" ;; EK) echo "$b" ;; Kalimdor) echo "$c" ;; esac; }

# 1. Comptes avant (source).
for r in "${RENAMES[@]}"; do
  from="${r%%|*}"
  for k in "${DIRS[@]}"; do
    exp="$(expected "$r" "$k")"; got="$(count "$SRC/$(srcDir "$k")" "$from")"
    [ "$got" = "$exp" ] || fail "$(srcDir "$k") : $got occurrence(s) de $from, $exp attendue(s)"
  done
done
echo "Comptes source conformes."

# 2. Copie dans un dossier temporaire : la cible n'est touchée qu'une fois tout vérifié.
TMP="$(mktemp -d "${TMPDIR:-/tmp}/questify-nav.XXXXXX")" || fail "mktemp"
trap 'rm -rf "$TMP"' EXIT
for k in "${DIRS[@]}"; do
  cp -R "$SRC/$(srcDir "$k")" "$TMP/$(newDir "$k")" || fail "copie de $(srcDir "$k")"
  find "$TMP/$(newDir "$k")" \( -name '.DS_Store' -o -name '._*' -o -name '*.toc' \) -delete
done

# 3. Renommages octet à octet.
for r in "${RENAMES[@]}"; do
  IFS='|' read -r from to _ <<<"$r"
  find "$TMP" -name '*.lua' -print0 | FROM="$from" TO="$to" xargs -0 env LC_ALL=C perl -pi -e 's/\Q$ENV{FROM}\E/$ENV{TO}/g' \
    || fail "perl a échoué sur $from"
done

# 4. Comptes après : la cible a les comptes de la source, la source a disparu.
for r in "${RENAMES[@]}"; do
  IFS='|' read -r from to _ <<<"$r"
  for k in "${DIRS[@]}"; do
    d="$TMP/$(newDir "$k")"; exp="$(expected "$r" "$k")"
    [ "$(count "$d" "$from")" = "0" ] || fail "$(newDir "$k") : $from subsiste"
    got="$(count "$d" "$to")"
    [ "$got" = "$exp" ] || fail "$(newDir "$k") : $got occurrence(s) de $to, $exp attendue(s)"
  done
done
echo "Comptes cible conformes."

# 5. TOC : en-têtes Questify, liste de fichiers identique à la source.
fileList() { grep -v '^#' "$1" | tr -d '\r' | sed '/^$/d'; }
AUTHOR="## Author: Questify; router: Polestar, from Shortest Path Forever by Cillian Berragan; maps: Leffe"
{
  cat <<T
## Interface: 16001
## Title: Questify Nav
## Notes: Questify's walking router: routes on foot for the arrow, taken from Polestar's router, itself started from Shortest Path Forever's pathing (Cillian Berragan, used with his permission). Loaded on demand.
## Title-frFR: Questify Nav
## Notes-frFR: Routeur de marche de Questify : itinéraires à pied pour la flèche, repris du routeur de Polestar, lui-même issu de celui de Shortest Path Forever (Cillian Berragan, utilisé avec sa permission). Chargé à la demande.
$AUTHOR
## Version: $VERSION_ATTENDUE
## LoadOnDemand: 1
## Dependencies: Questify
## X-License: GPL-3.0-or-later

T
  fileList "$SRC/Polestar_Nav/Polestar_Nav.toc"
} > "$TMP/Questify_Nav/Questify_Nav.toc"

# dataToc <clé> <titre> <notes en> <notes fr> <commentaire>
dataToc() {
  local nd sd; nd="$(newDir "$1")"; sd="$(srcDir "$1")"
  {
    cat <<T
## Interface: 16001
## Title: $2
## Notes: $3
## Title-frFR: $2
## Notes-frFR: $4
$AUTHOR
## Version: $VERSION_ATTENDUE
## LoadOnDemand: 1
## Dependencies: Questify_Nav
## X-License: GPL-3.0-or-later

# $5

T
    fileList "$SRC/$sd/$sd.toc"
  } > "$TMP/$nd/$nd.toc"
}
dataToc EK "Questify Nav (Eastern Kingdoms)" \
  "Walking maps of the Eastern Kingdoms for Questify's arrow, from Leffe's navigation maps. Loaded on demand on that continent." \
  "Cartes de marche des Royaumes de l'Est pour la flèche de Questify, tirées des cartes de navigation de Leffe. Chargé à la demande sur ce continent." \
  "Parties de cartes chargées par le routeur de Questify_Nav à la première recherche dans les Royaumes de l'Est."
dataToc Kalimdor "Questify Nav (Kalimdor)" \
  "Walking maps of Kalimdor for Questify's arrow, from Leffe's navigation maps. Loaded on demand on that continent." \
  "Cartes de marche de Kalimdor pour la flèche de Questify, tirées des cartes de navigation de Leffe. Chargé à la demande sur ce continent." \
  "Parties de cartes chargées par le routeur de Questify_Nav à la première recherche à Kalimdor."

# 6. PACK.json : noms renommés, sha256 recalculés, origine notée.
python3 - "$TMP" "$VERSION_ATTENDUE" <<'PY' || fail "PACK.json"
import hashlib, json, os, sys
tmp, version = sys.argv[1], sys.argv[2]
path = os.path.join(tmp, "Questify_Nav", "PACK.json")
d = json.load(open(path))
d["origin"] = {"addon": "Polestar_Nav", "version": version,
               "note": "copied by tools/nav/import_polestar_nav.sh; code tokens renamed Polestar -> Questify, sha256 recomputed"}
for m in d["maps"].values():
    if m.get("part", "").startswith("Polestar_"):
        m["part"] = m["part"].replace("Polestar_", "Questify_", 1)
files = {}
for k in d["files"]:
    nk = k.replace("Polestar_Nav", "Questify_Nav", 1)
    base = tmp if nk.startswith("Questify_Nav_") else os.path.join(tmp, "Questify_Nav")
    with open(os.path.join(base, nk), "rb") as f:
        files[nk] = hashlib.sha256(f.read()).hexdigest()
d["files"] = files
with open(path, "w") as f:
    json.dump(d, f, indent="\t", ensure_ascii=False)
    f.write("\n")
PY

# 7. LICENSE (GPL-3.0) de Polestar_Nav dans les trois dossiers ; CREDITS.md conservé.
for k in "${DIRS[@]}"; do
  cp "$SRC/Polestar_Nav/LICENSE" "$TMP/$(newDir "$k")/LICENSE" || fail "LICENSE"
done
cp "$ROOT/Questify_Nav/CREDITS.md" "$TMP/Questify_Nav/CREDITS.md" || fail "CREDITS.md"

# 8. Mise en place.
for k in "${DIRS[@]}"; do
  d="$(newDir "$k")"
  rm -rf "${ROOT:?}/$d"
  cp -R "$TMP/$d" "$ROOT/$d" || fail "installation de $d"
done
echo "Questify_Nav, Questify_Nav_EK et Questify_Nav_Kalimdor installés."
