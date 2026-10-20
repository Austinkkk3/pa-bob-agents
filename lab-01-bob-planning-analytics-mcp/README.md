# Lab 1 — Bob + Planning Analytics via MCP

**Duration:** 45 minutes
**Mode:** 📊 Planning Analytics
**Prerequisite:** [Lab 0](../lab-00-setup/README.md) ✅

---

## What You Will Do

| Exercise | Task | Time |
|----------|------|------|
| [1](#exercise-1--explore) | Explore servers, cubes, dimensions | 8 min |
| [2](#exercise-2--query) | Query cube data in plain English | 10 min |
| [3](#exercise-3--variance-analysis) | Budget vs Actual variance analysis | 10 min |
| [4](#exercise-4--outlier--impact-analysis) | Outlier detection and key drivers | 10 min |
| [5](#exercise-5--build-a-tm1-model-from-csv) | Build a cube and load data from CSV | 7 min |

Switch to **📊 Planning Analytics** mode before starting.

---

## Step 0 — Warm Up the PA Query Engine (30 seconds)

> ⚠️ **Do this before Exercise 2.** On a freshly started TechZone instance the PA grid service (query engine) uses lazy initialisation and may not be running yet. MDX queries will return a `409` error until it is warmed up.

1. Open the PAW URL from your TechZone reservation in a browser and log in as `pm` / `IBMDem0s`
2. Go to **Data and Models** → **New workbench** → expand any server → right-click any cube → **Add new view**
3. Wait ~30 seconds
4. Return to Bob — queries will now work

This only needs to be done **once per session**.

---

## Exercise 1 — Explore

```
List all available TM1 servers
```
Note the server name returned — you'll use it throughout this lab.

```
Show me all cubes available on the server, including which ones are pre-analyzed
```
Note which cubes show `is_analyzed: true` — these support natural language queries in Exercise 2.

```
Show me the dimensions and sample members for the [cube name] cube
```

---

## Exercise 2 — Query

> Use a pre-analyzed cube from Exercise 1. If none are available, skip to Exercise 3.

```
Show me revenue data for Q1 by department
```

```
Show me budget vs actual revenue for January 2024, broken down by department
```

```
Which departments had the largest revenue gap between budget and actual?
```

---

## Exercise 3 — Variance Analysis

```
Perform a full variance analysis on revenue for January 2024 across all departments.
Identify all variances greater than $100,000 or greater than 20%, and explain what you find.
```

```
Save this variance view as "Jan2024_Revenue_Variance" for future reference
```

```
Compare January 2024 actual revenue to January 2023 actual revenue by department.
Show year-over-year growth rates.
```

---

## Exercise 4 — Outlier & Impact Analysis

```
Using the January 2024 revenue data, detect any statistical outliers across departments.
Explain what you find in business terms.
```

```
What are the key drivers of the revenue variance in January 2024?
Which factors have the highest impact on the total variance?
```

```
Generate a PDF analysis report for the January 2024 revenue data
```

---

## Exercise 5 — Build a TM1 Model from CSV

The CSV files are in [`lab-01-bob-planning-analytics-mcp/assets/`](./assets/).

```
I have CSV files in the lab-01-bob-planning-analytics-mcp/assets/ folder for an FP&A model.
Read the dimension files (dim_account.csv, dim_department.csv, dim_scenario.csv,
dim_time.csv, dim_version.csv) and the fact file (fact_financial_data.csv).

Create a complete TM1 model on the smartco server:
- Create all required dimensions with their elements and attributes
- Create a cube called FPA_Variance with those dimensions
- Write a TurboIntegrator process to load the fact data
- Execute the process and confirm the data loaded correctly
```

> Bob will take 2–4 minutes to create and execute the TurboIntegrator process. It will show progress.

Verify the load:
```
Show me NA Sales actual revenue for Q1 2024 across all accounts from the FPA_Variance cube
```

---

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| "Cube not pre-analyzed" | Expected — Bob switches to MDX automatically |
| "Member not found" | Bob calls `lookup_potential_members` and presents options |
| TI process fails | Ask: `Show me the error logs for the last TI process` — Bob explains and fixes |

---

**→ [Continue to Lab 2](../lab-02-fpa-variance-autopilot/README.md)**
