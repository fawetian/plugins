#!/usr/bin/env bash
# Layer 1: Plugin structure validation
# Checks Claude/Codex plugin manifests, skill/agent files, and marketplace consistency.
# No Claude/Codex invocation needed - pure static checks.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/test-helpers.sh"
source "$SCRIPT_DIR/../lib/plugin-discovery.sh"

PROJECT_ROOT="$(get_project_root)"
PLUGINS_ROOT="$PROJECT_ROOT/plugins"
CLAUDE_MARKETPLACE_JSON="$PROJECT_ROOT/.claude-plugin/marketplace.json"
CODEX_MARKETPLACE_JSON="$PROJECT_ROOT/.agents/plugins/marketplace.json"

pass() {
    echo -e "  ${GREEN}[PASS]${NC} $1"
    TESTS_PASSED=$((TESTS_PASSED + 1))
}

fail() {
    echo -e "  ${RED}[FAIL]${NC} $1"
    TESTS_FAILED=$((TESTS_FAILED + 1))
}

json_field() {
    local file="$1"
    local filter="$2"
    jq -r "$filter // empty" "$file" 2>/dev/null || true
}

check_required_fields() {
    local file="$1"
    local label="$2"
    shift 2

    for field in "$@"; do
        field_value=$(json_field "$file" ".$field")
        if [ -z "$field_value" ]; then
            fail "$label missing required field: $field"
        else
            pass "$label has required field: $field"
        fi
    done
}

check_semver() {
    local version="$1"
    local label="$2"

    if [ -n "$version" ] && echo "$version" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+'; then
        pass "$label version format is valid semver"
    else
        fail "$label version '$version' is not valid semver (x.y.z)"
    fi
}

check_skill_frontmatter() {
    local skill_md="$1"
    local skill_name="$2"

    has_name=$(head -20 "$skill_md" | grep -c "^name:" || true)
    has_desc=$(head -20 "$skill_md" | grep -c "^description:" || true)

    if [ "$has_name" -gt 0 ] && [ "$has_desc" -gt 0 ]; then
        pass "Skill '$skill_name': SKILL.md has frontmatter"
    else
        fail "Skill '$skill_name': SKILL.md missing name/description in frontmatter"
    fi
}

echo "========================================"
echo " Layer 1: Plugin Structure Validation"
echo "========================================"
echo ""

echo "--- Claude Marketplace ---"
if [ -f "$CLAUDE_MARKETPLACE_JSON" ]; then
    if jq empty "$CLAUDE_MARKETPLACE_JSON" 2>/dev/null; then
        pass "Claude marketplace.json is valid JSON"
    else
        fail "Claude marketplace.json is invalid JSON"
    fi
else
    fail "Claude marketplace.json not found at $CLAUDE_MARKETPLACE_JSON"
fi

CLAUDE_MARKETPLACE_PLUGINS=$(jq -r '.plugins[]?.name // empty' "$CLAUDE_MARKETPLACE_JSON" 2>/dev/null || true)
while IFS='|' read -r marketplace_plugin marketplace_source; do
    [ -n "$marketplace_plugin" ] || continue
    if [ -n "$marketplace_source" ] && [ -d "$PROJECT_ROOT/${marketplace_source#./}" ]; then
        pass "Claude marketplace source exists: $marketplace_plugin"
    else
        fail "Claude marketplace source missing: $marketplace_plugin ($marketplace_source)"
    fi
done < <(jq -r '.plugins[]? | "\(.name // "")|\(.source // "")"' "$CLAUDE_MARKETPLACE_JSON" 2>/dev/null || true)

