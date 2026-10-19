# Lab 2.5 — Create the FP&A Orchestrator Agent

**Duration:** ~20 minutes  
**Prerequisite:** [Lab 2.2](../lab-02-2-pa-agent/README.md) ✅

---

## Goal

Build the **FP&A Variance Autopilot** orchestrator. It delegates to the PA Data Agent and produces a single CFO-ready variance report with root cause explanations — all from Planning Analytics, no external APIs required.

```
User prompt
    │
    ▼
FP&A Variance Autopilot (Orchestrator)
    └── PA Data Agent  → queries FPA_Variance, calculates variances,
                         reads root causes, returns full report
```

---

## Step 1 — Confirm Sub-Agent is Active

In Orchestrate **Agents** list, confirm **Active** status for:
- `PA Data Agent`

---

## Step 2 — Create the Orchestrator Agent

**Orchestrate UI:** Agents → Create agent

| Field | Value |
|-------|-------|
| **Name** | `FP&A Variance Autopilot` |
| **Description** | Orchestrator for FP&A variance analysis. Delegates to PA Data Agent to detect material budget variances in Planning Analytics and produce a CFO-ready report with root cause explanations from the cube. |
| **Model** | `ibm/granite-3-3-8b-instruct` |

**ADK:** `orchestrate agents import --file ./fpa-orchestrator-agent.yaml`

---

## Step 3 — Import Orchestrator Instructions

**Instructions** tab → **Import from YAML** → open [`fpa-orchestrator-agent.yaml`](fpa-orchestrator-agent.yaml) → paste → **Apply**

---

## Step 4 — Add the PA Data Agent as Collaborator

1. In the agent editor, go to the **Agents** tab
2. Click **Add agent** → select `PA Data Agent`
3. **Save**

> The orchestrator has **no direct tools** — all data flows through the PA Data Agent.

---

## Step 5 — Run the End-to-End Autopilot

In the agent **Preview / Test** panel:

```
Run the FP&A variance analysis for January 2024 on the FPA_Variance cube
on smartco. Identify all material variances, explain the root causes,
and generate a full variance report.
```

Watch the **Trace** panel — you should see:
1. `pa_data_agent` → returns full variance report with root causes

**Expected output:** Report with 2 material variances (🔴 NA Sales Revenue, 🟡 NA Sales OpEx), each with root cause text from the cube and recommended actions.

---

## More Prompts to Try

| Prompt | Expected |
|--------|----------|
| `Run variance analysis for March 2024 on FPA_Variance on smartco. Focus on APAC Sales.` | -$85K APAC revenue, root cause from cube |
| `Run variance analysis for March 2025 on FPA_Variance on smartco. Focus on Product Engineering.` | +$45K Prod Eng OpEx, root cause from cube |
| `List all cubes on smartco.` | Delegates to PA Data Agent, no variance analysis triggered |

---

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| Orchestrator calls tools directly instead of PA Data Agent | Remove any direct tools from the orchestrator — only sub-agents under the Agents tab |
| Sub-agent not available in collaborator picker | Confirm PA Data Agent is **Active** in the same tenant/project |
| Report generated but no root cause text | The variance_explanation field may be empty for that period — expected for non-flagged rows |
| "Cube not found" in PA Data Agent | Confirm cube name is `FPA_Variance` and server is `smartco` |

---

**→ [Lab 3 — Forecast Replan Autopilot](../../lab-03-forecast-replan-autopilot/README.md)** *(add write-back to PA)*  
**→ [Lab 2.6 — AgentOps](../lab-02-6-agentops/README.md)** *(optional)*  
**→ [Session 3 — Your Scenario](../../session-03-your-scenario/README.md)**
