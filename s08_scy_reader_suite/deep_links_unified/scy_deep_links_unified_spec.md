# 🔗 SCY-DEEP-LINKS-UNIFIED — SPÉCIFICATION TRANSVERSE (SPEC)
**ID** : S08_DEEP_LINKS_UNIFIED_SPEC · **Décisions** : D-OPT-002, D-COSMOS-019 · **Phase** : V1

## 1. Purpose
Les **Deep Links Sémantiques** sont un système **transverse** permettant de naviguer d'un élément (carte APEX, nœud COSMOS, citation de cours, document généré) vers la **position exacte** dans la source originale via la Reader Suite. Cette spec unifie les 5 points d'entrée.

## 2. Les 5 Points d'Entrée (surfaces)

| # | Surface | Déclencheur | Destination |
|---|---------|------------|-------------|
| 1 | **Carte APEX** (D-OPT-002) | Clic sur le deep link de la carte | Reader Suite → source à la position exacte (surlignée) |
| 2 | **Nœud COSMOS** (D-COSMOS-019) | Clic badge source (🎥📄🌐) sur le nœud | Reader Suite → source à la position exacte |
| 3 | **Citation cours ASCENT** | Clic sur l'exposant [N] | Reader Suite → source à la position exacte (surlignée) |
| 4 | **Document généré Mode Normal** | Clic sur citation [N] | Reader Suite → source à la position exacte |
| 5 | **Réponse BRAIN** | Clic sur citation inline [N] | Reader Suite → source à la position exacte |

## 3. Types de Position (selon format source)
- 🎥 **Vidéo** (YouTube/TikTok/Podcast) → **timestamp exact** (ex : `?t=83` → 01:23)
- 📄 **PDF/EPUB** → **page + CFI** (Canonical Fragment Identifier)
- 🌐 **Web** → **paragraphe/offset** (surlignage texte)
- ✍️ **Academic** → **DOI + page**

## 4. Requirements (RFC 2119)
- **GIVEN** Un élément lié à une source (carte/nœud/citation/document/réponse).
- **WHEN** L'utilisateur clique sur le deep link.
- **THEN** le système SHALL ouvrir la Reader Suite à la position exacte (timestamp/page/paragraphe).
- **AND** le passage source SHALL être surligné.
- **AND** le système SHALL préserver le contexte (retour possible à l'élément d'origine).

## 5. Tests
- TC1 : Carte APEX → clic → Reader Suite position exacte. | TC2 : Nœud COSMOS → clic badge → Reader Suite. | TC3 : Citation cours → clic [N] → Reader Suite. | TC4 : Vidéo → timestamp exact. | TC5 : PDF → page+CFI exact. | TC6 : Retour contexte préservé.
