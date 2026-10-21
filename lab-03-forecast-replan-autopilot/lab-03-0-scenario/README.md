# Lab 3.0 — The Replan Scenario

**Duration:** ~5 minutes  
**Prerequisite:** [Lab 2.5](../../lab-02-fpa-variance-autopilot/lab-02-5-orchestrator/README.md) ✅

---

## What Just Happened

Your variance autopilot (Lab 2) surfaced two issues for January 2024:

| # | Department | Account | Variance | Root Cause | Type |
|---|-----------|---------|----------|------------|------|
| 1 | NA Sales | Finished Goods Revenue (REV-001) | **-$175K (-35%)** 🔴 | 2 deals slipped to February (Acme Corp + TechStart) | Timing |
| 2 | NA Sales | Sales & Distribution OPEX (OPEX-001) | **+$25K (+20.8%)** 🔴 | Unbudgeted trade show PO + new hire headcount | Structural |

The analysis is done. Now the CFO asks:

> *"Update the Q1 forecast to reflect what we now know. Show me the revised numbers by end of day."*

---

## The Replan Logic

A good FP&A analyst would make these adjustments:

### Variance 1 — Revenue Slippage (Timing)
- Jan actual: $325K vs $500K budget → -$175K
- Root cause from cube: both deals rescheduled to February
- **Replan action:** Move $200K slipped amount to February (confirmed recovery)
- January forecast: `$325K` (matches actual — no recovery in January)
- February forecast: `$520K (Feb budget) + $200K (slipped deals) = $720K`
- March forecast: `$540K` (unchanged — Mar budget from CSV)
- Net Q1 revenue impact: **+$25K** (Jan -$175K + Feb +$200K recovery)

### Variance 2 — OpEx Overspend (Structural)
- Jan actual: $145K vs $120K budget → +$25K
- Root cause from cube: $18K one-time PO (trade show) + $8.5K/mo new headcount
- **Replan action:**
  - Jan forecast: `$145K` (matches actual)
  - Feb forecast: `$125K (Feb budget) + $8.5K = $133.5K` (headcount run-rate, no repeat PO)
  - Mar forecast: `$130K (Mar budget) + $8.5K = $138.5K`
  - Q1 total: `$145K + $133.5K + $138.5K = $417K` vs original Q1 budget `$375K` (+$42K)

---

## What the Agent Will Do

The Forecast Writer Agent receives the variance analysis and root cause context, then:

1. Determines adjustment type: **timing shift** (revenue) vs **run-rate change** (opex)
2. Calculates new values for each affected period
3. Calls the PA MCP to write the adjusted values into `FPA_Variance` as version `V3`
4. Returns a confirmation with every cell it wrote

---

## Confirm Your Starting Data

Before proceeding, verify the cube is ready:

```
Show me January 2024 actual vs budget for NA Sales in FPA_Variance on smartco.
```

Expected:
- `REV-001 / DEPT-NA-SALES`: Actual $325K, Budget $500K → -$175K (-35%) 🔴 HIGH
- `OPEX-001 / DEPT-NA-SALES`: Actual $145K, Budget $120K → +$25K (+20.8%) 🔴 HIGH

If the numbers match, you're ready.

---

**→ [Lab 3.1 — Create the Forecast Writer Agent](../lab-03-1-forecast-writer-agent/README.md)**
