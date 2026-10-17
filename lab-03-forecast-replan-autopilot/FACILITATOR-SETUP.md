# Lab 3 — Facilitator Setup Guide

**Time required:** ~10 minutes  
**When to run:** Before the workshop session that includes Lab 3. Run once per TechZone environment.

---

## What This Setup Does

Creates the `FPA_Write_Forecast` TI process on `smartco` so the Forecast Writer Agent can write V3 forecast values back into the `FPA_Variance` cube.

> **Good news — nothing else is needed:**
> - `V3` already exists in the `FPA_Version` dimension ✅
> - `FC-Q1` already exists in the `FPA_Scenario` dimension ✅
> - `FPA_Variance` cube is already built (Lab 1 prerequisite) ✅

---

## Option A — Use Bob (Recommended, 2 minutes)

Switch to **Planning Analytics mode** in Bob and run:

```
On the smartco server, create a TI process called FPA_Write_Forecast with these 
6 parameters: pTime (String, default "2024-01"), pAccount (String, default "REV-001"), 
pDept (String, default "DEPT-NA-SALES"), pScenario (String, default "FC-Q1"), 
pVersion (String, default "V3"), pAmount (Numeric, default 0).

The epilog procedure should be a single line:
CellPutN(pAmount, 'FPA_Variance', pAccount, pDept, pScenario, pTime, pVersion, 'Amount');
```

Then verify:

```
Test FPA_Write_Forecast on smartco: write 325000 to REV-001 / DEPT-NA-SALES / 
FC-Q1 / 2024-01 / V3. Then read back V3 for that cell to confirm.
```

Expected: `REV-001 | V3 | 325,000.00` ✅

---

## Option B — Manual Steps

If Bob is unavailable, create the process manually via the TM1 REST API or Architect:

### Process parameters

| Name | Type | Default |
|------|------|---------|
| `pTime` | String | `2024-01` |
| `pAccount` | String | `REV-001` |
| `pDept` | String | `DEPT-NA-SALES` |
| `pScenario` | String | `FC-Q1` |
| `pVersion` | String | `V3` |
| `pAmount` | Numeric | `0` |

### Epilog procedure (single line, no line breaks)

```
CellPutN(pAmount, 'FPA_Variance', pAccount, pDept, pScenario, pTime, pVersion, 'Amount');
```

Leave Prolog, Metadata, and Data procedures empty.

---

## Verify Setup is Complete

Run the following MDX in Bob (Planning Analytics mode) to confirm V3 is writable:

```
Show me V1, V2, and V3 for REV-001 and OPEX-001, DEPT-NA-SALES, 
scenario FC-Q1, January 2024 in FPA_Variance on smartco.
```

Expected (before Lab 3 runs):
- V1 = actual values (325,000 for REV-001)
- V2 = budget values (500,000 for REV-001)  
- V3 = either 0 or the test value you wrote in setup verification

---

## Reset Between Workshop Runs

To clear V3 values before a fresh workshop run:

```
On smartco, clear all V3 data in FPA_Variance for scenario FC-Q1 
across all accounts, departments, and time periods.
```

Or run this MDX to check what V3 values exist before clearing:

```
Show me all non-zero V3 values in FPA_Variance on smartco for scenario FC-Q1.
```

---

## Quick Reference — MCP Endpoints

| Endpoint | Tools available |
|----------|----------------|
| `.../v0/agentic-ai/cube/mcp` | cube read/query tools (`execute_mdx_and_get_view`, etc.) |
| `.../v0/agentic-ai/server/mcp` (or `mcp` root) | server tools including `execute_tm1_processes_asynchronously` |

> The Forecast Writer Agent in Lab 3.1 must connect to the **server MCP endpoint**, not the cube endpoint, to access `execute_tm1_processes_asynchronously`.

---

*Lab 3 — Forecast Replan Autopilot · Facilitator Setup*  
*Made with IBM Bob — Planning Analytics × watsonx Orchestrate Workshop*
