-- Génère Questify/Data/Changelog.lua depuis CHANGELOG.md : le journal des versions montré dans les options
-- (UI/ChangelogPanel.lua). luajit tools/build_changelog.lua [--check]
--   --check : n'écrit rien, code de retour 1 si le fichier livré n'est pas à jour.
-- Les MAX_VERSIONS dernières sections « ## » (« Unreleased » comprise), chacune en anglais et en français
-- (sous-sections « ### English » et « ### Français ») : titres en gras, puces, lignes de suite repliées.
local MAX_VERSIONS = 8
local root = (arg and arg[0] or "tools/build_changelog.lua"):match("^(.*)/tools/[^/]*$") or "."
local SRC, OUT = root .. "/CHANGELOG.md", root .. "/Questify/Data/Changelog.lua"
local check = arg and arg[1] == "--check"

local function read(p)
  local f = io.open(p, "rb")
  if not f then return nil end
  local s = f:read("*a"); f:close()
  return s
end

local md = assert(read(SRC), "CHANGELOG.md introuvable")
local versions, cur, lang = {}, nil, nil
for line in (md .. "\n"):gmatch("([^\n]*)\n") do
  line = line:gsub("\r", "")
  local v = line:match("^## (.+)$")
  if v then
    if #versions >= MAX_VERSIONS then break end
    cur = { title = v, en = {}, fr = {} }
    versions[#versions + 1] = cur
    lang = nil
  elseif cur and line:match("^### English") then
    lang = "en"
  elseif cur and line:match("^### Fran") then
    lang = "fr"
  elseif cur and lang then
    local list = cur[lang]
    local bold = line:match("^%*%*(.-)%*%*%s*$")
    local item = line:match("^%- (.*)$")
    if bold then
      list[#list + 1] = { kind = "head", text = bold }
    elseif item then
      list[#list + 1] = { kind = "item", text = item }
    elseif line:match("^%s+%S") and #list > 0 then
      list[#list].text = list[#list].text .. " " .. line:gsub("^%s+", "")
    end
  end
end

local function q(s) return string.format("%q", s):gsub("\\\n", "\\n") end

local out = {
  "local addonName, Q = ...",
  "-- Généré par tools/build_changelog.lua depuis CHANGELOG.md. Ne pas modifier à la main.",
  "-- Journal des versions des options (UI/ChangelogPanel.lua) : les " .. MAX_VERSIONS .. " dernières versions,",
  "-- lignes { kind = \"head\" | \"item\", text } en anglais (en) et en français (fr).",
  "Q.ChangelogData = {",
}
for _, v in ipairs(versions) do
  out[#out + 1] = "  { title = " .. q(v.title) .. ","
  for _, lg in ipairs({ "en", "fr" }) do
    out[#out + 1] = "    " .. lg .. " = {"
    for _, l in ipairs(v[lg]) do
      out[#out + 1] = "      { kind = " .. q(l.kind) .. ", text = " .. q(l.text) .. " },"
    end
    out[#out + 1] = "    },"
  end
  out[#out + 1] = "  },"
end
out[#out + 1] = "}"
local text = table.concat(out, "\n") .. "\n"

if check then
  if read(OUT) ~= text then
    io.stderr:write("Questify/Data/Changelog.lua n'est pas à jour : luajit tools/build_changelog.lua\n")
    os.exit(1)
  end
  print("build_changelog : à jour")
  return
end
local f = assert(io.open(OUT, "wb"))
f:write(text)
f:close()
print("build_changelog : " .. #versions .. " versions écrites dans Questify/Data/Changelog.lua")
