# Lab 2 — FP&A Variance Autopilot

**Duration:** 90 minutes (core path: Labs 2.0–2.5)  
**Tools:** watsonx Orchestrate · IBM Planning Analytics · SalesLens Mock API  
**Prerequisite:** [Lab 0](../lab-00-setup/README.md) ✅ · [Lab 1](../lab-01-bob-planning-analytics-mcp/README.md) ✅

---

## What You Will Build

A multi-agent system that automatically:
1. **Detects** material budget variances in Planning Analytics (>$100K or >20%)
2. **Investigates** root causes via CRM and ERP APIs
3. **Generates** a CFO-ready explanation for every variance
4. **Routes** alerts to the right stakeholders

Manual process: 3–4 days. With the autopilot: **under 5 minutes.**

---

## Architecture

```
User prompt
    │
    ▼
FP&A Variance Autopilot (Orchestrator)
    ├── PA Data Agent      → IBM Planning Analytics (TM1)
    ├── CRM Context Agent  → SalesLens CRM API
    └── ERP Context Agent  → SalesLens ERP API
```

---

## Sub-Labs (complete in order)

| Sub-Lab | Deliverable | Time |
|---------|-------------|------|
| [2.0](lab-02-0-fpa-dataset-catchup/README.md) | Confirm `FPA_Variance` cube | 5 min |
| [2.1](lab-02-1-pa-mcp-connection/README.md) | PA MCP connection in Orchestrate | 10 min |
| [2.2](lab-02-2-pa-agent/README.md) | PA Data Agent live | 30 min |
| [2.3](lab-02-3-saleslens-connection/README.md) | SalesLens API connection | 10 min |
| [2.4](lab-02-4-crm-erp-agents/README.md) | CRM + ERP Agents live | 30 min |
| [2.5](lab-02-5-orchestrator/README.md) | Full Autopilot running end-to-end | 25 min |
| [2.6](lab-02-6-agentops/README.md) *(optional)* | AgentOps tracing & evaluation | 15 min |
| [2.7](lab-02-7-chat-embed/README.md) *(optional)* | Embedded chat page | 10 min |
| [2.8](lab-02-8-adk/README.md) *(bonus)* | Orchestrate ADK CLI | 30 min |

**→ [Start with Lab 2.0](lab-02-0-fpa-dataset-catchup/README.md)**

---

## Credentials Needed

Your facilitator will provide:
- **PA:** `TECHZONE_HOST`, `PORT`, `TENANT_ID`, `USERNAME`, `PASSWORD`
- **SalesLens:** `SALESLENS_ENDPOINT_URL`, `SALESLENS_API_KEY`
- **Orchestrate:** Tenant URL

---

**→ [Continue to Session 3](../session-03-your-scenario/README.md)**
