# Lab 3.1 — Create the Forecast Writer Agent

**Duration:** ~20 minutes  
**Prerequisite:** [Lab 3.0](../lab-03-0-scenario/README.md) ✅

---

## Goal

Build the **Forecast Writer Agent** — the only new agent in Lab 3. It receives a variance + root cause summary, calculates adjusted forecast values, and writes them back into Planning Analytics as version `V3 (Q1 Reforecast)`.

This agent has one job: **turn analysis into action.**

---

## Step 1 — Create the Agent

**Orchestrate UI:** Build → All agents → Create agent

| Field | Value |
|-------|-------|
| **Name** | `Forecast Writer Agent` |
| **Description** | Receives variance and root cause context from the orchestrator. Calculates adjusted forecast values based on variance classification (timing shift vs structural run-rate). Writes V3 forecast values back to the FPA_Variance cube in Planning Analytics via MCP. Does not analyse variances or query CRM/ERP directly. |
| **Model** | `ibm/granite-3-3-8b-instruct` |

**ADK:** `orchestrate agents import --file ./forecast-writer-agent.yaml`

---

## Step 2 — Import Agent Instructions

**Instructions** tab → **Import from YAML** → open [`forecast-writer-agent.yaml`](forecast-writer-agent.yaml) → paste → **Apply**

---

## Step 3 — Add the PA MCP Server

The Forecast Writer Agent needs the same MCP connection as the PA Data Agent from Lab 2.

1. Toolset section → **Add tool** → **MCP server** → **Add MCP server** → **Remote MCP server**
2. Fill in:

| Field | Value |
|-------|-------|
| **Name** | `planning-analytics-mcp` |
| **Server URL** | `http://<TECHZONE_HOST>:<PORT>/api/<TENANT_ID>/v0/agentic-ai/cube/mcp` |
| **Transport type** | `Streamable HTTP` |
| **Connection** | `Planning Analytics (Basic Auth)` |

3. **Connect** — you should see: *"MCP server is ready and tools are available."*

> If the connection is already saved from Lab 2, click **Existing MCP server** and select `planning-analytics-mcp`.

---

## Step 4 — Select the 3 Write Tools

The Forecast Writer Agent only needs three tools — no read tools, no CRM/ERP:

| Tool | Purpose |
|------|---------|
| `get_available_tm1_servers` | Confirm the target server is reachable |
| `get_cube_dimensions` | Verify cube structure before writing |
| `execute_mdx_and_get_view` | Read current V3 values to confirm writes succeeded |

> **Note:** Direct cell write is handled through the PA MCP's TI process execution tool. The agent calls `execute_tm1_processes_asynchronously` with the pre-built `FPA_Write_Forecast` process (created for you in Lab 3 setup).

Also select:
| Tool | Purpose |
|------|---------|
| `execute_tm1_processes_asynchronously` | Write forecast values via TI process |

Click **Add to agent**.

---

## Step 5 — Test the Agent in Isolation

**Test 5.1 — Confirm write access:**
```
Confirm you can reach the smartco server and show the dimensions of FPA_Variance.
```
Expected: `FPA_Account · FPA_Department · FPA_Scenario · FPA_Time · FPA_Version · FPA_Measures`

**Test 5.2 — Dry-run calculation (no write):**
```
NA Sales had a revenue miss of -$175K in January 2024 due to deal slippage 
(timing). Both deals are confirmed for February. Calculate the V3 forecast 
adjustment for January and February. Do not write yet — just show me the numbers.
```

Expected output:
```
V3 Forecast Adjustments — NA Sales / REV-001:
  Jan 2024: $325,000  (was $500,000 — matches actual, deals moved to Feb)
  Feb 2024: $700,000  (was $500,000 — +$200K recovery from slipped deals)
  Net Q1 impact: $0 (timing shift only)
```

**Test 5.3 — Write to PA:**
```
Write those V3 values to FPA_Variance on smartco now.
```

Expected: Agent confirms each cell written, then reads back V3 to verify.

---

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| `execute_tm1_processes_asynchronously` not in tool list | Scroll — it is in the server/cube MCP; ensure you connected to the correct MCP endpoint |
| "Process not found" when writing | Run Lab 3 setup: ask your facilitator to confirm `FPA_Write_Forecast` TI process exists on smartco |
| Write succeeds but V3 still shows 0 | Check `FPA_Version` dimension — confirm `V3` leaf element exists; if not, facilitator needs to re-run dimension build |
| Agent tries to read CRM/ERP directly | It should not — if it does, the instructions import did not apply correctly; re-paste the YAML |

---

**→ [Lab 3.2 — Upgrade the Orchestrator](../lab-03-2-orchestrator-upgrade/README.md)**
