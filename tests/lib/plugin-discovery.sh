#!/usr/bin/env bash
# Auto-discover plugins and their evals
# Outputs pipe-separated records: plugin_name|skill_name|eval_file|plugin_dir

set -euo pipefail

# Discover all plugins under the plugins/ directory
# Usage: discover_plugins "/path/to/project/plugins"
# Output: plugin_name|plugin_dir (one per line)
discover_plugins() {
    local plugins_root="$1"

    find "$plugins_root" -maxdepth 3 -name "plugin.json" -path "*/.claude-plugin/*" 2>/dev/null | while read -r pj; do
        local plugin_dir
        plugin_dir=$(dirname "$(dirname "$pj")")
        local plugin_name
        plugin_name=$(jq -r '.name // empty' "$pj" 2>/dev/null)

        if [ -n "$plugin_name" ]; then
            echo "${plugin_name}|${plugin_dir}"
        fi
    done | sort
}

# Discover all evals for a given plugin
# Usage: discover_evals "/path/to/plugin_dir" "plugin_name"
# Output: plugin_name|skill_name|eval_file (one per line)
discover_evals() {
    local plugin_dir="$1"
    local plugin_name="$2"

    find "$plugin_dir" -name "evals.json" -path "*/evals/*" 2>/dev/null | while read -r eval_file; do
        local skill_name
        skill_name=$(jq -r '.name // empty' "$eval_file" 2>/dev/null)

        if [ -n "$skill_name" ]; then
            echo "${plugin_name}|${skill_name}|${eval_file}"
        fi
    done | sort
}

# Discover all evals across all plugins
# Usage: discover_all_evals "/path/to/project/plugins"
# Output: plugin_name|skill_name|eval_file|plugin_dir (one per line)
discover_all_evals() {
    local plugins_root="$1"

    discover_plugins "$plugins_root" | while IFS='|' read -r plugin_name plugin_dir; do
        discover_evals "$plugin_dir" "$plugin_name" | while IFS='|' read -r pn sn ef; do
            echo "${pn}|${sn}|${ef}|${plugin_dir}"
        done
    done
}

# Discover all skills for a given plugin (from plugin.json)
# Usage: discover_skills "/path/to/plugin_dir"
# Output: skill_name|skill_dir (one per line)
discover_skills() {
    local plugin_dir="$1"
    local plugin_json="$plugin_dir/.claude-plugin/plugin.json"

    if [ ! -f "$plugin_json" ]; then
        return
    fi

    jq -r '.skills[]? // empty' "$plugin_json" 2>/dev/null | while read -r skill_ref; do
        local skill_dir="$plugin_dir/$skill_ref"
        local skill_name
        skill_name=$(basename "$skill_ref")

        if [ -d "$skill_dir" ]; then
            echo "${skill_name}|${skill_dir}"
        fi
    done
}

# Discover all agents for a given plugin
# Usage: discover_agents "/path/to/plugin_dir"
# Output: agent_file (one per line)
discover_agents() {
    local plugin_dir="$1"
    local agents_dir="$plugin_dir/agents"

    if [ ! -d "$agents_dir" ]; then
        return
    fi

    find "$agents_dir" -maxdepth 1 -name "*.md" -type f 2>/dev/null | sort
}

# Export functions
export -f discover_plugins
export -f discover_evals
export -f discover_all_evals
export -f discover_skills
export -f discover_agents
