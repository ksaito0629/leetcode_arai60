#!/bin/bash
# Create a git PR, taking a title and a URL.
# Example usage:
# ./prcreate.sh "82. Remove Duplicates from Sorted List II" https://leetcode.com/problems/remove-duplicates-from-sorted-list-ii/description/

# Convert a string to snake case
to_snake_case() {
  local s="$1"
  # Convert to lowercase, replace non-alphanumeric characters (except underscore) with underscores
  s=$(echo "$s" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/_/g')
  # Replace multiple underscores with a single underscore
  s=$(echo "$s" | sed 's/__*/_/g')
  # Remove leading/trailing underscores
  s=$(echo "$s" | sed 's/^_//;s/_$//')
  echo "$s"
}

# Check if required positional arguments are provided
if [ $# -lt 3 ]; then
echo "Error: missing required arguments: 'TITLE', 'URL', 'NEXT_TITLE'."
  echo "Usage: $0 <TITLE> <URL> <NEXT_TITLE>"
  exit 1
fi

TITLE="$1"
URL="$2"
NEXT_TITLE="$3"

# Remove /description and any trailing slashes from the URL if present
URL=$(echo "$URL" | sed 's|description[/]*$||')

# Convert the raw input to snake case == branch name.
DIR_NAME=$(to_snake_case "$TITLE")
MEMO_PATH="${DIR_NAME}/memo.md"

if [ ! -f "$MEMO_PATH" ]; then
  echo "Error: $MEMO_PATH is absent."
  exit 1
fi

# Check if it's a Git repository
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Error: Not a Git repository. Please run this script inside a Git repository."
  exit 1
fi

echo "Adding, committing, and pushing to git..."
# git push
git switch "$DIR_NAME"
git add "$MEMO_PATH"
git commit -m "$TITLE

$URL"
git push --set-upstream origin "$DIR_NAME"


REPORT_TEXT="${TITLE} を解いたのでレビューいただけると幸いです。"

if [ -n "$NEXT_TITLE" ]; then
  REPORT_TEXT="${REPORT_TEXT}\n次は、${NEXT_TITLE}に取り組みます。"
fi
REPORT_TEXT="${REPORT_TEXT}\n問題: ${URL}"

# Create PR
echo "Creating PR..."
PR_URL=$(echo -e "$REPORT_TEXT" | gh pr create \
  --base main \
  --head "$DIR_NAME" \
  --title "$TITLE" \
  --body-file=-)

DISCORD_MSG="お世話になっております。

"{$TITLE}に取り組んだので、お手すきの際にレビューいただけますと幸いです。
問題：${URL}
RP：${PR_URL}
言語：Python"

echo "---------------------"
echo -e "$DISCORD_MSG"
echo "---------------------"
