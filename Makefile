install:
	bundle install
	bundle exec pod install --project-directory=Example

update:
	bundle update
	bundle exec pod update --project-directory=Example

clean:
	rm -rf doc

open:
	open Example/BSGUtilities.xcworkspace

test:
	./bin/test.sh

lint:
	bundle exec pod lib lint --allow-warnings

publish:
	bundle exec pod trunk push BSGUtilities.podspec --allow-warnings
