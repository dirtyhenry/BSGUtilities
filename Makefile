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

docs:
	/usr/local/bin/appledoc --verbose 2 --output ./doc --ignore .m --ignore _* --project-name #{project_name} --project-version #{project_version} --keep-undocumented-objects --keep-undocumented-members --project-company #{project_company} --company-id #{company_id} --no-repeat-first-par --no-create-docset --create-html --index-desc Pod/README.md Pod

test:
	./bin/test.sh

test-ci:
	./bin/test-ci.sh

lint:
	bundle exec pod lib lint --allow-warnings

publish:
	bundle exec pod trunk push BSGUtilities.podspec --allow-warnings
