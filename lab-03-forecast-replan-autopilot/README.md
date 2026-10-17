# Lab 3 — Forecast Replan Autopilot

**Duration:** 60 minutes (core path: Labs 3.0–3.3)  
**Tools:** watsonx Orchestrate · IBM Planning Analytics · SalesLens Mock API  
**Prerequisite:** [Lab 2](../lab-02-fpa-variance-autopilot/README.md) ✅

---

## The Business Problem

Your FP&A team just ran the January variance analysis (Lab 2). They found two material variances:

- 🔴 NA Sales revenue missed budget by **-$175K (-35%)** — deal slippage
- 🟡 NA Sales OpEx exceeded budget by **+$25K (+20.8%)** — unbudgeted PO + new hire

**What happens next in most companies:**

> FP&A analyst opens PA, manually adjusts the Q1 forecast line-by-line, writes a commentary email to the CFO, and flags the VP Sales for a pipeline review call. This takes 2–3 hours and happens the next morning.

**What Lab 3 builds:**

The same outcome in under 2 minutes, triggered by a single prompt — with every number written back directly into Planning Analytics.

---

## What You Will Build

A **Forecast Replan Autopilot** that:

1. **Reads** the variance analysis output from Lab 2 (PA data + CRM/ERP context)
2. **Calculates** the right forecast adjustment for each material variance
3. **Writes the new forecast back** into the `FPA_Variance` cube in Planning Analytics
4. **Generates** a CFO-ready replan summary with a confidence score

Manual process: 2–3 hours. With the autopilot: **under 2 minutes.**

---

## Architecture

```
User prompt
    │
    ▼
Forecast Replan Autopilot (Orchestrator — upgraded)
    ├── PA Data Agent         → reads variance data (from Lab 2)
    ├── CRM Context Agent     → explains revenue misses (from Lab 2)
    ├── ERP Context Agent     → explains cost overruns (from Lab 2)
    └── Forecast Writer Agent → NEW: writes adjusted forecast back to PA
```

The only new piece is the **Forecast Writer Agent**. Everything from Lab 2 is reused as-is.

---

## Sub-Labs

| Sub-Lab | Deliverable | Time |
|---------|-------------|------|
| [3.0](lab-03-0-scenario/README.md) | Understand the replan scenario | 5 min |
| [3.1](lab-03-1-forecast-writer-agent/README.md) | Forecast Writer Agent live | 20 min |
| [3.2](lab-03-2-orchestrator-upgrade/README.md) | Upgrade the Orchestrator to include the Writer | 15 min |
| [3.3](lab-03-3-end-to-end/README.md) | Run the full Forecast Replan end-to-end | 20 min |

**→ [Start with Lab 3.0](lab-03-0-scenario/README.md)**

---

## What Changes in PA

After the autopilot runs, the `FPA_Variance` cube on `smartco` will have a new version:

| Version | Description |
|---------|-------------|
| `V1` | Original Actual |
| `V2` | Original Budget |
| `V3` | **Q1 Reforecast** ← written by this lab |

`V3` reflects the adjusted forecast, with deal slippage timing corrections and OpEx run-rate updates applied automatically.

---

**→ [Continue to Session 3](../session-03-your-scenario/README.md)**
