# Bloom iOS

SwiftUI library powering the Bloom onboarding flow.

This package will be expanded with a full README in task T15. For now, this scaffold provides:

- `Package.swift` declaring the `Bloom` library product for iOS 16+ (also builds on macOS 13+ so `swift build` works on host machines for CI / library validation).
- Source tree under `Sources/Bloom/`.

## Quick verification

```sh
cd bloom-ios
swift build
swift test
```

A complete integration guide (Xcode app target wiring, design-token reference, file map) will land in T15.
