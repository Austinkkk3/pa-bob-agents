# Lab 3 — Forecast Replan with Bob

**Duration:** 30 minutes  
**Mode:** 📊 Planning Analytics  
**Prerequisite:** [Lab 1 Exercise 5](../lab-01-bob-planning-analytics-mcp/README.md) ✅ (`FPA_Variance` cube built)

---

## What You Will Do

Lab 1 taught you how to **read** data from Planning Analytics. This lab teaches you how to **change** it.

You will use Bob to:
1. Find material budget variances in `FPA_Variance`
2. Understand the root cause of each variance
3. Calculate adjusted forecast values
4. Write the new forecast back into Planning Analytics
5. Verify the update

One conversation. No external tools. No code.

| Exercise | Task | Time |
|----------|------|------|
| [1](#exercise-1--find-the-variances) | Find material variances | 5 min |
| [2](#exercise-2--understand-the-root-cause) | Understand what caused them | 5 min |
| [3](#exercise-3--calculate-the-reforecast) | Calculate adjusted forecast values | 8 min |
| [4](#exercise-4--write-back-to-pa) | Write the new forecast into PA | 7 min |
| [5](#exercise-5--verify) | Verify and compare versions | 5 min |

Switch to **📊 Planning Analytics** mode before starting.

---

## Exercise 1 — Find the Variances

```
Show me January 2024 actual vs budget for all departments in the 
FPA_Variance cube on smartco. Flag any variance greater than $100,000 or 20%.
```

You should see three flagged variances (threshold: >$100K or >20%):
- 🔴 NA Sales / Finished Goods Revenue (REV-001): -$175K (-35%)
- 🔴 NA Sales / Sales & Distribution OPEX (OPEX-001): +$25K (+20.8%)
- ✅ NA Sales / Sales Commissions (OPEX-004): -$17.5K (-35%) — Favorable

```
Which of these variances is more urgent and why?
```

---

## Exercise 2 — Understand the Root Cause

```
For the NA Sales revenue miss of -$175K in January 2024:
The root cause is deal slippage — two enterprise deals moved to February.
Acme Corp ($120K) delayed by customer procurement, TechStart ($80K) by a budget freeze.
Both deals are confirmed for February. Is this a timing issue or a structural problem?
```

```
For the NA Sales OpEx overspend of +$25K in January 2024:
The root cause is an unbudgeted trade show PO ($18K) plus a new hire 
that started in December ($8,500/month recurring). 
What kind of forecast adjustment does this require?
```

> Bob will classify each variance as **timing** (recovers next month) or **structural** (recurring run-rate change). This classification drives the reforecast calculation in Exercise 3.

---

## Exercise 3 — Calculate the Reforecast

```
Based on the root causes above, calculate the Q1 2024 reforecast for NA Sales.
Apply these rules:
- Revenue slippage (timing): move the slipped amount to the recovery month
- Recurring cost increase (structural): apply the new run-rate to remaining months
- One-time cost (non-recurring): no adjustment to future months
Show me the full reforecast table before writing anything.
```

Expected calculation (budgets come from the CSV — Feb/Mar are not flat $500K/$120K):

| Period | Account | Budget (V2) | Reforecast (FC-Q1 / V3) | Change | Reason |
|--------|---------|-------------|------------------------|--------|--------|
| Jan 2024 | REV-001 | $500,000 | $325,000 | -$175K | Matches actual — deals moved out |
| Feb 2024 | REV-001 | $520,000 | $720,000 | +$200K | Recovery: Acme $120K + TechStart $80K |
| Mar 2024 | REV-001 | $540,000 | $540,000 | — | Unchanged |
| Jan 2024 | OPEX-001 | $120,000 | $145,000 | +$25K | Matches actual |
| Feb 2024 | OPEX-001 | $125,000 | $133,500 | +$8.5K | New hire run-rate, no repeat PO |
| Mar 2024 | OPEX-001 | $130,000 | $138,500 | +$8.5K | New hire run-rate continues |

```
What is the net Q1 impact on revenue and OpEx from these adjustments?
```

---

## Exercise 4 — Write Back to PA

Once you're happy with the numbers:

```
Write these reforecast values to the FPA_Variance cube on smartco.
Use scenario FC-Q1 and version V3 for all cells.
Write one cell at a time using the FPA_Write_Forecast process and confirm each write.
```

> Bob will call `execute_tm1_processes_asynchronously` with the `FPA_Write_Forecast` TI process for each cell. You will see it confirm each write before moving to the next.

Watch for the confirmation after each cell:
```
✅ Written: REV-001 / DEPT-NA-SALES / FC-Q1 / 2024-01 / V3 = 325,000
✅ Written: REV-001 / DEPT-NA-SALES / FC-Q1 / 2024-02 / V3 = 720,000
...
```

---

## Exercise 5 — Verify

```
For NA Sales REV-001 and OPEX-001, January through March 2024, show:
- Actual (scenario Actual, version V1)
- Budget (scenario Budget, version V2)
- Reforecast (scenario FC-Q1, version V3)
side by side in FPA_Variance on smartco.
```

Expected: V3 values match exactly what was calculated in Exercise 3.

```
Summarise the Q1 reforecast in one paragraph suitable for a CFO update.
```

---

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| "Process FPA_Write_Forecast not found" | Ask your facilitator to run the Lab 3 setup (takes 2 min) |
| V3 shows 0 after write | Ask Bob: `Read back V3 for REV-001 / DEPT-NA-SALES / FC-Q1 / 2024-01 in FPA_Variance` to confirm |
| Bob calculates wrong recovery amount | Re-read Exercise 3 — confirm the total slipped value is $200K ($120K + $80K) |

---

---

## Two Versions of Lab 3

This file is the **Bob-only track** — everything runs in Bob with no external tools.

There is also an **Orchestrate track** (3.0–3.3) that uses watsonx Orchestrate agents. Start there if you completed Lab 2:

**→ [Lab 3.0 — The Replan Scenario (Orchestrate track)](./lab-03-0-scenario/README.md)**

---

**→ [Lab 2 — FP&A Variance Autopilot](../lab-02-fpa-variance-autopilot/README.md)** *(if you want to go further with watsonx Orchestrate)*
**→ [Session 3 — Your Scenario](../session-03-your-scenario/README.md)**
