#!/usr/bin/env bash

set -euxo pipefail

for destination in 'platform=iOS Simulator,OS=16.2,name=iPhone Xʀ'
do
  xcodebuild test -workspace Example/BSGUtilities.xcworkspace -scheme BSGUtilities -sdk iphonesimulator -destination "$destination" | bundle exec xcpretty
done
