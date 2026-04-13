#!/usr/bin/env bash
set -euo pipefail

TOKEN_BODY=$(mktemp)
TOKEN_STATUS=$(curl -sS --output "$TOKEN_BODY" --write-out "%{http_code}" --request POST \
  --url "https://sso-sprint.dynatracelabs.com/sso/oauth2/token" \
  --header "Content-Type: application/x-www-form-urlencoded" \
  --data-urlencode "grant_type=client_credentials" \
  --data-urlencode "client_id=$DT_CLIENT_ID" \
  --data-urlencode "client_secret=$DT_CLIENT_SECRET" \
  --data-urlencode "scope=$DT_SCOPES" \
  --data-urlencode "resource=$DT_RESOURCE")

if [ "$TOKEN_STATUS" -ne 200 ]; then
  echo "Dynatrace OAuth token request failed with HTTP $TOKEN_STATUS" >&2
  cat "$TOKEN_BODY" >&2
  rm -f "$TOKEN_BODY"
  exit 1
fi

ACCESS_TOKEN=$(python3 -c 'import json,sys; print(json.load(sys.stdin)["access_token"])' < "$TOKEN_BODY")
rm -f "$TOKEN_BODY"

COUNT=$(python3 - <<'PY'
import json
import os

print(len(json.loads(os.environ["DT_VALUES_JSON"]).get("values", [])))
PY
)

if [ "$COUNT" -eq 0 ]; then
  exit 0
fi

APPLY_BODY=$(mktemp)
APPLY_STATUS=$(curl -sS --output "$APPLY_BODY" --write-out "%{http_code}" --request PUT \
  --url "$DT_API_BASE$DT_ENDPOINT" \
  --header "Authorization: Bearer $ACCESS_TOKEN" \
  --header "Content-Type: application/json" \
  --data "$DT_VALUES_JSON")

if [ "$APPLY_STATUS" -ne 204 ]; then
  echo "Dynatrace cost allocation update failed for $DT_ENDPOINT with HTTP $APPLY_STATUS" >&2
  cat "$APPLY_BODY" >&2
  rm -f "$APPLY_BODY"
  exit 1
fi

rm -f "$APPLY_BODY"
