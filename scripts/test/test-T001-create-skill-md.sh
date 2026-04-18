#!/usr/bin/env bash
# Test T001: SKILL.md exists with required sections and frontmatter
set -euo pipefail

SKILL="$(cd "$(dirname "$0")/../.." && pwd)/SKILL.md"

echo "=== T001: Validate SKILL.md ==="

# File exists
if [[ ! -f "$SKILL" ]]; then
  echo "FAIL: SKILL.md not found"
  exit 1
fi
echo "PASS: SKILL.md exists"

# Frontmatter has required fields
for field in "name:" "description:" "keywords:"; do
  if ! grep -q "^${field}" "$SKILL"; then
    echo "FAIL: Missing frontmatter field: $field"
    exit 1
  fi
done
echo "PASS: Frontmatter has name, description, keywords"

# Required sections present
for section in "## API Endpoint" "## Authentication" "## Usage" "## Gotchas" "## Troubleshooting"; do
  if ! grep -q "^${section}" "$SKILL"; then
    echo "FAIL: Missing section: $section"
    exit 1
  fi
done
echo "PASS: All required sections present"

# API endpoint documented
if ! grep -q "localhost:18789" "$SKILL"; then
  echo "FAIL: API endpoint URL not documented"
  exit 1
fi
echo "PASS: API endpoint URL documented"

# Auth documented
if ! grep -q "Bearer" "$SKILL"; then
  echo "FAIL: Bearer auth not documented"
  exit 1
fi
echo "PASS: Bearer auth documented"

# At least 3 gotchas
GOTCHA_COUNT=$(grep -c '^[0-9]' "$SKILL" || echo "0")
if [[ "$GOTCHA_COUNT" -lt 3 ]]; then
  echo "FAIL: Fewer than 3 gotchas documented (found $GOTCHA_COUNT)"
  exit 1
fi
echo "PASS: At least 3 gotchas documented"

# No secrets/tokens leaked (real token starts with oc_ followed by 20+ chars)
if grep -qE 'oc_[a-zA-Z0-9]{20,}' "$SKILL"; then
  echo "FAIL: Real token found in SKILL.md"
  exit 1
fi
echo "PASS: No real tokens in file"

echo ""
echo "=== T001: ALL CHECKS PASSED ==="
