# Lab 2.5 — Create the FP&A Orchestrator Agent

**Duration:** 25 minutes  
**Prerequisite:** Labs 2.0–2.4 ✅

---

## Goal

Build the **FP&A Variance Autopilot** orchestrator. It delegates to the three sub-agents and produces a single CFO-ready variance report.

```
User prompt
    │
    ▼
FP&A Variance Autopilot (Orchestrator)
    ├── PA Data Agent          → gets variance data from TM1
    ├── CRM Context Agent      → explains revenue misses
    └── ERP Context Agent      → explains cost overruns
```

---

## Step 1 — Confirm Sub-Agents Are Active

In Orchestrate **Agents** list, confirm **Active** status for:
- `PA Data Agent`
- `CRM Context Agent`
- `ERP Context Agent`

---

## Step 2 — Create the Orchestrator Agent

**Orchestrate UI:** Agents → Create agent

| Field | Value |
|-------|-------|
| **Name** | `FP&A Variance Autopilot` |
| **Description** | Multi-agent orchestrator. Coordinates PA Data Agent, CRM Context Agent, and ERP Context Agent to detect material budget variances, enrich with CRM/ERP root cause context, and produce a CFO-ready variance report. |
| **Model** | `ibm/granite-3-3-8b-instruct` |

**ADK:** `orchestrate agents import --file ./fpa-orchestrator-agent.yaml`

---

## Step 3 — Import Orchestrator Instructions

**Instructions** tab → **Import from YAML** → open [`fpa-orchestrator-agent.yaml`](fpa-orchestrator-agent.yaml) → paste → **Apply**

---

## Step 4 — Add the Three Sub-Agents as Collaborators

1. In the agent editor, go to the **Agents** tab
2. Click **Add agent** and add all three:

```
✅ PA Data Agent
✅ CRM Context Agent
✅ ERP Context Agent
```

3. **Save**

> The orchestrator should have **no direct tools** — all data flows through sub-agents.

---

## Step 5 — Run the End-to-End Autopilot

In the agent **Preview** / **Test** panel:

```
Run the FP&A variance analysis for January 2024 on the FPA_Analysis cube
on the DemoGuide server. Identify all material variances, investigate root
causes using the CRM and ERP systems, and generate a full variance report.
```

Watch the **Trace** panel — you should see sub-agent calls in order:
1. `pa_data_agent` → returns variance table with flags
2. `crm_context_agent` → returns slipped deals for NA Sales
3. `erp_context_agent` → returns unbudgeted PO + headcount event

**Expected output:** A report with 2 material variances, each with root cause explanation, severity rating, and recommended actions.

---

## More Prompts to Try

| Prompt | Expected |
|--------|----------|
| `Run variance analysis for March 2024 on FPA_Analysis on DemoGuide. Focus on APAC Sales.` | -$85K APAC revenue → CRM: Sino-Digital regulatory delay |
| `Run variance analysis for March 2025 on FPA_Analysis on DemoGuide. Focus on Product Engineering.` | +$45K Prod Eng OpEx → ERP: NVIDIA GPU + ML contractor |
| `List all cubes on DemoGuide.` | Delegates to PA Data Agent, no variance analysis triggered |

---

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| Orchestrator calls tools directly instead of sub-agents | Remove any direct tools from the orchestrator — only sub-agents under the Agents tab |
| Sub-agent not available in collaborator picker | Confirm sub-agent is **Active**; must be in the same tenant/project |
| Stops after PA data — doesn't call CRM/ERP | Add to instructions: `Always call the appropriate context sub-agent for EVERY material variance before generating the final report. Never skip this step.` |

---

**→ [Lab 2.6 — AgentOps](../lab-02-6-agentops/README.md)** *(optional)*  
**→ [Session 3 — Your Scenario](../../session-03-your-scenario/README.md)**
