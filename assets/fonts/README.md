# Font fallback assets

These two files are byte-identical provenance copies of the Rajdhani SemiBold
font embedded by macroquad-toolkit. They are retained under the game asset tree
for language and release audits; the runtime currently uses the toolkit's
embedded copy rather than loading these paths from the packaged asset tree.

Rajdhani is Copyright (c) 2014 Indian Type Foundry and licensed under the SIL
Open Font License 1.1. The license is stored at
`assets/licenses/OFL-Rajdhani.txt` and is included in packaged builds.

German and French use latin_extended.ttf first, then english.ttf. The
localization audit checks long strings before release.
