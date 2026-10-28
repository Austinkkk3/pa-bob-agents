#!/usr/bin/env bash
# Lab 2.9 (Build with Bob): create the Lab 2 agents in one watsonx Orchestrate
# environment with the Orchestrate ADK.
#
# Creates, in order:
#   1. the PA connection (Basic Auth, team credentials, draft + live)
#   2. the PA MCP toolkit with the 6 read-only cube tools
#   3. pa_data_agent and fpa_variance_autopilot (imported from the YAML files here)
#   4. deploys both agents to Live
#
# Usage (from this folder, with the ADK installed in an active virtual environment):
#   export WXO_URL="https://api.<region>.watson-orchestrate.cloud.ibm.com/instances/<id>"
#   export PA_MCP_URL="http://<HOST>:<PORT>/api/<TENANT_ID>/v0/agentic-ai/cube/mcp"
#   ./setup-agents.sh
#
# The script asks for the Orchestrate API key and the PA password and never prints them.
# Safe to re-run: existing connection and toolkit are reused, agents are updated.

set -euo pipefail

: "${WXO_URL:?Set WXO_URL to the service instance URL from Orchestrate Settings > API details}"
: "${PA_MCP_URL:?Set PA_MCP_URL to http://<HOST>:<PORT>/api/<TENANT_ID>/v0/agentic-ai/cube/mcp}"
PA_USER="${PA_USER:-pm}"
ENV_NAME="${ENV_NAME:-workshop}"
APP_ID="planning-analytics-basic"
TOOLKIT="planning-analytics-cube-mcp"
TOOLS="get_available_tm1_servers,get_tm1_cubes,get_cube_dimensions,get_cube_sample_members,execute_mdx_and_get_view,lookup_potential_members"
HERE="$(cd "$(dirname "$0")" && pwd)"

command -v orchestrate >/dev/null || { echo "The orchestrate CLI is not installed. Run: pip install ibm-watsonx-orchestrate"; exit 1; }

echo "== 1/5 Connect to Orchestrate ($ENV_NAME)"
orchestrate env add -n "$ENV_NAME" -u "$WXO_URL" >/dev/null 2>&1 || echo "   environment '$ENV_NAME' already exists, reusing it"
orchestrate env activate "$ENV_NAME"          # prompts for the API key

read -r -s -p "PA password for $PA_USER: " PA_PASSWORD; echo

echo "== 2/5 PA connection ($APP_ID)"
orchestrate connections add -a "$APP_ID" >/dev/null 2>&1 || echo "   connection already exists, reusing it"
for e in draft live; do
  orchestrate connections configure -a "$APP_ID" --env "$e" --type team --kind basic --url "$PA_MCP_URL"
  orchestrate connections set-credentials -a "$APP_ID" --env "$e" -u "$PA_USER" -p "$PA_PASSWORD"
done
unset PA_PASSWORD

echo "== 3/5 PA MCP toolkit ($TOOLKIT, 6 read-only tools)"
if orchestrate toolkits list 2>/dev/null | grep -q "$TOOLKIT"; then
  echo "   toolkit already exists, reusing it"
else
  orchestrate toolkits add --kind mcp --name "$TOOLKIT" \
    --description "IBM Planning Analytics cube tools (read-only subset for the workshop)" \
    --url "$PA_MCP_URL" --transport streamable_http --tools "$TOOLS" --app-id "$APP_ID"
fi

echo "== 4/5 Import the agents"
orchestrate agents import -f "$HERE/pa-data-agent.adk.yaml"
orchestrate agents import -f "$HERE/fpa-orchestrator.adk.yaml"

echo "== 5/5 Deploy to Live"
orchestrate agents deploy -n pa_data_agent
orchestrate agents deploy -n fpa_variance_autopilot

echo
echo "Done. Open Orchestrate > Chat, pick 'FP&A Variance Autopilot' and ask:"
echo "  Run the FP&A variance analysis for January 2024 on the FPA_Variance cube on smartco."
echo "Expected: 4 material variances (2 HIGH, 1 MEDIUM, 1 FAVORABLE)."
