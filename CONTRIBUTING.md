# Contributing to Open Playroom

These guidelines apply to **everyone** who changes this repository: human developers and AI agents (Claude Code, Codex, Gemini, Copilot, ...).

Open Playroom is a small games app for people who are not at home with smartphones: older players first. Every rule below serves two promises: **it stays simple to play**, and **it never talks to the internet**: no ads, no tracking, no accounts.

---

## 1. Workflow

- `develop` is the default branch; `main` holds what is released. Never push directly to either.
- Create a branch from an up-to-date `develop` named `<type>/<short-kebab-description>`, using the commit types from §2: `feat/word-search`, `fix/memory-double-tap`, `docs/privacy`.

### Pull requests

Every change goes through a pull request into `develop`. The rulesets require a pull request but no approval, because the project has one maintainer. Review your own diff as if it were somebody else's.

- **One concern per pull request.** A second concern, a rename or a formatting pass goes into its own pull request.
- Commits are one logical step each, with a subject that follows §2. Clean up `wip` commits before you open the pull request; `CHANGELOG.md` is generated from those subjects.
- The description is short and uses the five headings of the template:

  | Heading | Content |
  | --- | --- |
  | **What** | the change, in a few bullets |
  | **Why** | the problem it solves, or the task it comes from |
  | **Tested** | which tests you added and what you ran, and on which device sizes |
  | **To arrange** | what somebody has to set or create outside the repository (§8); `Nothing.` when there is nothing |
  | **AI** | which agent or model helped, and on what; leave it out if none did |

### Releases

Releases follow GitFlow and are driven by workflows, so two extra branch types exist. They carry a version instead of a description, and they are the only branches that target `main`:

| Branch | From | Into | Started by |
| --- | --- | --- | --- |
| `release/<version>` | `develop` | `main`, then back into `develop` | run `release-start` with the version |
| `hotfix/<version>` | `main` | `main`, then back into `develop` | run `release-start` with kind `hotfix` |

- Versions are `X.Y.Z` (the stores accept nothing else) and are tagged on `main` as `v<version>`.
- **Merge a release or hotfix pull request with a merge commit.** Squash and rebase replace the branch's commits, so the tag lands outside the history `develop` back-merges.
- The back-merge into `develop` is not optional: without it `develop` loses the version bump and the changelog.

See [`docs/RELEASING.md`](docs/RELEASING.md) for what each workflow does.

## 2. Commits and PR titles

