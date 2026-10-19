# Lab 2.2 — Create the PA Data Agent

**Duration:** ~20 minutes
**Prerequisite:** [Lab 2.1](../lab-02-1-pa-mcp-connection/README.md) ✅

---

## Goal

Build the **PA Data Agent** — the only sub-agent in this lab. It queries `FPA_Variance` in Planning Analytics via MCP, calculates variances, reads the embedded root cause explanations from the cube, and returns a complete CFO-ready report. No CRM or ERP systems needed.

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

## Step 4 — Select the 5 PA Tools

| Tool | Purpose |
|------|---------|
| `get_available_tm1_servers` | Confirm smartco is reachable |
| `get_cube_dimensions` | Confirm FPA_Variance dimension names |
| `get_cube_sample_members` | Retrieve valid member IDs |
| `execute_mdx_and_get_view` | Query budget vs actual data |
| `lookup_potential_members` | Resolve member names if needed |

Click **Add to agent**.

---

## Step 5 — Test the Agent

**Test 5.1 — Cube discovery:**
```
List available TM1 servers and show the dimensions of the FPA_Variance cube.
```
Expected: `smartco` server, 6 dimensions.

**Test 5.2 — Full variance report:**
```
Show me the FP&A variance report for January 2024 on the FPA_Variance cube on smartco.
Flag material variances and include root cause explanations.
```
Expected: 🔴 NA Sales REV-001 (-$175K, root cause text), 🟡 NA Sales OPEX-001 (+$25K, root cause text).

---

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| "Connect" fails | Verify team credential is in **Live** environment; check URL has no trailing slash |
| Tool list empty after connect | Ask facilitator to verify MCP endpoint is enabled on TechZone instance |
| 401 in Preview | Confirm team credential shows ✅ in Live environment |
| "Cube not found" | Send `List available cubes on smartco` to check cube name |
| Root cause shows empty | Expected for some rows — variance_explanation only exists for flagged variances |

---

**→ [Lab 2.5 — Create the Orchestrator Agent](../lab-02-5-orchestrator/README.md)**
