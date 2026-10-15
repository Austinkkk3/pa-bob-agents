# Lab 2.2 — Create the PA Data Agent

**Duration:** ~30 minutes  
**Prerequisite:** [Lab 2.1](../lab-02-1-pa-mcp-connection/README.md) ✅

---

## Goal

Build the **PA Data Agent** — queries `FPA_Variance` in Planning Analytics via MCP and returns flagged variance data. This agent has no CRM or ERP tools. It becomes a sub-agent of the orchestrator in Lab 2.5.

---

## Step 1 — Create the Agent

**Orchestrate UI:** Build → All agents → Create agent

| Field | Value |
|-------|-------|
| **Name** | `PA Data Agent` |
| **Description** | Queries the FPA_Variance cube in Planning Analytics via MCP. Returns budget vs actual data with material variance flags. Does not call CRM or ERP systems. |
| **Model** | `ibm/granite-3-3-8b-instruct` |

**ADK:** `orchestrate agents import --file ./pa-data-agent.yaml`

---

## Step 2 — Import Agent Instructions

1. **Instructions** tab → **Import from YAML**
2. Open [`pa-data-agent.yaml`](pa-data-agent.yaml) → paste → **Apply**

---

## Step 3 — Add the Remote MCP Server

1. Toolset section → **Add tool** → **MCP server** → **Add MCP server** → **Remote MCP server**
2. Fill in:

| Field | Value |
|-------|-------|
| **Name** | `planning-analytics-mcp` |
| **Server URL** | `http://<TECHZONE_HOST>:<PORT>/api/<TENANT_ID>/v0/agentic-ai/cube/mcp` |
| **Transport type** | `Streamable HTTP` |
| **Connection** | `Planning Analytics (Basic Auth)` |

3. **Connect** — you should see: *"MCP server is ready and tools are available."*

---

## Step 4 — Select the 10 PA Tools

Select all of the following:

| Tool | Purpose |
|------|---------|
| `get_available_tm1_servers` | List TM1 servers |
| `list_cubes_with_ai_analysis_metadata` | List cubes with pre-analysis status |
| `get_cube_dimensions` | Get cube dimensions |
| `get_cube_sample_members` | Get sample members |
| `get_data_from_data_explorer` | Natural language query |
| `execute_mdx_and_get_view` | MDX fallback query |
| `get_cubes_that_may_answer_query` | Find relevant cubes |
| `lookup_potential_members` | Search dimension members |
| `perform_outlier_detection` | Outlier detection |
| `get_outlier_summary` | Outlier summary |

Click **Add to agent**. Do not add any CRM or ERP tools.

---

## Step 5 — Test the Agent

**Test 5.1 — Cube discovery:**
```
List available TM1 servers and show the dimensions of the FPA_Variance cube.
```
Expected: `DemoGuide` server, 5 dimensions.

**Test 5.2 — Variance with flagging:**
```
Show me January 2024 actual vs budget for all departments in the FPA_Variance cube.
Flag any variance greater than $100,000 or 20%.
```
Expected: table with NA Sales flagged 🔴, Sales OpEx flagged 🟡.

---

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| "Connect" fails | Verify team credential is in **Live** environment; check URL has no trailing slash |
| Tool list empty after connect | Ask facilitator to verify MCP endpoint is enabled on TechZone instance |
| 401 in Preview | Confirm team credential shows ✅ in Live environment |
| "Cube not found" | Send `List available cubes on DemoGuide` to check cube name |

---

**→ [Lab 2.3 — Configure the SalesLens API Connection](../lab-02-3-saleslens-connection/README.md)**
