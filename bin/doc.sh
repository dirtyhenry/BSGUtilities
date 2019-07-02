#!/usr/bin/env bash

set -euxo pipefail

PROJECT_NAME="BSGUtilities"
PROJECT_VERSION="DEVELOP"
PROJECT_COMPANY="Bootstragram"
COMPANY_ID="com.bootstragram"

/usr/local/bin/appledoc --verbose 2 \
                        --output ./doc \
                        --ignore .m \
                        --ignore _* \
                        --project-name $PROJECT_NAME \
                        --project-version $PROJECT_VERSION \
                        --keep-undocumented-objects \
                        --keep-undocumented-members \
                        --project-company $PROJECT_COMPANY \
                        --company-id $COMPANY_ID \
                        --no-repeat-first-par \
                        --no-create-docset \
                        --create-html \
                        --index-desc Pod/README.md \
                        Pod
