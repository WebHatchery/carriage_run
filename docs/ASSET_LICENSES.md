# Asset license inventory

All files under assets/images/, assets/data/, and
assets/packaging/carriage_run.ico are original Carriage Run project assets
created for WebHatchery and distributed with the game under the repository's
project license. No external stock images or music files are bundled.

Carriage Run uses Rajdhani SemiBold from Indian Type Foundry. The toolkit
embeds the runtime font, and `assets/fonts/english.ttf` and
`assets/fonts/latin_extended.ttf` are byte-identical provenance copies of that
same font (SHA-256
`94bbd25a18ca665999feb05a537de9fd2b860dcfb78bbe9ca00270825bf235da`).
Rajdhani is distributed under the SIL Open Font License 1.1. The required
copyright and license text is checked in at
`assets/licenses/OFL-Rajdhani.txt` and included in packaged builds.

The runtime audio bed is generated deterministically by src/audio.rs through
the shared toolkit synthesizer, so it has no third-party audio license.

Run scripts/generate_license_inventory.ps1 after changing a dependency or
asset. It resolves only Carriage Run's locked transitive Cargo graph, scans the
asset tree, and refreshes the evidence in docs/THIRD_PARTY_LICENSES.md.

Creation/edit history, binary hashes, generative-AI evidence, and unresolved
human attestations are recorded separately in `docs/ASSET_PROVENANCE.md`. Run
`scripts/audit_asset_provenance.ps1` after changing any shipped asset. The
project-original statement above is a rights assertion that still requires the
publisher's creator/assignment/tool-terms confirmation before public release.
