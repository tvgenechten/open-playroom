# Open Playroom

![version](https://img.shields.io/static/v1?label=version&message=0.0.0&color=2E6B4F)
![license](https://img.shields.io/badge/license-MIT-blue)

**Open-source games without ads, tracking or internet.** Simple, calm games for phones and tablets, made for people who are not at home with smartphones. The app is in Dutch.

- **No ads, no purchases, no accounts.** Open it and play.
- **Works offline, collects nothing.** The app has no network access at all ([privacy](docs/PRIVACY.md)).
- **Easy to use:** big buttons, big text, no timers, and a clear "Terug" button in every game.
- **Phones and tablets**, Android and iOS, portrait and landscape.

## Games

| Game | What you do |
| --- | --- |
| Memory | Turn over cards two at a time and find the pairs. |

Want to add one? See [CONTRIBUTING §7](CONTRIBUTING.md#7-adding-a-game).

## Run it

You need the Flutter version pinned in [`pubspec.yaml`](pubspec.yaml) (`environment.flutter`).

```sh
flutter pub get
flutter run                 # on a connected device or simulator
dart format . && flutter analyze && flutter test
```

## Project

- [CONTRIBUTING.md](CONTRIBUTING.md): how we work, for humans and AI agents
- [docs/RELEASING.md](docs/RELEASING.md): how a version gets to the stores
- [CHANGELOG.md](CHANGELOG.md), [SECURITY.md](SECURITY.md), [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)

Not planned yet (ideas, not promises): more games, remembering progress, sound.

## License

[MIT](LICENSE)
