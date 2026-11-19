# Instructions for AI agents

Before making any change, read [`CONTRIBUTING.md`](CONTRIBUTING.md) and follow it for every change.

Do not add rules to this file; the guidelines live in `CONTRIBUTING.md` only. This file is the one every agent reads (`CLAUDE.md` and `GEMINI.md` import it), so it only points the way.

## Quick reference

- Run: `flutter run` · check: `dart format . && flutter analyze && flutter test`
- Games live in `lib/games/<name>/` and are registered in `lib/games/games.dart` (CONTRIBUTING §7).
- Code and docs in English, everything the player sees in Dutch (§4).
- No network, ads or tracking, ever (§6).
- Issues are tracked in GitHub Issues on `tvgenechten/open-playroom`, using the `gh` CLI.
