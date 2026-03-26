#!/usr/bin/env bash
# Layer 1: Plugin structure validation
# Checks plugin.json integrity, skill/agent files, marketplace consistency
# No Claude invocation needed - pure static checks

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../lib/test-helpers.sh"
source "$SCRIPT_DIR/../lib/plugin-discovery.sh"

PROJECT_ROOT="$(get_project_root)"
PLUGINS_ROOT="$PROJECT_ROOT/plugins"
MARKETPLACE_JSON="$PROJECT_ROOT/.claude-plugin/marketplace.json"

echo "========================================"
echo " Layer 1: Plugin Structure Validation"
echo "========================================"
echo ""

# Check marketplace.json exists and is valid JSON
echo "--- Marketplace ---"
if [ -f "$MARKETPLACE_JSON" ]; then
    if jq empty "$MARKETPLACE_JSON" 2>/dev/null; then
        echo -e "  ${GREEN}[PASS]${NC} marketplace.json is valid JSON"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "  ${RED}[FAIL]${NC} marketplace.json is invalid JSON"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi
else
    echo -e "  ${RED}[FAIL]${NC} marketplace.json not found at $MARKETPLACE_JSON"
    TESTS_FAILED=$((TESTS_FAILED + 1))
fi

# Get marketplace plugin list
MARKETPLACE_PLUGINS=$(jq -r '.plugins[]?.name // empty' "$MARKETPLACE_JSON" 2>/dev/null || true)

# Iterate over discovered plugins
echo ""
while IFS='|' read -r plugin_name plugin_dir; do
    echo "--- Plugin: $plugin_name ---"
    local_plugin_json="$plugin_dir/.claude-plugin/plugin.json"

    # Check plugin.json exists and is valid
    if [ ! -f "$local_plugin_json" ]; then
        echo -e "  ${RED}[FAIL]${NC} plugin.json not found"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        continue
    fi

    if ! jq empty "$local_plugin_json" 2>/dev/null; then
        echo -e "  ${RED}[FAIL]${NC} plugin.json is invalid JSON"
        TESTS_FAILED=$((TESTS_FAILED + 1))
        continue
    fi
    echo -e "  ${GREEN}[PASS]${NC} plugin.json is valid JSON"
    TESTS_PASSED=$((TESTS_PASSED + 1))

    # Check required fields: name, version, description
    for field in name version description; do
        field_value=$(jq -r --arg f "$field" '.[$f] // empty' "$local_plugin_json")
        if [ -z "$field_value" ]; then
            echo -e "  ${RED}[FAIL]${NC} plugin.json missing required field: $field"
            TESTS_FAILED=$((TESTS_FAILED + 1))
        else
            echo -e "  ${GREEN}[PASS]${NC} plugin.json has required field: $field"
            TESTS_PASSED=$((TESTS_PASSED + 1))
        fi
    done

    # Check version format (semver: x.y.z)
    plugin_ver=$(jq -r '.version // empty' "$local_plugin_json")
    if [ -n "$plugin_ver" ] && ! echo "$plugin_ver" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+'; then
        echo -e "  ${RED}[FAIL]${NC} Version '$plugin_ver' is not valid semver (x.y.z)"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    elif [ -n "$plugin_ver" ]; then
        echo -e "  ${GREEN}[PASS]${NC} Version format is valid semver"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    fi

    # Check plugin is registered in marketplace
    if echo "$MARKETPLACE_PLUGINS" | grep -qx "$plugin_name"; then
        echo -e "  ${GREEN}[PASS]${NC} Registered in marketplace.json"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    else
        echo -e "  ${RED}[FAIL]${NC} Not registered in marketplace.json"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    fi

    # Check version consistency
    plugin_version=$(jq -r '.version // empty' "$local_plugin_json")
    marketplace_version=$(jq -r --arg name "$plugin_name" '.plugins[] | select(.name == $name) | .version // empty' "$MARKETPLACE_JSON" 2>/dev/null || true)
    if [ -n "$marketplace_version" ] && [ "$plugin_version" != "$marketplace_version" ]; then
        echo -e "  ${RED}[FAIL]${NC} Version mismatch: plugin.json=$plugin_version, marketplace=$marketplace_version"
        TESTS_FAILED=$((TESTS_FAILED + 1))
    elif [ -n "$plugin_version" ]; then
        echo -e "  ${GREEN}[PASS]${NC} Version consistent ($plugin_version)"
        TESTS_PASSED=$((TESTS_PASSED + 1))
    fi

    # Check skill directories
    skill_refs=$(jq -r '.skills[]? // empty' "$local_plugin_json" 2>/dev/null || true)
    if [ -n "$skill_refs" ]; then
        while read -r skill_ref; do
            skill_dir="$plugin_dir/$skill_ref"
            skill_name=$(basename "$skill_ref")

            if [ ! -d "$skill_dir" ]; then
                echo -e "  ${RED}[FAIL]${NC} Skill directory missing: $skill_ref"
                TESTS_FAILED=$((TESTS_FAILED + 1))
                continue
            fi

            # Check SKILL.md exists
            skill_md="$skill_dir/SKILL.md"
            if [ ! -f "$skill_md" ]; then
                echo -e "  ${RED}[FAIL]${NC} Skill '$skill_name': SKILL.md not found"
                TESTS_FAILED=$((TESTS_FAILED + 1))
                continue
            fi

            # Check YAML frontmatter has name and description
            has_name=$(head -20 "$skill_md" | grep -c "^name:" || true)
            has_desc=$(head -20 "$skill_md" | grep -c "^description:" || true)

            if [ "$has_name" -gt 0 ] && [ "$has_desc" -gt 0 ]; then
                echo -e "  ${GREEN}[PASS]${NC} Skill '$skill_name': SKILL.md has frontmatter"
                TESTS_PASSED=$((TESTS_PASSED + 1))
            else
                echo -e "  ${RED}[FAIL]${NC} Skill '$skill_name': SKILL.md missing name/description in frontmatter"
                TESTS_FAILED=$((TESTS_FAILED + 1))
            fi
        done <<< "$skill_refs"
    fi

    # Check agent files
    agents_dir="$plugin_dir/agents"
    if [ -d "$agents_dir" ]; then
        for agent_md in "$agents_dir"/*.md; do
            [ -f "$agent_md" ] || continue
            agent_name=$(basename "$agent_md" .md)

            # Skip zh-CN directory agents
            [[ "$agent_md" == *"/zh-CN/"* ]] && continue

            has_name=$(head -20 "$agent_md" | grep -c "^name:" || true)
            has_desc=$(head -20 "$agent_md" | grep -c "^description:" || true)

            if [ "$has_name" -gt 0 ] && [ "$has_desc" -gt 0 ]; then
                echo -e "  ${GREEN}[PASS]${NC} Agent '$agent_name': has frontmatter"
                TESTS_PASSED=$((TESTS_PASSED + 1))
            else
                echo -e "  ${RED}[FAIL]${NC} Agent '$agent_name': missing name/description in frontmatter"
                TESTS_FAILED=$((TESTS_FAILED + 1))
            fi
        done
    fi

    echo ""
done < <(discover_plugins "$PLUGINS_ROOT")

print_summary
