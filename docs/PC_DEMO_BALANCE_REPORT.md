# Carriage Run Option A demo balance report

Recorded: 2026-08-27

## Scope and method

The deterministic harness ran every combination of the four approved
contracts, two authored routes, three difficulty presets, four driving
policies, and five stable seeds: **480 route runs** in total. The representative
campaign uses the Scout Cart on The Muddy Road, then a Standard Wagon plus the
opening Iron Plating level. The Bonebridge profile spends the plausible first
two-contract budget on a Shield Guard and Emergency Repair Kit.

The raw matrix is `docs/verification/demo_balance_report.csv`. It records wins,
carriage and cargo condition, reward, active route seconds, threats, and hazards
for each mission/route/preset group.

This is an automated pressure test, not a human skill model. Route seconds
exclude reading, tutorial pauses, loadout decisions, upgrades, results, retries,
and exploration; they cannot establish or approve a 20–40 minute public
session-length claim.

## Findings and contained tuning

The first representative run exposed a credible blocker: the full-campaign
Bonebridge values produced no successful automated runs with an affordable demo
loadout. The demo data now keeps the authored enemies, hazards, route choices,
rewards, and fork but shortens Bonebridge from 1320 to 780 road units and uses a
0.50 demo difficulty scalar. The three earlier contracts also use gentler demo
scalars (0.72, 0.82, and 0.84) so the tutorial slice does not assume later-game
power. Full-game mission data is unchanged.

After tuning, every Standard route completes in at least 7 of 20 deterministic
runs and lasts at least 30 active seconds on average. Standard results are:

| Contract / route | Wins | Success | Avg active seconds |
| --- | ---: | ---: | ---: |
| Muddy Road / Wagon Track | 10/20 | 50% | 58.4 |
| Muddy Road / Old Shortcut | 11/20 | 55% | 48.1 |
| Bandit Bend / Guarded Crossing | 11/20 | 55% | 67.5 |
| Bandit Bend / Smugglers Cut | 7/20 | 35% | 45.9 |
| Courier Deadline / Main Road | 11/20 | 55% | 57.8 |
| Courier Deadline / River Ford | 9/20 | 45% | 46.4 |
| Bonebridge Pass / Chapel Road | 8/20 | 40% | 49.9 |
| Bonebridge Pass / Crypt Bridge | 8/20 | 40% | 33.3 |

The route tradeoffs remain visible: safer routes generally take longer, while
Smugglers Cut and Crypt Bridge are shorter and more volatile. The balance test
now fails if any Standard route falls below 7/20 completions or 30 average
active seconds.

## Remaining validation

External players still need to validate tutorial success, upgrade comprehension,
branch choice clarity, retries, real session duration, frustration, and whether
the final road feels climactic rather than merely difficult. No public duration
or difficulty claim should be made from this simulation alone.
