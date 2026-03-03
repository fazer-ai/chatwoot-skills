#!/usr/bin/env bash
set -euo pipefail

# chatwoot-skills build & validation script
# Usage: ./build.sh [validate|stats|clean]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

errors=0
warnings=0

log_ok()   { echo -e "${GREEN}✓${NC} $1"; }
log_warn() { echo -e "${YELLOW}⚠${NC} $1"; warnings=$((warnings + 1)); }
log_err()  { echo -e "${RED}✗${NC} $1"; errors=$((errors + 1)); }

validate_plugin() {
  echo "=== Plugin Manifest ==="

  if [[ -f "$SCRIPT_DIR/.claude-plugin/plugin.json" ]]; then
    log_ok "plugin.json exists"
    if command -v jq &>/dev/null; then
      jq empty "$SCRIPT_DIR/.claude-plugin/plugin.json" 2>/dev/null && log_ok "plugin.json is valid JSON" || log_err "plugin.json is invalid JSON"
    else
      log_warn "jq not installed — skipping JSON validation"
    fi
  else
    log_err "plugin.json missing"
  fi

  if [[ -f "$SCRIPT_DIR/.claude-plugin/marketplace.json" ]]; then
    log_ok "marketplace.json exists"
  else
    log_err "marketplace.json missing"
  fi
  echo ""
}

validate_skills() {
  echo "=== Skills ==="

  local skill_count=0
  for skill_dir in "$SCRIPT_DIR"/skills/chatwoot-*/; do
    [[ -d "$skill_dir" ]] || continue
    local name
    name=$(basename "$skill_dir")
    skill_count=$((skill_count + 1))

    if [[ -f "$skill_dir/SKILL.md" ]]; then
      # Check frontmatter
      if head -1 "$skill_dir/SKILL.md" | grep -q "^---"; then
        log_ok "$name/SKILL.md has frontmatter"
      else
        log_err "$name/SKILL.md missing YAML frontmatter"
      fi

      # Check line count
      local lines
      lines=$(wc -l < "$skill_dir/SKILL.md")
      if (( lines <= 500 )); then
        log_ok "$name/SKILL.md is $lines lines (≤500)"
      else
        log_warn "$name/SKILL.md is $lines lines (>500 limit)"
      fi
    else
      log_err "$name/SKILL.md missing"
    fi

    if [[ -f "$skill_dir/README.md" ]]; then
      log_ok "$name/README.md exists"
    else
      log_warn "$name/README.md missing"
    fi
  done

  echo ""
  echo "  Found $skill_count skills"
  echo ""
}

validate_evaluations() {
  echo "=== Evaluations ==="

  local eval_count=0
  local scenario_count=0

  for eval_dir in "$SCRIPT_DIR"/evaluations/*/; do
    [[ -d "$eval_dir" ]] || continue
    local name
    name=$(basename "$eval_dir")

    for eval_file in "$eval_dir"/*.json; do
      [[ -f "$eval_file" ]] || continue
      local fname
      fname=$(basename "$eval_file")
      eval_count=$((eval_count + 1))

      if command -v jq &>/dev/null; then
        if jq empty "$eval_file" 2>/dev/null; then
          log_ok "$name/$fname is valid JSON"
          local count
          count=$(jq 'length' "$eval_file")
          scenario_count=$((scenario_count + count))
        else
          log_err "$name/$fname is invalid JSON"
        fi
      else
        log_ok "$name/$fname exists"
      fi
    done
  done

  echo ""
  echo "  Found $eval_count evaluation files with $scenario_count total scenarios"
  echo ""
}

validate_docs() {
  echo "=== Documentation ==="

  for doc in INSTALLATION.md USAGE.md DEVELOPMENT.md; do
    if [[ -f "$SCRIPT_DIR/docs/$doc" ]]; then
      log_ok "docs/$doc exists"
    else
      log_err "docs/$doc missing"
    fi
  done

  for file in README.md LICENSE CLAUDE.md .mcp.json.example; do
    if [[ -f "$SCRIPT_DIR/$file" ]]; then
      log_ok "$file exists"
    else
      log_err "$file missing"
    fi
  done
  echo ""
}

check_naming() {
  echo "=== Naming Rules ==="

  # Check for "fazer" used alone (not "fazer-ai" or "fazer.ai")
  local bad_refs
  bad_refs=$(grep -rn '\bfazer\b' "$SCRIPT_DIR" \
    --include="*.md" --include="*.json" \
    | grep -v 'fazer-ai\|fazer\.ai\|fazer-ai/\|@fazer-ai\|fazer\.ai/' \
    | grep -v '.git/' \
    | grep -v 'node_modules/' \
    || true)

  if [[ -z "$bad_refs" ]]; then
    log_ok "No bare 'fazer' references found (always fazer-ai or fazer.ai)"
  else
    log_err "Found bare 'fazer' references (should be fazer-ai or fazer.ai):"
    echo "$bad_refs" | head -10
  fi
  echo ""
}

show_stats() {
  echo "=== Project Stats ==="

  local skill_files
  skill_files=$(find "$SCRIPT_DIR/skills" -name "*.md" 2>/dev/null | wc -l)
  local eval_files
  eval_files=$(find "$SCRIPT_DIR/evaluations" -name "*.json" 2>/dev/null | wc -l)
  local total_lines
  total_lines=$(find "$SCRIPT_DIR/skills" -name "*.md" -exec cat {} + 2>/dev/null | wc -l)

  echo "  Skill files:      $skill_files"
  echo "  Evaluation files:  $eval_files"
  echo "  Total skill lines: $total_lines"
  echo ""
}

case "${1:-validate}" in
  validate)
    echo ""
    echo "Validating chatwoot-skills plugin..."
    echo ""
    validate_plugin
    validate_skills
    validate_evaluations
    validate_docs
    check_naming
    show_stats

    echo "=== Summary ==="
    if (( errors > 0 )); then
      echo -e "${RED}$errors errors${NC}, ${YELLOW}$warnings warnings${NC}"
      exit 1
    elif (( warnings > 0 )); then
      echo -e "${GREEN}No errors${NC}, ${YELLOW}$warnings warnings${NC}"
    else
      echo -e "${GREEN}All checks passed!${NC}"
    fi
    ;;
  stats)
    show_stats
    ;;
  clean)
    echo "Nothing to clean (pure markdown project)"
    ;;
  *)
    echo "Usage: $0 [validate|stats|clean]"
    exit 1
    ;;
esac