Use [Conventional Commits](https://www.conventionalcommits.org/) with an optional scope:

```
type(scope): description
```

- **Types:** `feat`, `fix`, `refactor`, `test`, `docs`, `chore`
- **Scopes:** the game folder (`memory`, `word-search`), `ci`, or no scope for the app as a whole
- English, imperative mood, lowercase, no trailing period. CI checks the pull request title.

Examples: `feat(memory): add a bigger board`, `fix: keep the back button visible in landscape`, `docs: explain the release flow`.

## 3. Keep it minimal

The best code is the code never written. Solve the whole problem with the least new code. AI agents in this repo run the [ponytail](https://github.com/DietrichGebert/ponytail) plugin (`.claude/settings.json`); humans follow the same rules.

Take the first option that fully works:

1. **Does it need to exist?** Skip features, options and settings nobody asked for.
2. **Already in this codebase?** Use it the way the surrounding code does.
3. **Flutter or the Dart SDK?** Use it.
4. **An installed dependency?** Use it. Never add a package for a few lines.
5. Otherwise: the minimum code that works.

- No abstraction, wrapper, option or "for later" code nobody asked for (YAGNI). Deletion beats addition.
- Be lazy about the solution, never about the change: finish the tests and docs it needs.
- A shortcut with a known limit gets a comment in this form: `// shortcut: <the limit>, <when to upgrade>`.
- Don't leave dead code, commented-out code or unused imports. Don't refactor unrelated code in the same pull request.
- Never cut accessibility, the privacy rules (§6) or error handling that prevents lost progress.

## 4. Readability

- Clear, descriptive names over explanatory comments. Comments explain **why**, not **what**.
- Keep units small. These are limits, not targets:

  | Unit | Aim for | Hard limit |
  | --- | --- | --- |
  | Function / method / `build` | ≤ 20 lines | 40 lines |
  | File | ≤ 200 lines | 400 lines |
  | Parameters | ≤ 3 | 5 |

- Keep game rules in a plain Dart class without widgets (like `MemoryBoard`), so they can be tested without a screen.
- Formatting comes from `dart format`; lints from `analysis_options.yaml`. Both run in CI.
- All code, identifiers, comments, documentation and commit messages are in **English**. Everything the player sees is in **Dutch**.

## 5. The player comes first

Design every screen for somebody with weaker eyes, less steady hands and no patience for technology:

- **Dutch, plain words.** "Nog eens", not "Herstart sessie". No English in the UI.
- **Big:** tap targets at least 64×64 dp, body text at least 22 sp, and the theme in `lib/theme.dart` instead of hand-picked sizes.
- **No pressure:** no timers, countdowns, lives or scores by default. A game can always be finished.
- **Always a way back:** every game runs inside the screen with the labelled "Terug" button. Don't add a second navigation pattern.
- **Respect the system:** large system font and screen readers must keep working. Don't clamp the text scale; give tappable things a Dutch `Semantics` label.
- **Phone and tablet, portrait and landscape:** fit the screen with `LayoutBuilder` instead of fixed sizes.
- **Nothing that nags:** no notifications, pop-ups, rating prompts, purchases or sign-in.

## 6. Privacy and offline (hard rules)

- **No network code**, no ads, analytics, crash-reporting or tracking SDKs, no web views. `test/no_network_test.dart` fails the build when such a package appears in `pubspec.lock` or a permission appears in the Android manifest.
- **No new permissions** (Android manifest, iOS `Info.plist` usage strings) without a reason in the pull request; the stores' privacy labels say "collects no data" and must stay true.
- Anything the app remembers stays on the device.

## 7. Adding a game

1. Create `lib/games/<name>/` with the rules in a plain class (`<name>_board.dart` or similar) and the widget in `<name>_game.dart`. The widget returns only the playing field; the home screen adds the title bar and "Terug".
2. Register it with one entry in `lib/games/games.dart` (Dutch title + icon).
3. Add tests in `test/games/`: the rules as unit tests, plus at least one widget test. `test/home_screen_test.dart` already opens and closes every registered game.
4. Add a row to the games table in `README.md`.
5. Run it on a phone and a tablet (simulator is fine), in both orientations and with the largest system font.

## 8. Clean diffs and security

- Commit tests together with the code they cover. Never delete, skip or weaken a test just to make it pass.
- Don't commit debug output (`print`, `debugPrint`), scratch files or experiments. Put temporary files in `tmp/` (git-ignored).
- **Never commit secrets.** The signing keystore and store API keys exist only as GitHub secrets ([`docs/RELEASING.md`](docs/RELEASING.md)).
- Anything that has to be set outside this repository (a GitHub secret, a store setting) goes under **To arrange** in the pull request, with the exact steps.
- Only add dependencies from pub.dev, and explain in the pull request why the SDK is not enough.
- Report security problems privately ([`SECURITY.md`](SECURITY.md)), not in a public issue.

## 9. Definition of Done

A pull request is ready to merge when:

- [ ] `dart format`, `flutter analyze` and `flutter test` pass without new warnings;
- [ ] new behaviour is covered by tests;
- [ ] it follows §5 and was tried on a phone and a tablet size;
- [ ] it follows §6: no network, no new permissions without a reason;
- [ ] it covers one concern and the description follows §1;
- [ ] the code stays within the size limits (§4);
- [ ] there are no debug statements, temporary files or secrets in the diff;
- [ ] README and docs are updated if behaviour or setup changed;
- [ ] you reviewed your own diff first.

## 10. Rules for AI agents

On top of everything above, AI agents must:

1. Read this file before making changes.
2. Stay within the scope of the task. Ask before you add dependencies, permissions, change build or CI configuration, or delete existing files.
3. Keep the change reviewable (§1). When a task grows past one concern, propose a split.
4. Follow the existing code style and patterns of the surrounding code.
5. Run `dart format .`, `flutter analyze` and `flutter test` after making changes and report the results honestly, including failures.
6. Never commit, push or open a pull request unless the user explicitly asks for it.
7. Clean up every file they created that is not part of the final change.
8. When asked to open a pull request, use the five headings from §1 and name the agent or model under **AI**.
9. Write anything that has to be arranged outside the repository out in full in the final report and under **To arrange**, and say plainly that it is not done yet.
