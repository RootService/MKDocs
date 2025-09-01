# Sicherheitsrichtlinien

## Unterstützte Versionen
Wir unterstützen ausschließlich den aktuellen Stand des `main`-Branches. Releases werden über CI/CD veröffentlicht. Ältere Versionen erhalten keine Sicherheitsupdates.

## Meldung von Sicherheitslücken
Bitte melde Schwachstellen **nicht öffentlich** via Issue Tracker. Verwende stattdessen:

- E-Mail: `security@rootservice.org`
- PGP-Key: Siehe [.well-known/security.txt](.well-known/security.txt)

Wir bestätigen Empfang innerhalb von 72 Stunden und streben einen Fix innerhalb von 14 Tagen an.

## Richtlinien
- Offenlegung in Abstimmung mit Melder.
- Proof of Concept willkommen, aber keine Exploits gegen Dritte.
- Sicherheitsfixes gehen direkt in `main` und werden so schnell wie möglich released.

## Bekannte Themen
- CSP Reports werden serverseitig gesammelt.
- Keine sensiblen Benutzerdaten, da statisches MkDocs-Portal.

## Lizenz
Hinweise unterliegen der [LICENSE](LICENSE).
