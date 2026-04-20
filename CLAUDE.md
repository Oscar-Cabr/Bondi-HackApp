# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project context

@docs/bondi-mvp.md
@docs/bondi-prd.md

## Build & Run

This is an Xcode project — there is no CLI build script. All build/run/test actions go through Xcode or `xcodebuild`.

```bash
# Build (simulator)
xcodebuild -project Bondi.xcodeproj -scheme Bondi -destination 'platform=iOS Simulator,name=iPhone 16' build

# Clean build
xcodebuild -project Bondi.xcodeproj -scheme Bondi clean
```

There is no test target yet. When tests are added, run them with:
```bash
xcodebuild -project Bondi.xcodeproj -scheme Bondi -destination 'platform=iOS Simulator,name=iPhone 16' test
```

## Project specs

| Key | Value |
|---|---|
| Platform | iOS 26.4+ |
| UI framework | SwiftUI (no UIKit, no AppDelegate) |
| Xcode version | 26.4.1 |
| Development team | V47DSZ3W28 |
| Bundle | Uses `PBXFileSystemSynchronizedRootGroup` (Xcode auto-syncs `Bondi/` folder — no need to manually add files to `project.pbxproj`) |
| External dependencies | None |

## Architecture

Currently a blank SwiftUI template. Entry point is `BondiApp.swift` (`@main`), which presents `ContentView` inside a `WindowGroup`. All new source files placed inside `Bondi/` are automatically picked up by the project due to filesystem sync.
