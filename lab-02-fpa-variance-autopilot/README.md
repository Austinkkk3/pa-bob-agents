# Lab 2 — FP&A Variance Autopilot

**Duration:** 45 minutes (core path: Labs 2.0–2.2, 2.5)
**Tools:** watsonx Orchestrate · IBM Planning Analytics
**Prerequisite:** [Lab 0](../lab-00-setup/README.md) ✅ · [Lab 1](../lab-01-bob-planning-analytics-mcp/README.md) ✅

---

## What You Will Build

A multi-agent system in watsonx Orchestrate that automatically:
1. **Detects** material budget variances in Planning Analytics (>$100K or >20%)
2. **Reads** root cause explanations embedded directly in the cube
3. **Generates** a CFO-ready variance report with stakeholder routing

Manual process: 3–4 days. With the autopilot: **under 5 minutes.**

---

## Architecture

```
User prompt
    │
    ▼
FP&A Variance Autopilot (Orchestrator)
    └── PA Data Agent  → IBM Planning Analytics (TM1)
                          reads variance data + embedded root causes
```

---

## Sub-Labs (complete in order)

| Sub-Lab | Deliverable | Time |
|---------|-------------|------|
| [2.0](lab-02-0-fpa-dataset-catchup/README.md) | Confirm `FPA_Variance` cube | 5 min |
| [2.1](lab-02-1-pa-mcp-connection/README.md) | PA MCP connection in Orchestrate | 10 min |
| [2.2](lab-02-2-pa-agent/README.md) | PA Data Agent live | 20 min |
| [2.5](lab-02-5-orchestrator/README.md) | Full Autopilot running end-to-end | 20 min |
| [2.6](lab-02-6-agentops/README.md) *(optional)* | AgentOps tracing & evaluation | 15 min |
| [2.7](lab-02-7-chat-embed/README.md) *(optional)* | Embedded chat page | 10 min |
| [2.8](lab-02-8-adk/README.md) *(bonus)* | Orchestrate ADK CLI | 30 min |

> **Note:** Labs 2.3 (SalesLens connection) and 2.4 (CRM/ERP Agents) are available in this repo for reference but are not part of the core path. Root causes are read directly from the `FPA_Variance` cube.

**→ [Start with Lab 2.0](lab-02-0-fpa-dataset-catchup/README.md)**

---

## Credentials Needed

Your facilitator will provide:
- **PA:** `TECHZONE_HOST`, `PORT`, `TENANT_ID`, `USERNAME`, `PASSWORD`
- **Orchestrate:** Tenant URL

---

**→ [Continue to Session 3](../session-03-your-scenario/README.md)**
