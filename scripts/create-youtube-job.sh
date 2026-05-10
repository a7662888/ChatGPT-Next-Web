#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: bash scripts/create-youtube-job.sh <youtube_url> [job_id]" >&2
  exit 1
fi

YOUTUBE_URL="$1"
JOB_ID="${2:-$(date -u +%Y%m%dT%H%M%SZ)}"
RAW_DIR="workflow/jobs/raw/$JOB_ID"
OUT_DIR="workflow/jobs/output/$JOB_ID"
HANDOFF_FILE="workflow/handoff/$JOB_ID.md"
TEMPLATE="skills/youtube-upgrade/templates/handoff.template.md"

mkdir -p "$RAW_DIR" "$OUT_DIR" "workflow/handoff"

TITLE=""
CHANNEL=""

readarray -t META < <(python - "$YOUTUBE_URL" <<'PY'
import json, sys, urllib.parse, urllib.request
url = sys.argv[1]
api = "https://www.youtube.com/oembed?format=json&url=" + urllib.parse.quote(url, safe='')
try:
    with urllib.request.urlopen(api, timeout=15) as r:
        data = json.load(r)
    print(data.get("title", ""))
    print(data.get("author_name", ""))
except Exception:
    print("")
    print("")
PY
)

TITLE="${META[0]:-}"
CHANNEL="${META[1]:-}"

STARTED_AT="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
cp "$TEMPLATE" "$HANDOFF_FILE"
sed -i "s/{{job_id}}/$JOB_ID/g" "$HANDOFF_FILE"
sed -i "s/{{started_at}}/$STARTED_AT/g" "$HANDOFF_FILE"

cat >> "$HANDOFF_FILE" <<EON

## Source Video
- url: $YOUTUBE_URL
- title: ${TITLE:-unknown}
- channel: ${CHANNEL:-unknown}
EON

echo "Created job: $JOB_ID"
echo "Raw dir: $RAW_DIR"
echo "Output dir: $OUT_DIR"
echo "Handoff: $HANDOFF_FILE"
