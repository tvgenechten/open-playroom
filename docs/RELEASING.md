# Releasing

Releases follow GitFlow (CONTRIBUTING §1) and are driven by GitHub Actions workflows.

```
develop ──release-start──▶ release/X.Y.Z ──PR (merge commit)──▶ main ──tag vX.Y.Z
                               │                                   │
                          test-release                       release-finish
                    (Play internal + TestFlight)        (tag, draft release, back-merge PR)
                                                                   │
                                                     you publish the draft release
                                                                   │
                                                                 prod
                                              (Android: internal → production;
                                               iOS: submit for review by hand)
```

## Step by step

1. **Actions → release-start → Run workflow**, version `X.Y.Z` (kind `hotfix` to branch from `main` instead).
   It creates `release/X.Y.Z`, writes the version into `pubspec.yaml` and the README badge, prepends the section to `CHANGELOG.md`, opens the pull request into `main` and dispatches `test-release`.
2. **test-release** builds the branch and uploads it to the Play **internal testing** track and **TestFlight**. Install it on a phone and a tablet and try it. A fix goes onto the release branch as a normal commit; run `test-release` again on that branch afterwards.
3. **Merge the release pull request with a merge commit.** Pull requests opened by a workflow wait behind "Approve workflows to run"; run `ci` by hand on the branch if you want the checks.
4. **release-finish** runs on the merge: tags `vX.Y.Z`, drafts the GitHub release with the changelog section, and opens the back-merge pull request into `develop`. Merge that one too.
5. **Publish the draft release.** That fires **prod**, which promotes the tested Android build from internal testing to production.
6. **iOS:** in App Store Connect, add the TestFlight build of this version to the version page and submit it for review.

The build number is the number of commits on the branch (`git rev-list --count HEAD`), so it goes up with every build, as both stores require.

## Workflows

| Workflow | Trigger | Does |
| --- | --- | --- |
| `ci` | pull request into `develop`/`main` | PR title check, format, analyze, tests (incl. the no-network check), debug APK build |
| `release-start` | manual | release/hotfix branch, version, changelog, PR into `main`, dispatches `test-release` |
| `test-release` | dispatched / manual on `release/*`, `hotfix/*` | signed AAB → Play internal; signed IPA → TestFlight |
| `release-finish` | release PR merged into `main` | tag, draft GitHub release, back-merge PR |
| `prod` | GitHub release published | Play: promote internal → production |

## Secrets and variables

Set them in **Settings → Secrets and variables → Actions**. The workflows check for them and fail with the name of the one that is missing.

| Name | Kind | What |
| --- | --- | --- |
| `ANDROID_KEYSTORE_BASE64` | secret | upload keystore, `base64 -i upload.jks` |
| `ANDROID_KEYSTORE_PASSWORD` | secret | keystore password |
| `ANDROID_KEY_ALIAS` | secret | key alias in the keystore |
| `ANDROID_KEY_PASSWORD` | secret | key password |
| `PLAY_SERVICE_ACCOUNT_JSON` | secret | Google Cloud service account JSON with release access in Play Console |
| `APP_STORE_CONNECT_KEY_ID` | secret | App Store Connect API key ID (role Admin, needed for cloud signing) |
| `APP_STORE_CONNECT_ISSUER_ID` | secret | issuer ID shown above the API keys |
| `APP_STORE_CONNECT_KEY_BASE64` | secret | the `.p8` key, `base64 -i AuthKey_XXXX.p8` |
| `APPLE_TEAM_ID` | variable | 10-character Apple team ID |

Create the upload keystore once:

```sh
keytool -genkey -v -keystore upload.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Keep the keystore and its passwords in a password manager. Losing them means asking Google to reset the upload key.

## First release only

The stores need a few manual steps before any workflow can upload:

- **Play Console:** create the app `app.openplayroom`, upload the first AAB by hand (`flutter build appbundle` with `android/key.properties` set up locally), fill in the store listing, content rating and data safety ("no data collected"), and give the service account release access.
- **App Store Connect:** register the bundle ID `app.openplayroom`, create the app, fill in the listing and the privacy label ("Data not collected").
- Privacy policy URL for both: `https://github.com/tvgenechten/open-playroom/blob/main/docs/PRIVACY.md`.

## When it goes wrong

- **The release PR was squashed or rebased.** `release-finish` warns in its summary and in the release notes. Resolve the back-merge conflicts by keeping the `main` side of `CHANGELOG.md` and `pubspec.yaml`.
- **A store rejects the build number.** A build with that number was already uploaded; push a commit to the release branch (any fix) and run `test-release` again.
