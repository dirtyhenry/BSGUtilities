#!/usr/bin/env bash

set -euxo pipefail

for destination in 'platform=iOS Simulator,name=iPhone 6s,OS=9.3' \
                   'platform=iOS Simulator,name=iPhone 7,OS=10.3.1' \
                   'platform=iOS Simulator,name=iPhone 8,OS=11.4' \
                   'platform=iOS Simulator,OS=12.2,name=iPhone Xʀ'
do
  xcodebuild test -workspace Example/BSGUtilities.xcworkspace -scheme BSGUtilities -sdk iphonesimulator -destination "$destination" | bundle exec xcpretty
done
