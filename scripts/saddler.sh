#!/usr/bin/env bash

if [ -z "${CI_PULL_REQUEST}" ]; then
    # when not pull request
    exit 0
fi

gem install --no-document checkstyle_filter-git saddler saddler-reporter-github findbugs_translate_checkstyle_format android_lint_translate_checkstyle_format

./gradlew check

echo "\n"
echo "checkstyle\n"
cat app/build/reports/checkstyle/checkstyle.xml \
    | checkstyle_filter-git diff origin/master \
    | saddler report --require saddler/reporter/github --reporter Saddler::Reporter::Github::PullRequestReviewComment

echo "\n"
echo "findbugs\n"
cat app/build/reports/findbugs/findbugs.xml \
    | findbugs_translate_checkstyle_format translate \
    | checkstyle_filter-git diff origin/master \
    | saddler report --require saddler/reporter/github --reporter Saddler::Reporter::Github::PullRequestReviewComment

echo "\n"
echo "android lint\n"
cat app/build/outputs/lint-results.xml \
    | android_lint_translate_checkstyle_format translate \
    | checkstyle_filter-git diff origin/master \
    | saddler report --require saddler/reporter/github --reporter Saddler::Reporter::Github::PullRequestReviewComment
