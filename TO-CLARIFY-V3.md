# TO-CLARIFY-V3 — Empfohlene strukturelle Verbesserungen

**Prinzip:** Struktur vor Inhalt — zuerst IA + Platzhalter, dann Texte.

---

## 1. Dokumentationsquellen


| Quelle                                           | URL                                                                           | Themen                                                                                                                                                                                                                        |
| ------------------------------------------------ | ----------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **dieses Repo** (`madek-documentation`)          | [madek.readthedocs.org](https://madek.readthedocs.org/)                       | Technische System- / Entwicklerdokumentation; Architektur; Concepts; `/admin` (Systemmodell + Dev-Guide, siehe §5); API-Orientierung (Hub, Auth, Konsumenten) — **keine** Endpoint-Reference; **keine** reine Admin-Bedienung |
| **User-Doku**                                    | [doku.madek.ch](https://doku.madek.ch/)                                       | Endnutzer-**Hilfe**: How-tos (Upload, Sets, Suche, …); fachliche Grundkonzepte; UI-Erklärung; FAQ; Glossar; nutzerseitige API-Einführung; ZHdK-Instanz (`zhdk/`: …)                                                           |
| **API Browser**                                  | [zhdk.medienarchiv.ch/api/browser](https://zhdk.medienarchiv.ch/api/browser/) | Endpoint-/Schema-Reference **API**                                                                                                                                                                                            |
| **Swagger UI**                                   | [api-v2/api-docs](https://zhdk.medienarchiv.ch/api-v2/api-docs/index.html#/)  | Endpoint-/Schema-Reference **API-v2**                                                                                                                                                                                         |
| **Medienarchiv-Wiki**                            | [wiki.zhdk.ch/medienarchiv](https://wiki.zhdk.ch/medienarchiv/doku.php)       | **Support** / ticketnahe Hilfe (nicht Endnutzer-Handbuch)                                                                                                                                                                     |
| **Slack-Channels** (intern / #madek-development) | —                                                                             | Quelle für operatives Wissen — **nicht kanonisch** (Policy: §5)                                                                                                                                                               |


---

## 2. Zielstruktur

Organisation nach Nutzungskontext:

```text
madek-documentation
├── Start here              # Scope; Links nach aussen; Navigationshilfe; Madek at a glance
├── Concepts & system       # Permissions, Feature Groups, Uberadmin (/admin Systemmodell), …
├── Developing Madek        # Setup, Conventions, Frontend, /admin Dev-Guide, Error handling, …
├── API (dünn)              # Hub: API vs API-v2, Auth, Konsumenten — keine Reference
├── Architecture            # Entities, DB, Services, MetaData-Config, Filters
└── Project                 # Branches, Review, Releases, Docs contribution
```

**Grenzen der Ebenen:**


| Ebene           | Fokus                                          |
| --------------- | ---------------------------------------------- |
| `concepts/`     | Warum/Wie das System denkt (Verhalten, Modell) |
| `developing/`   | Wie man entwickelt (Guides, Conventions)       |
| `architecture/` | Wo im Code/DB/Services (Referenz)              |
| `project/`      | Beitrag & Prozess                              |
| `api/`          | Orientierung — keine Endpoint-Reference        |


Querverweise statt Doppeltexte.

---

## 3. Scope & Zielgruppen


|            | Empfehlung                                                                   |
| ---------- | ---------------------------------------------------------------------------- |
| Scope      | Technische System- und Entwicklerdokumentation — keine Endnutzer-Hilfe       |
| Primär     | Entwickler (Einsteiger + Daily), technisches Systemverständnis               |
| Sekundär   | API-Integratoren; Admins mit System-/Config-Bezug (`/admin`)                 |
| Nicht hier | Endnutzer-How-tos, reine `/admin`-Bedienung, ZHdK-Instanz-Spezifika, Support |


**Startseite** beantwortet nur: *Was ist dieses Repo? Für wen? Wo sonst nachschauen?*

---

## 4. Mapping Ist → Soll


| Heute                                                                   | Vorschlag                                                                      |
| ----------------------------------------------------------------------- | ------------------------------------------------------------------------------ |
| `architecture/*`, `entities.md`                                         | bleiben — Kern in `architecture/`                                              |
| `developer_rules*`, `frontend`, `ui/*`, `error-handling`, `translation` | `developing/`                                                                  |
| `media-types`, `embeds`                                                 | `concepts/`                                                                    |
| `git-reflow`, `submit_and_review_process`, Branch/Merge auf `index`     | `project/`                                                                     |
| `v2_routes.md`                                                          | entfernen/ersetzen — Policy: §7                                                |
| `features.md`                                                           | aufteilen — Policy: §5                                                         |
| `madek_dev_tips.md`                                                     | kein eigener Hauptbereich — Entscheidung: §6                                   |
| `index.md` TMP / External Contributors                                  | Startseite schlank; Rest → `project/`                                          |
| TEMP/`<mark>`-Seiten                                                    | aktualisieren, verschieben oder entfernen — nicht dauerhaft auf der Startseite |


---

## 5. Grauzonen — Empfehlungen (entschieden)


| Thema                     | Empfehlung                                                                                                               |
| ------------------------- | ------------------------------------------------------------------------------------------------------------------------ |
| `features.md`             | **aufteilen** (technisch hier / nutzerseitig User-Doku)                                                                  |
| `/admin` / Uberadmin      | **hier:** Systemmodell (`concepts/uberadmin`) + Dev-Guide (`developing/admin-interface`); **Bedienung** → User-Doku/Wiki |
| Surfaces                  | Webapp / `/admin` / API in Big Picture klar benennen; Grenze wie oben                                                    |
| Fachliche Workflows       | **User-Doku**; hier nur technische Lifecycles                                                                            |
| `copyright.md`            | **Systemmodell hier** (`developing/`); Rechtliches → User-Doku/ZHdK                                                      |
| Ops / Deploy / Hosting    | vorerst **kein** voller Ops-Bereich; Slack nur Quelle, nicht Pflegeort                                                   |
| Slack-Channels            | **nicht** als Doku-Ort; nützliche How-tos aus Channels **extrahieren** und hier oder Wiki ablegen                        |
| Local Dev Setup / Testing | **Slot in `developing/`** vorsehen (auch als Platzhalter)                                                                |
| Sprache                   | vorerst Ist-Zustand (**EN**) beibehalten                                                                                 |


---

## 6. Offene Entscheidungen


| Thema                | Optionen / Frage                                                                                             | Entscheidung nötig                                                      |
| -------------------- | ------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------- |
| Search / Indexierung | eigener Concept-Slot **oder** bewusst weglassen                                                              | weglassen                                                               |
| `madek_dev_tips.md`  | übernehmen / löschen / intern belassen                                                                       | übernehmen                                                              |
| Ops-How-tos          | wo landen praxisnahe Anleitungen (z. B. Bot-Attacke → IPs per Apache blocken): **dieses Repo** vs. **Wiki**? | dieses repo                                                             |
| Featurescape-PDF     | nur Link — genauer Ort unter `start/` (welche Seite / Abschnitt)?                                            | ja, in der overview wo alle links/externen resourcen aufgelistet werden |


---

## 7. Auffindbarkeit

Startseite mit klaren Pfaden:

- Endnutzer-**Hilfe** → doku.madek.ch (User-Doku)
- Entwickeln / integrieren → bleib hier
- **Support** / Tickets → Wiki

Plus kurze Navigationshilfe *innerhalb* des Repos (Concepts vs. Architecture vs. Developing vs. API).

Einstiegspfade:

1. Verstehen → `madek-at-a-glance` → `concepts/` → `architecture/`
2. Entwickeln → `developing/` → `architecture/` → `project/`
3. API → `api/` → Swagger / API Browser
4. Endnutzer-Hilfe → User-Doku; Support → Wiki

---

## 8. API-Bereich


| Punkt               | Empfehlung                                                    |
| ------------------- | ------------------------------------------------------------- |
| Endpoint-Reference  | **nur** Swagger / API Browser                                 |
| Hier                | schlanke Hub-Seite (+ Auth, API vs API-v2, Konsumenten)       |
| Unterseiten         | `auth`, `consumers`, `api-vs-api-v2`                          |
| `v2_routes.md`      | nicht weiterpflegen — entfernen / durch Swagger-Link ersetzen |
| Konsumenten-Details | erst nach festgelegter Struktur                               |


---

## 9. Big Picture — was hier stehen muss


| Thema                                               | Empfehlung                               |
| --------------------------------------------------- | ---------------------------------------- |
| Komponenten & Request-Fluss                         | Platzhalter in `start/madek-at-a-glance` |
| Upload → Preview → Publish (technisch)              | 1–2 technische Lifecycles                |
| Permissions / Metadata                              | in eigene Hauptseiten ausbauen           |
| Feature Groups, Uberadmin (`/admin`), Notifications | neue Concept-Seiten (§5)                 |
| ResourceFilters                                     | Konzept + ggf. Architecture-Verweis      |
| Surfaces: Webapp vs. `/admin` vs. API               | in `madek-at-a-glance` explizit trennen  |
| Fachliche Bedienung                                 | nur Verweis auf User-Doku                |


---

## 10. Weitere Struktur-Schärfungen


| Punkt                    | Empfehlung                                                                         |
| ------------------------ | ---------------------------------------------------------------------------------- |
| Instanz-Links            | ZHdK-Swagger/Browser als Beispiel kennzeichnen oder instanzneutrale Pfade ergänzen |
| Eine Quelle der Wahrheit | pro Thema kanonisch; sonst nur Link                                                |
| Inventory                | jede heutige Datei → bleiben / verschieben / splitten / löschen / nur Link         |


---

## 11. Erfolgskriterien (Struktur „gut genug“)

- Einsteiger findet in < 2 Klicks „Madek at a glance“ und den passenden Bereich
- Keine Endnutzer-How-tos mehr auf der Startseite
- Jede bestehende Datei hat ein Mapping
- API-Bereich enthält keine Endpoint-Reference
- Außenorte (User-Doku = Hilfe, Wiki = Support, Swagger) sind von `start/` aus offensichtlich
- Offene Entscheidungen (§6) sind geschlossen oder bewusst deferred

