# Lab 3.3 — End-to-End Forecast Replan

**Duration:** ~20 minutes  
**Prerequisite:** [Lab 3.2](../lab-03-2-orchestrator-upgrade/README.md) ✅

---

## Goal

Run the full Forecast Replan Autopilot end-to-end with a single prompt. Watch all four sub-agents fire in sequence, then verify the new forecast values are in Planning Analytics.

---

## The Prompt

Open the `FP&A Variance Autopilot` agent in **Preview / Test** panel and send:

```
Run the FP&A variance analysis for January 2024 on the FPA_Variance cube
on smartco. Identify all material variances, investigate root causes using
the CRM and ERP systems, and update the Q1 forecast with adjusted V3 values.
```

---

## Watch the Trace

In the **Trace** panel you should see sub-agent calls in this order:

| # | Sub-agent | What it does |
|---|-----------|-------------|
| 1 | `pa_data_agent` | Reads Jan 2024 actuals vs budget → returns variance table |
| 2 | `crm_context_agent` | Gets deal slippage for NA Sales REV-001 |
| 3 | `erp_context_agent` | Gets PO + headcount context for NA Sales OPEX-001 |
| 4 | `forecast_writer_agent` | Calculates V3 values → writes to PA → reads back confirmation |

Total time: **under 2 minutes.**

---

## Expected Final Output

```
📊 FP&A Variance Analysis + Replan — January 2024

Server: smartco | Cube: FPA_Variance | Period: 2024-01
Sub-agents: pa_data_agent · crm_context_agent · erp_context_agent · forecast_writer_agent

MATERIAL VARIANCES DETECTED: 2

─────────────────────────────────────────────────────
🔴 HIGH — NA Sales | Enterprise Software Revenue
─────────────────────────────────────────────────────
  Budget: $500,000 | Actual: $325,000
  Variance: -$175,000 (-35.0%) ← Unfavorable

  Root Cause: 2 deals totalling $200K slipped from January to February.
  Acme Corp ($120K) delayed by customer procurement; TechStart ($80K) impacted
  by budget freeze. Both remain in pipeline — high close probability.

  Classification: Timing slippage — no structural issue
  Forecast Action: Move $200K to February; January V3 = Actual

─────────────────────────────────────────────────────
🔴 HIGH — NA Sales | Sales & Marketing OpEx
─────────────────────────────────────────────────────
  Budget: $120,000 | Actual: $145,000
  Variance: +$25,000 (+20.8%) ← Unfavorable

  Root Cause: 1 unbudgeted PO ($18K — TechWorld trade show) + 1 headcount
  event ($8.5K/mo — new Enterprise AE hire).

  Classification: Mixed — $18K one-time, $8.5K recurring
  Forecast Action: Feb–Mar V3 = real budget + $8.5K/mo run-rate

─────────────────────────────────────────────────────
✅ FAVORABLE — EMEA Sales | Enterprise Software Revenue
  +$40,000 (+10.5%) — Early close of GlobalTech. No action required.

─────────────────────────────────────────────────────
SUMMARY
  Revenue Variance (Net): -$135,000 (-8.8% vs budget)
  OpEx Variance (Net):    +$25,000  (+7.5% vs budget)
  Material Variances: 2 (2 High, 0 Medium)

RECOMMENDED ACTIONS:
  1. [HIGH] Confirm Feb close — Acme Corp + TechStart (VP Sales)
  2. [HIGH] Review NA Sales OpEx run-rate for Q1 re-forecast (FP&A)

─────────────────────────────────────────────────────
📝 V3 FORECAST REPLAN
─────────────────────────────────────────────────────

  Period   | Account  | Dept        | V2 Budget | V3 Forecast | Change    | Rationale
  ---------|----------|-------------|-----------|-------------|-----------|----------
  2024-01  | REV-001  | DEPT-NA-S   | $500,000  | $325,000    | -$175K    | Timing — matches actual
  2024-02  | REV-001  | DEPT-NA-S   | $520,000  | $720,000    | +$200K    | Slipped deal recovery (budget from CSV = $520K)
  2024-01  | OPEX-001 | DEPT-NA-S   | $120,000  | $145,000    | +$25K     | Matches actual
  2024-02  | OPEX-001 | DEPT-NA-S   | $125,000  | $133,500    | +$8.5K    | New hire run-rate (budget from CSV = $125K)
  2024-03  | OPEX-001 | DEPT-NA-S   | $130,000  | $138,500    | +$8.5K    | New hire run-rate (budget from CSV = $130K)

  ✅ 5 cells written to FPA_Variance / smartco / V3 — all confirmed.

  Q1 Net Impact:
    Revenue: +$25,000 net (Jan -$175K timing miss; Feb +$200K recovery = net +$25K vs Q1 budget)
    OpEx:    +$42,000 over Q1 (+$25K Jan actuals + $17K Feb–Mar run-rate)

Confidence: 0.95 | Alerts: VP Sales (email), FP&A Manager (dashboard) | V3 written: ✅
```

---

## Verify in Planning Analytics (via Bob)

Switch to **Planning Analytics mode** in Bob and run:

```
Show me January and February 2024 for NA Sales REV-001 across all versions 
in FPA_Variance on smartco.
```

Expected: V1 (Actual), V2 (Budget), and V3 (Reforecast) all visible, with V3 values matching the table above.

---

## More Prompts to Try

| Prompt | What to watch for |
|--------|------------------|
| `Run variance analysis for March 2024 on FPA_Variance on smartco. Focus on APAC Sales. Replan if material.` | APAC -$85K → CRM Sino-Digital → timing shift → V3 Apr recovery |
| `Run variance analysis for March 2025 on FPA_Variance on smartco. Include Product Engineering.` | +$45K Prod Eng OpEx → ERP NVIDIA GPU + ML contractor → structural run-rate |
| `Run the January 2024 analysis but do NOT update the forecast.` | All 4 variance steps, but agent asks before writing — test the confirmation gate |

---

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| Orchestrator calls `forecast_writer_agent` before variance report is done | Check that Step 8 in orchestrator instructions says "after delivering the variance report" |
| `forecast_writer_agent` writes wrong values | Ensure it received the full variance table from the orchestrator, not a partial summary |
| V3 shows in PA but with wrong period | Check TI process parameter names — `time_id` must match cube members exactly (e.g. `2024-01`, not `Jan 2024`) |
| Agent asks for confirmation before writing even when prompt said "update the forecast" | Expected behaviour — the agent summarises calculations and asks once before writing. Say "yes" to proceed. |

---

## 🎉 Lab 3 Complete

You have built a system that:
1. **Detects** material variances in Planning Analytics
2. **Investigates** root causes from CRM and ERP
3. **Writes** an adjusted V3 forecast back to PA
4. **Confirms** every cell it touched

This is the complete FP&A Variance + Replan loop — from detection to action, in one prompt, under 2 minutes.

---

**→ [Session 3 — Your Scenario](../../session-03-your-scenario/README.md)**
