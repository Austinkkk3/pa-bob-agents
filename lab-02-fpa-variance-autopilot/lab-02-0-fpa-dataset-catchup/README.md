# Lab 2.0 — Confirm the FP&A Dataset

**Duration:** ~5 minutes  
**Prerequisite:** [Lab 1](../../lab-01-bob-planning-analytics-mcp/README.md) ✅

---

## Goal

Confirm `FPA_Variance` cube is loaded and spot-check the key variances the autopilot will investigate.

> **If you completed Lab 1 Exercise 5**, the cube is already loaded — run the check below and move on (~2 min).

---

## Check in Bob (📊 Planning Analytics mode)

```
List available cubes on the DemoGuide server.
Show me the dimensions of the FPA_Variance cube.
```

Expected: `Account · Department · Scenario · Time · Version`

```
Show me January 2024 actual vs budget for all departments in FPA_Variance.
Flag any variance greater than $100,000 or 20%.
```

Expected variances:

| Department | Account | Variance | Flag |
|-----------|---------|----------|------|
| NA Sales | Enterprise Software Revenue | -$175K (-35%) | 🔴 |
| NA Sales | Sales & Marketing OpEx | +$25K (+20.8%) | 🟡 |
| EMEA Sales | Enterprise Software Revenue | +$40K (+10.5%) | ✅ |

> If the cube is missing, ask your facilitator or re-run Lab 1 Exercise 5 (~8 min).

---

**→ [Lab 2.1 — Configure the PA MCP Connection](../lab-02-1-pa-mcp-connection/README.md)**
