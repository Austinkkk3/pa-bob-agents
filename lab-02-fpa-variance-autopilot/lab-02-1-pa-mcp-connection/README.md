# Lab 2.1 — Configure the PA MCP Connection

**Duration:** ~10 minutes  
**Prerequisite:** [Lab 2.0](../lab-02-0-fpa-dataset-catchup/README.md) ✅

---

## Goal

Create the `planning-analytics-basic` connection and store team credentials in watsonx Orchestrate so agents can authenticate with the PA MCP server.

---

## Step 1 — Create the Connection

1. **Manage → Security → Connections** tab → **Add connection**
2. Fill in:

| Field | Value |
|-------|-------|
| **Connection ID** | `planning-analytics-basic` |
| **Display name** | `Planning Analytics (Basic Auth)` |

3. **Next** → Authentication type: **Basic Auth** · Credential type: **Team credentials**
4. **Next** → **Paste draft configuration** to copy to live
5. **Add connection**

> ADK: `orchestrate connections create --name planning-analytics-basic --auth-type basic --credential-type team`

---

## Step 2 — Add Team Credentials

1. **Manage → Security → Team credentials** tab → **Live** environment → **Add team credential**
2. Select `Planning Analytics (Basic Auth)` from the dropdown
3. Enter the credentials provided by your facilitator:
   - **Username:** `pm`
   - **Password:** provided on the session credential sheet
   - **Server URL:** `http://<TECHZONE_HOST>:<PORT>/api/<TENANT_ID>/v0/agentic-ai/cube/mcp`
4. **Connect and save** — status should show ✅

> If the connection already exists, skip to Step 2 and verify credentials are set.

---

## ✅ Done when

`planning-analytics-basic` shows ✅ in **Manage → Security → Team credentials**.

---

**→ [Lab 2.2 — Create the PA Data Agent](../lab-02-2-pa-agent/README.md)**
