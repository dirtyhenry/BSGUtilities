#!/usr/bin/env bash

set -euxo pipefail

for destination in 'platform=iOS Simulator,name=iPhone 6s,OS=9.3' \
                   'platform=iOS Simulator,name=iPhone 7,OS=10.0' \
                   'platform=iOS Simulator,name=iPhone 8,OS=11.2' \
                   'platform=iOS Simulator,OS=12.2,name=iPhone Xʀ'
do
  xcodebuild test -workspace Example/BSGUtilities.xcworkspace -scheme BSGUtilities -sdk iphonesimulator -destination "$destination" | xcpretty
done
