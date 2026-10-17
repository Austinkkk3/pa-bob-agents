# Lab 3.2 — Upgrade the Orchestrator

**Duration:** ~15 minutes  
**Prerequisite:** [Lab 3.1](../lab-03-1-forecast-writer-agent/README.md) ✅

---

## Goal

Add the `Forecast Writer Agent` to the existing `FP&A Variance Autopilot` orchestrator from Lab 2.5. No new orchestrator — just one more sub-agent, and an updated system prompt that knows when to call it.

---

## Step 1 — Confirm Sub-Agent is Active

In Orchestrate **Agents** list, confirm **Active** status for:
- ✅ `PA Data Agent` (from Lab 2)
- ✅ `CRM Context Agent` (from Lab 2)
- ✅ `ERP Context Agent` (from Lab 2)
- ✅ `Forecast Writer Agent` (just created in Lab 3.1)

---

## Step 2 — Open the Existing Orchestrator

1. Build → All agents → click `FP&A Variance Autopilot`
2. Go to the **Agents** tab
3. Click **Add agent** → select `Forecast Writer Agent`
4. **Save**

---

## Step 3 — Update the Orchestrator Instructions

1. Go to the **Instructions** tab
2. Click **Import from YAML** → open [`fpa-replan-orchestrator.yaml`](fpa-replan-orchestrator.yaml) → paste → **Apply**

This replaces the Lab 2 instructions with the upgraded version that includes the replan step.

> **What changed from Lab 2:** A new STEP 8 — after the variance report is generated, the orchestrator asks whether to trigger a forecast replan. If the user says yes, it calls `forecast_writer_agent` with the variance summary and root cause context.

---

## What the New Flow Looks Like

```
User: "Run variance analysis for January 2024. If there are material variances, replan the forecast."
    │
    ▼
Orchestrator — STEP 1–7 (same as Lab 2)
    ├── pa_data_agent       → variance table
    ├── crm_context_agent   → deal slippage context
    └── erp_context_agent   → OpEx context
    │
    ▼
Orchestrator — STEP 8 (NEW)
    └── forecast_writer_agent → calculates + writes V3 to PA → confirms
    │
    ▼
Final output: variance report + replan confirmation + Q1 net impact summary
```

---

## ✅ Done When

The `FP&A Variance Autopilot` agent shows 4 sub-agents in the Agents tab:
`PA Data Agent · CRM Context Agent · ERP Context Agent · Forecast Writer Agent`

---

**→ [Lab 3.3 — Run the End-to-End Replan](../lab-03-3-end-to-end/README.md)**