echo ""
while IFS='|' read -r plugin_name plugin_dir; do
    echo "--- Claude Plugin: $plugin_name ---"
    local_plugin_json="$plugin_dir/.claude-plugin/plugin.json"

    if [ ! -f "$local_plugin_json" ]; then
        fail "plugin.json not found"
        continue
    fi

    if ! jq empty "$local_plugin_json" 2>/dev/null; then
        fail "plugin.json is invalid JSON"
        continue
    fi
    pass "plugin.json is valid JSON"

    check_required_fields "$local_plugin_json" "plugin.json" name version description
    plugin_version=$(json_field "$local_plugin_json" ".version")
    check_semver "$plugin_version" "Plugin"

    if echo "$CLAUDE_MARKETPLACE_PLUGINS" | grep -qx "$plugin_name"; then
        pass "Registered in Claude marketplace.json"
    else
        fail "Not registered in Claude marketplace.json"
    fi

    marketplace_version=$(jq -r --arg name "$plugin_name" '.plugins[] | select(.name == $name) | .version // empty' "$CLAUDE_MARKETPLACE_JSON" 2>/dev/null || true)
    if [ -n "$marketplace_version" ] && [ "$plugin_version" != "$marketplace_version" ]; then
        fail "Version mismatch: plugin.json=$plugin_version, marketplace=$marketplace_version"
    elif [ -n "$plugin_version" ]; then
        pass "Version consistent ($plugin_version)"
    fi

    skill_refs=$(jq -r '.skills[]? // empty' "$local_plugin_json" 2>/dev/null || true)
    if [ -n "$skill_refs" ]; then
        while read -r skill_ref; do
            [ -n "$skill_ref" ] || continue
            skill_dir="$plugin_dir/$skill_ref"
            skill_name=$(basename "$skill_ref")

            if [ ! -d "$skill_dir" ]; then
                fail "Skill directory missing: $skill_ref"
                continue
            fi

            skill_md="$skill_dir/SKILL.md"
            if [ ! -f "$skill_md" ]; then
                fail "Skill '$skill_name': SKILL.md not found"
                continue
            fi

            check_skill_frontmatter "$skill_md" "$skill_name"
        done <<< "$skill_refs"
    fi

    agents_dir="$plugin_dir/agents"
    if [ -d "$agents_dir" ]; then
        for agent_md in "$agents_dir"/*.md; do
            [ -f "$agent_md" ] || continue
            agent_name=$(basename "$agent_md" .md)
            [[ "$agent_md" == *"/zh-CN/"* ]] && continue

            has_name=$(head -20 "$agent_md" | grep -c "^name:" || true)
            has_desc=$(head -20 "$agent_md" | grep -c "^description:" || true)

            if [ "$has_name" -gt 0 ] && [ "$has_desc" -gt 0 ]; then
                pass "Agent '$agent_name': has frontmatter"
            else
                fail "Agent '$agent_name': missing name/description in frontmatter"
            fi
        done
    fi

    echo ""
done < <(discover_plugins "$PLUGINS_ROOT")

echo "--- Codex Marketplace ---"
if [ -f "$CODEX_MARKETPLACE_JSON" ]; then
    if jq empty "$CODEX_MARKETPLACE_JSON" 2>/dev/null; then
        pass "Codex marketplace.json is valid JSON"
    else
        fail "Codex marketplace.json is invalid JSON"
    fi
else
    fail "Codex marketplace.json not found at $CODEX_MARKETPLACE_JSON"
fi

CODEX_MARKETPLACE_PLUGINS=$(jq -r '.plugins[]?.name // empty' "$CODEX_MARKETPLACE_JSON" 2>/dev/null || true)
check_required_fields "$CODEX_MARKETPLACE_JSON" "Codex marketplace.json" name

while IFS=$'\t' read -r entry_name source_type source_path installation authentication category; do
    [ -n "$entry_name" ] || continue
    echo "--- Codex Marketplace Entry: $entry_name ---"

    if [ "$source_type" = "local" ]; then
        pass "Source type is local"
    else
        fail "Source type must be local"
    fi

    if echo "$source_path" | grep -qE '^\./'; then
        pass "Source path is relative"
    else
        fail "Source path must start with ./"
    fi

    entry_dir="$PROJECT_ROOT/${source_path#./}"
    entry_manifest="$entry_dir/.codex-plugin/plugin.json"
    if [ -d "$entry_dir" ]; then
        pass "Source path exists"
    else
        fail "Source path missing: $source_path"
    fi

    if [ -f "$entry_manifest" ]; then
        pass "Codex plugin manifest exists"
    else
        fail "Codex plugin manifest missing"
    fi

    case "$installation" in
        AVAILABLE|INSTALLED_BY_DEFAULT|NOT_AVAILABLE) pass "Installation policy is valid" ;;
        *) fail "Installation policy is invalid: $installation" ;;
    esac

    case "$authentication" in
        ON_INSTALL|ON_USE) pass "Authentication policy is valid" ;;
        *) fail "Authentication policy is invalid: $authentication" ;;
    esac

    if [ -n "$category" ]; then
        pass "Category is set"
    else
        fail "Category is missing"
    fi

    if [ -f "$entry_manifest" ]; then
        skills_path=$(json_field "$entry_manifest" ".skills")
        skills_dir="$entry_dir/${skills_path#./}"
        skill_count=$(find "$skills_dir" -mindepth 2 -maxdepth 2 -name "SKILL.md" 2>/dev/null | wc -l | tr -d ' ')
        if [ "$skill_count" -gt 0 ]; then
            pass "Codex marketplace plugin exposes skills ($skill_count)"
        else
            fail "Codex marketplace plugin exposes no skills"
        fi
    fi

    echo ""
done < <(jq -r '.plugins[]? | [.name, .source.source, .source.path, .policy.installation, .policy.authentication, .category] | @tsv' "$CODEX_MARKETPLACE_JSON" 2>/dev/null || true)

while IFS='|' read -r plugin_name plugin_dir; do
    echo "--- Codex Plugin: $plugin_name ---"
    codex_plugin_json="$plugin_dir/.codex-plugin/plugin.json"
    claude_plugin_json="$plugin_dir/.claude-plugin/plugin.json"

    if [ ! -f "$codex_plugin_json" ]; then
        fail "plugin.json not found"
        continue
    fi

    if ! jq empty "$codex_plugin_json" 2>/dev/null; then
        fail "plugin.json is invalid JSON"
        continue
    fi
    pass "plugin.json is valid JSON"

    check_required_fields "$codex_plugin_json" "plugin.json" name version description
    check_required_fields "$codex_plugin_json" "plugin.json author" author.name
    check_required_fields "$codex_plugin_json" "plugin.json interface" \
        interface.displayName interface.shortDescription interface.longDescription \
        interface.developerName interface.category

    plugin_version=$(json_field "$codex_plugin_json" ".version")
    check_semver "$plugin_version" "Plugin"

    capabilities_count=$(jq '.interface.capabilities | if type == "array" then length else 0 end' "$codex_plugin_json" 2>/dev/null || echo 0)
    if [ "$capabilities_count" -gt 0 ]; then
        pass "interface.capabilities is set"
    else
        fail "interface.capabilities must be a non-empty array"
    fi

    prompt_count=$(jq '.interface.defaultPrompt // .interface.default_prompt | if type == "array" then length elif type == "string" then 1 else 0 end' "$codex_plugin_json" 2>/dev/null || echo 0)
    if [ "$prompt_count" -gt 0 ]; then
        pass "interface.defaultPrompt is set"
    else
        fail "interface.defaultPrompt is required"
    fi

    skills_path=$(json_field "$codex_plugin_json" ".skills")
    skills_dir="$plugin_dir/${skills_path#./}"
    if [ -n "$skills_path" ] && [ -d "$skills_dir" ]; then
        pass "skills path exists"
    else
        fail "skills path missing: $skills_path"
    fi

    if echo "$CODEX_MARKETPLACE_PLUGINS" | grep -qx "$plugin_name"; then
        pass "Registered in Codex marketplace.json"
    else
        fail "Not registered in Codex marketplace.json"
    fi

    if [ -f "$claude_plugin_json" ]; then
        claude_version=$(json_field "$claude_plugin_json" ".version")
        if [ "$plugin_version" = "$claude_version" ]; then
            pass "Codex/Claude versions match ($plugin_version)"
        else
            fail "Codex/Claude version mismatch: codex=$plugin_version, claude=$claude_version"
        fi
    fi

    if [ -d "$skills_dir" ]; then
        skill_count=0
        while read -r skill_md; do
            [ -n "$skill_md" ] || continue
            skill_count=$((skill_count + 1))
            check_skill_frontmatter "$skill_md" "$(basename "$(dirname "$skill_md")")"
        done < <(find "$skills_dir" -mindepth 2 -maxdepth 2 -name "SKILL.md" 2>/dev/null | sort)

        if [ "$skill_count" -gt 0 ]; then
            pass "Codex skills discovered ($skill_count)"
        else
            fail "Codex skills path contains no SKILL.md files"
        fi
    fi

    echo ""
done < <(discover_codex_plugins "$PLUGINS_ROOT")

print_summary
