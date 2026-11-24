# Changelog

All notable changes to `my_commons` are documented in this file.
The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## 1.0.0 - 2026-11-24

- Updated the minimum SDK versions to Flutter 3.50.1 and Dart 3.14.0.
- Migrated the checkbox and dropdown helpers to the official `material_ui`
  package. Apps using these helpers should migrate their Material app and theme
  imports to the same package.

## 0.0.5 - 2026-10-15

### Added

- BigDecimal helpers for safely handling decimal amounts:
  - `bdParse` — parses numbers, strings, and `BigDecimal` input, falling back to
    `BigDecimal.zero` (or a custom `orElse`) on null, empty, or unparsable input.
  - `bdOrZero` — null-safe accessor so arithmetic works without `!`.
  - `bdNormalize` / `bdText` — strips trailing decimal zeros for display
    (`12.000` -> `12`, `1.50` -> `1.5`, `-0.0` -> `0`).
  - `bdToNum` — converts back to an `int` when the value is whole, a `double`
    when a fraction remains, and preserves `null`.
  - `bdIsZero` — zero check that treats `null` as zero.
- `DecimalTextInputFormatter` — quantity input formatter limiting entries to three
  decimal places, with an `allowNegative` option for send/receive style fields.

## 0.0.4 - 2026-05-07

### Fixed

- `getMin` and `getMax` no longer throw on an empty list; both return `""`.

## 0.0.3 - 2026-04-15

### Added

- `buildCheckboxes` — wrapping multi-select checkbox group driven by a
  `Map<String, String>` display map.
- `buildDropdownList` — borderless dropdown form field with enabled/disabled states.

## 0.0.2 - 2025-12-18

### Added

- `getShortUuid` — converts a full UUID into a compact display code.

## 0.0.1 - 2025-12-10

### Added

- Initial release.
- `getMin` and `getMax` for lexicographic min/max over a list of strings.
