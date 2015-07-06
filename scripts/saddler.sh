#!/usr/bin/env bash

echo "********************"
echo "* install gems     *"
echo "********************"
gem install --no-document checkstyle_filter-git saddler saddler-reporter-github findbugs_translate_checkstyle_format android_lint_translate_checkstyle_format

if [ $? -ne 0 ]; then
    echo 'Failed to install gems.'
    exit 1
fi

echo "********************"
echo "* exec gradle      *"
echo "********************"
./gradlew check

if [ $? -ne 0 ]; then
    echo 'Failed gradle check task.'
    exit 1
fi

echo "********************"
echo "* save outputs     *"
echo "********************"

LINT_RESULT_DIR="$CIRCLE_ARTIFACTS/lint"

mkdir "$LINT_RESULT_DIR"
cp -v "app/build/reports/checkstyle/checkstyle.xml" "$LINT_RESULT_DIR/"
cp -v "app/build/reports/findbugs/findbugs.xml" "$LINT_RESULT_DIR/"
cp -v "app/build/outputs/lint-results.xml" "$LINT_RESULT_DIR/"

if [ -z "${CI_PULL_REQUEST}" ]; then
    # when not pull request
    exit 0
fi

echo "********************"
echo "* checkstyle       *"
echo "********************"
cat app/build/reports/checkstyle/checkstyle.xml \
    | checkstyle_filter-git diff origin/master \
    | saddler report --require saddler/reporter/github --reporter Saddler::Reporter::Github::PullRequestReviewComment

echo "********************"
echo "* findbugs         *"
echo "********************"
cat app/build/reports/findbugs/findbugs.xml \
    | findbugs_translate_checkstyle_format translate \
    | checkstyle_filter-git diff origin/master \
    | saddler report --require saddler/reporter/github --reporter Saddler::Reporter::Github::PullRequestReviewComment

echo "********************"
echo "* android lint     *"
echo "********************"
cat app/build/outputs/lint-results.xml \
    | android_lint_translate_checkstyle_format translate \
    | checkstyle_filter-git diff origin/master \
    | saddler report --require saddler/reporter/github --reporter Saddler::Reporter::Github::PullRequestReviewComment
