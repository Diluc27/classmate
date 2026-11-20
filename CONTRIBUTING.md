# Contributing to Ateno

Development guidelines and standards for contributing to the Ateno codebase.

## 1. Branch & Review Workflow
- Work on dedicated branches with one focused change per branch.
- Do not push directly to `master`.
- Merges to `master` require code review and passing checks.

## 2. Pre-Submission Gate
Before opening a change or requesting review, ensure that both static analysis and the test suite pass cleanly:
```bash
flutter analyze
flutter test
```

## 3. Database Table and Provider Changes
When modifying Drift database tables or Riverpod providers:
1. Increment `schemaVersion` in `lib/core/database/app_database.dart`.
2. Add a `MigrationStrategy.onUpgrade` step handling the schema delta.
3. Run code generation:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
4. Add automated tests covering the updated schema or provider behavior.

## 4. Code Style & Conventions
- Adhere to lint rules defined by `flutter_lints` (configured in `analysis_options.yaml`).
- Keep changes small, surgical, and focused strictly on the task scope.

## 5. Security & Sensitive Files
- Never commit signing keystores, `key.properties`, certificates, or API keys.

## 6. Release Checklist
When preparing a release:
- Create the keystore outside the repo.
- Copy `key.properties.example` to `key.properties` and fill it in.
- Bump the `+N` build number in `pubspec.yaml` before each upload.
- Build with `flutter build appbundle --release`.
