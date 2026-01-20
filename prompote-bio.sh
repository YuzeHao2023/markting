#!/usr/bin/env bash
set -e

QUERY="topic:bioinformatics is:public archived:false"
MAX_REPOS=10   # ❗强烈建议 <= 10
ISSUE_TITLE="🔍 Looking for feedback: Daily arXiv AI4Bio paper tracker"

ISSUE_BODY=$(cat <<'EOF'
Hi everyone 👋,

I’m exploring whether this could be useful for the bioinformatics community and would really appreciate feedback.

I’d like to share a small project I’ve been working on that might be useful for researchers and practitioners in AI for Biology (AI4Bio).

🚀 What is this project?

This project automatically searches arXiv every day using a curated set of AI4Bio-related keywords and continuously updates a list of newly published papers.

✨ Key features:

✅ Daily automatic arXiv search and updates  
✅ Keyword-based filtering tailored for AI4Bio  
✅ Clean, continuously growing paper list  
✅ Easy to extend with new keywords or categories  

🔗 Project link: https://yuzehao2023.github.io/daily-arxiv-ai4bio/  
👉 [repository](https://github.com/YuzeHao2023/daily-arxiv-ai4bio)

Feedback and suggestions are very welcome!
EOF
)

echo "Searching repositories..."

REPOS=$(gh api search/repositories \
  -f q="$QUERY" \
  -f per_page="$MAX_REPOS" \
  --jq '.items[].full_name')

for repo in $REPOS; do
  echo "Creating issue in $repo"

  gh api repos/$repo/issues \
    -f title="$ISSUE_TITLE" \
    -f body="$ISSUE_BODY" || echo "Skipped $repo"

  sleep 20   # ❗必须 sleep，避免速率 & 风控
done
