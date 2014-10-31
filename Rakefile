project_name = "BSGUtilities"
project_version = "DEVELOP"
project_company = "Bootstragram"
company_id = "com.bootstragram"

desc "Clean all built files and objects"
task :clean => ['remove-documentation']

desc "Remove the documentation"
task :'remove-documentation' do |t|
  sh "rm -rf doc"
end

desc "Open"
task :open do |t|
  sh "cd Example && pod install && open \"BSGUtilities.xcworkspace\""
end

desc "Generate the documentation"
task :appledoc do |t|
  sh "/usr/local/bin/appledoc --verbose 2 --output ./doc --ignore .m --project-name #{project_name} --project-version #{project_version} --keep-undocumented-objects --keep-undocumented-members --project-company #{project_company} --company-id #{company_id} --no-repeat-first-par --no-create-docset --create-html --index-desc Pod/README.md Pod"
end
