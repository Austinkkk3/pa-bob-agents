# Fix list for pa-bob-agents (Labs 0–3)

Based on end-to-end testing against commit `8ede0ab` and the live TechZone `smartco` server (Oct 20, 2026).

## How to work

- Source of truth = the CSVs in `lab-01-bob-planning-analytics-mcp/assets/`. Do not change any amount.
- Use the reference numbers in Section 0 exactly. Every expected output in the docs must match them.
- Do Part A (repository) first. When done, give me a list of every file you changed with one line each.
- **Do NOT start Part B (live smartco changes) until I reply "go".** Part B deletes and rebuilds the shared `FPA_Variance` cube.
- Scenario names are `Actual` and `Budget` everywhere. `PY-ACT` is a separate scenario and stays as is.
- After every CSV change, run the integrity check in A5.

---

## Section 0 — Reference numbers (copy exactly)

### 0.1 Data conventions

| Meaning | Scenario | Version |
| --- | --- | --- |
| Actual | `Actual` | `V1` |
| Budget | `Budget` | `V2` |
| Reforecast written in Lab 3 | `FC-Q1` | `V3` |
| Seeded forecasts in the CSV | `FC-Q1` … `FC-Q4` | `V4` |
| Prior-year actual | `PY-ACT` | `V1` |

Root cause text lives in the string measure `RootCause` on the Actual/V1 cell.

### 0.2 Jan 2024, prompt threshold ">$100K or >20%" (Lab 2.0, Lab 3 Exercise 1, Lab 3.0)

| Dept | Account | Budget | Actual | Variance | % | Flag |
| --- | --- | --- | --- | --- | --- | --- |
| DEPT-NA-SALES | REV-001 Finished Goods Revenue | 500,000 | 325,000 | -175,000 | -35.0% | Unfavorable |
| DEPT-NA-SALES | OPEX-001 Sales & Distribution OPEX | 120,000 | 145,000 | +25,000 | +20.8% | Unfavorable |
| DEPT-NA-SALES | OPEX-004 Sales Commissions | 50,000 | 32,500 | -17,500 | -35.0% | Favorable |

Not flagged, but fine to show: DEPT-EMEA-SALES REV-001 380,000 → 420,000, +40,000 (+10.5%).

### 0.3 Jan 2024 with the agent thresholds in pa-data-agent.yaml (Lab 2.2 Test 5.2, Lab 2.5, Lab 3.3)

| Severity | Dept | Account | Budget | Actual | Variance | % |
| --- | --- | --- | --- | --- | --- | --- |
| HIGH (revenue > 25%) | DEPT-NA-SALES | REV-001 | 500,000 | 325,000 | -175,000 | -35.0% |
| HIGH (expense > 20%) | DEPT-NA-SALES | OPEX-001 | 120,000 | 145,000 | +25,000 | +20.8% |
| MEDIUM (expense 10–20%) | DEPT-IT | OPEX-007 IT Infrastructure | 75,000 | 89,000 | +14,000 | +18.7% |
| FAVORABLE | DEPT-NA-SALES | OPEX-004 | 50,000 | 32,500 | -17,500 | -35.0% |

Root cause text (verbatim from the CSV Actual rows; OPEX-001 after the A3 change):

- NA REV-001: "Two major deals slipped to February: Acme Corp $120K (procurement delayed) and TechStart $80K (budget freeze). Timing-related variance."
- NA OPEX-001: "Unplanned trade show PO ($18K, one-time) and a new Enterprise AE hired in December ($8.5K/month, recurring)."
- NA OPEX-004: "Lower commissions due to revenue miss. Directly correlated to deal slippage."
- IT OPEX-007: "Emergency security patch deployment and additional AWS costs."

Company totals for Jan 2024 (all departments):

- Revenue: budget 1,975,000, actual 1,828,000 → -147,000 (-7.4%)
- OpEx: budget 1,250,000, actual 1,308,500 → +58,500 (+4.7%)
- COGS: budget 125,000, actual 135,000 → +10,000 (+8.0%)

### 0.4 Q1 2024 reforecast for DEPT-NA-SALES (Lab 3 Exercises 3–5, Lab 3.0, 3.1, 3.3)

| Period | Account | Budget (Budget/V2) | Actual (Actual/V1) | Reforecast (FC-Q1/V3) | Change vs budget |
| --- | --- | --- | --- | --- | --- |
| 2024-01 | REV-001 | 500,000 | 325,000 | 325,000 | -175,000 |
| 2024-02 | REV-001 | 520,000 | 695,000 | 720,000 | +200,000 |
| 2024-03 | REV-001 | 540,000 | 525,000 | 540,000 | 0 |
| 2024-01 | OPEX-001 | 120,000 | 145,000 | 145,000 | +25,000 |
| 2024-02 | OPEX-001 | 125,000 | 128,000 | 133,500 | +8,500 |
| 2024-03 | OPEX-001 | 130,000 | 135,000 | 138,500 | +8,500 |

- Q1 net revenue impact: 1,560,000 → 1,585,000 = **+25,000**
- Q1 net OpEx impact: 375,000 → 417,000 = **+42,000**
- Rule: net quarter impact = sum(V3) − sum(V2) over the quarter's months. It is **not** "$0" and **not** "the slipped amount".
- Feb/Mar actuals exist in the data, but the Lab 3 storyline is "end of January", so the reforecast is built from budget, not from those actuals.

---

## Part A — Repository fixes

### A1. `dim_scenario.csv` (new bug from the last commit)

The fact CSV now uses `Actual`/`Budget`, but `dim_scenario.csv` still defines `ACT`/`BUD`. 156 of 285 fact rows reference a scenario that does not exist in the dimension, so a TM1 load fails for them with "Invalid key".

- Change `scenario_id` `ACT` → `Actual` and `BUD` → `Budget`. Leave every other column and row unchanged.
- When building dimensions from any `dim_*.csv`, store descriptive columns as **text attributes, not aliases**. After this change, `scenario_type` = "Actual" on the PY-ACT row would clash with the element name `Actual` if it were an alias.

### A2. `dim_version.csv`

V3 is the Lab 3 reforecast version, but the CSV calls it "Board Approved" with `is_locked=1`. Change the row to:
`V3,Q1 Reforecast,Reforecast,1,0,2024-02-01,FP&A Team`

### A3. `fact_financial_data.csv`

1. Remove the 5 duplicate keys (same time/account/dept/scenario/version). Lines 276, 277, 278, 279, 282 duplicate lines 198, 205, 212, 226, 263. The amounts are identical, so keep one row per key; keep the copy that has `variance_explanation` text. Result: 280 rows.
2. Update `variance_explanation` on the row `2024-01, OPEX-001, DEPT-NA-SALES, Actual, V1` to:
   "Unplanned trade show PO ($18K, one-time) and a new Enterprise AE hired in December ($8.5K/month, recurring)."
   Reason: in the PA-only Lab 3.3 flow, the Forecast Writer only sees the cube text. The current text has no $8.5K figure, so the agent cannot compute 133,500 / 138,500.
3. Normalize line endings to LF. Today `dim_account.csv`, `dim_department.csv` and `fact_financial_data.csv` are CRLF and the others are LF. Add `*.csv text eol=lf` to `.gitattributes`.

### A4. `dim_account.csv`

`TOTAL-REV`, `TOTAL-COGS` and `TOTAL-OPEX` have parent `ROOT`, but there is no `ROOT` row. Add:
`ROOT,Total P&L,Total,Total,,0,0,0000-000`
Recommended: in the build process, give TOTAL-COGS and TOTAL-OPEX weight -1 under ROOT, so ROOT = operating profit instead of revenue + costs added together.

### A5. CSV integrity check (run after every CSV change and report the output)

Write and run a small script that checks:
- every `time_id`, `account_id`, `dept_id`, `scenario_id`, `version_id` in the fact file exists in the matching `dim_*.csv`;
- no duplicate keys;
- every row has the same number of columns as the header;
- the header is the first line of every file.

Expected: 280 fact rows, 0 missing references, 0 duplicates.

### A6. Lab 0 and `.bob/`

- `.bob/custom_modes.yaml` (line 19) says the rules are in `.bob/rules-planning-analytics/`, but the files are in `.bob/modes/planning-analytics/rules-planning-analytics/`. Check which folder you (Bob) actually load mode-specific rules from. Move the folder or fix the reference, then update the Lab 0 Step 1b install instructions so the rules land in that folder.
- Delete `.bob/modes/planning-analytics/__MACOSX/` and add `__MACOSX/` to `.gitignore`.
- There are two different copies of the skill: `.bob/skills/planning-analytics/SKILL.md` (262 lines) and `planning-analytics-skill/SKILL.md` (166 lines). Lab 0 Step 1 installs the short one over the long one. Keep one canonical version (the more complete one) in both places, or remove the `.bob/skills` copy.
- `lab-00-setup/mcp.json`:
  - Placeholders `<YOUR_TENANT_ID>` and `<YOUR_BASE64_CREDENTIALS>` don't match the README (`<TENANT_ID>`). Align them.
  - In the cube server's `alwaysAllow`, add `save_mdx_view`, `get_saved_view`, `list_cube_views`, `get_MDX_for_recommended_view` and `get_cube_dimensions_with_metadata`. `save_mdx_view` is needed in Lab 1 Exercise 3.
  - In the analysis server, remove `delete_tm1_process` from `alwaysAllow`. This is a shared server, so deletes should require approval.

### A7. Lab 1 README

- **Exercises 2–4:** every prompt must name the cube and server ("…in the FPA_Variance cube on smartco"). smartco also has a `Revenue` cube, so Bob may pick the wrong one.
- **Exercise 2:** `list_cubes_with_ai_analysis_metadata` returns an empty list on all 14 servers today. Either the facilitator pre-analyzes FPA_Variance in PAW before the session (add this to FACILITATOR-SETUP), or rewrite the exercise to expect the MDX path.
- **Exercise 3, year-over-year prompt:** Jan 2023 data exists only as scenario `PY-ACT`, and only for NA, EMEA and APAC. Replace the prompt with:
  "Compare January 2024 actual revenue (scenario Actual, V1, 2024-01) with prior-year actual (scenario PY-ACT, V1, 2023-01) for NA, EMEA and APAC Sales, account REV-001, in FPA_Variance on smartco. Show YoY growth."
  Expected: NA 325,000 vs 450,000 (-27.8%); EMEA 420,000 vs 350,000 (+20.0%); APAC 275,000 vs 250,000 (+10.0%).
- **Exercise 4:** set expectations in the README.
  - Outlier detection on 6 departments × 1 month usually returns "no outliers". Suggest a wider slice, e.g. REV-001 by department × 2024-01..2024-06.
  - `perform_impact_analysis` returns unlabeled x/y scores, and `get_impact_analysis_summary` requires field names, so the two don't chain. Tell participants the PDF report (`generate_exploration_analysis_report`) is the main output.
  - Move `Jan2024_Revenue_Analysis_Report.pdf` from the repo root into `lab-01-.../assets/` and link it as "example output".
- **Exercise 5 (most important):** FPA_Variance is now the shared cube that Labs 2 and 3 depend on, but this exercise still tells every participant to create FPA_Variance on smartco. Change the prompt so each person builds a private copy:
  - cube `<INITIALS>_FPA_Variance`, dimensions `<INITIALS>_FPA_Account` etc., and prefixed TI processes;
  - add to the prompt: "Load all 280 fact rows. Store variance_explanation in a string measure called RootCause; the measures dimension must be the last dimension of the cube. Store descriptive CSV columns as text attributes, not aliases. Do not modify or delete FPA_Variance or any FPA_* object."
  - Note in the README that the MCP TI tools have no data-source parameter, so Bob embeds the rows in TI code. Participants should check that the row count after the load is 280.
  - Update the verify prompt to use the prefixed cube. Expected NA Sales Actual Q1 2024: REV-001 1,545,000; REV-003 565,000; TOTAL-REV 2,110,000.
- The duration says 45 minutes but the agenda says 60. Align them.

### A8. Lab 2

- **2.0:** replace the expected table with Section 0.2. OPEX-001 is 🔴, not 🟡.
- **2.1:** the Orchestrate UI no longer has "Manage → Security". In the current UI, Connections and Credentials are entries in the left navigation. Update the click paths.
- **pa-data-agent.yaml and pa-data-agent-import.yaml:** the instructions must be identical. The import file just has no `tools:` block.
  - Replace every "variance_explanation field in the ACT rows / ACT scenario" (pa-data-agent.yaml lines 24, 71, 79; import file line 24) with "the RootCause string measure on the Actual/V1 cell".
  - Step 4 example (tested, works):
    `SELECT {[FPA_Measures].[FPA_Measures].[RootCause]} ON 0, {[FPA_Account].[FPA_Account].[REV-001], [FPA_Account].[FPA_Account].[OPEX-001]} ON 1 FROM [FPA_Variance] WHERE ([FPA_Time].[FPA_Time].[2024-01], [FPA_Department].[FPA_Department].[DEPT-NA-SALES], [FPA_Scenario].[FPA_Scenario].[Actual], [FPA_Version].[FPA_Version].[V1])`
  - Add to error handling: "If execute_mdx_and_get_view returns 'Failed to encode cube view to markdown/HTML', a member name usually doesn't exist (check with lookup_potential_members), or NON EMPTY was combined with a CROSSJOIN on rows (remove NON EMPTY)."
  - 2.2 README troubleshooting row "variance_explanation only exists for flagged variances" → refer to RootCause.
- **2.2 Test 5.2 and the 2.5 expected output:** use Section 0.3: 4 material variances (2 HIGH, 1 MEDIUM, 1 FAVORABLE).
- **2.5 "More prompts":**
  - March 2024, APAC: REV-001 280,000 → 195,000, -85,000 (-30.4%), HIGH. Root cause: "Major deal pushed to Q2 due to regulatory approval delays in China ($90K)."
  - Replace "March 2025 Product Engineering +$45K". That is only +8.7%, below the threshold, so the agent reports no material variance. Use "March 2024, Finance" instead: OPEX-008 Professional Fees 35,000 → 48,000, +13,000 (+37.1%), HIGH, "Unplanned audit fees for SOX compliance review."
- **assets/fpa-variance-agent.yaml lines 78–84:** the sample MDX uses dimension names that don't exist (`[Scenario]`, `[Department]`, `[Account]`, `[Time]`, `[Version]`), plus BUD/ACT and a V1-only WHERE. Replace it with the same CROSSJOIN example as pa-data-agent.yaml.
- **2.6 and 2.7** assume CRM/ERP agents (2.7 diagram lines 35–36, text line 97). Either mark them "only if you completed optional 2.3/2.4" or update them to the PA Data Agent only.
- **2.8 ADK:**
  - The hello-world `llm: watsonx/meta-llama/llama-3-2-90b-vision-instruct` (lines 133, 188) is not in the trial tenant's model list. Tell participants to pick one from `orchestrate models list`.
  - Line 211 points to `assets/fpa-variance-agent.yaml`, which lists `crm:`/`erp:` tools that won't exist. Point to `lab-02-2-pa-agent/pa-data-agent-import.yaml` instead.

### A9. Lab 3, Bob track (`lab-03-forecast-replan-autopilot/README.md`)

Most participants run this file, and it still has the old numbers.

- **Exercise 1 (lines 41–43):** use Section 0.2 (three flagged rows, OPEX-001 🔴). Use the CSV account names: "Enterprise Software Revenue" and "Sales & Marketing OpEx" don't exist in the data; they are "Finished Goods Revenue" and "Sales & Distribution OPEX". Apply the same name fix in 3.0 and 3.3.
- **Exercise 3 table (lines 84–91):** replace it with Section 0.4 (budgets 500/520/540 and 120/125/130; reforecast 325/720/540 and 145/133.5/138.5). Add the net Q1 impact line: revenue +25,000, OpEx +42,000.
- **Exercise 4 sample confirmation (line 114):** 700,000 → 720,000.
- **Exercise 5:** the verify prompt asks for V1/V2/V3 "using scenario FC-Q1". V1 and V2 are always empty under FC-Q1. Replace it with:
  "For NA Sales REV-001 and OPEX-001, January–March 2024, show Actual (scenario Actual, V1), Budget (scenario Budget, V2) and Reforecast (scenario FC-Q1, V3) side by side in FPA_Variance on smartco."
  Expected = Section 0.4.
- At the bottom, explain the two Lab 3 tracks and link the optional Orchestrate track (3.0). Today no file links to 3.0.

### A10. Lab 3, Orchestrate track (3.0–3.3)

- **3.0:**
  - Lines 14–15: use the CSV account names.
  - Lines 30–41: use Section 0.4 (Feb 720K; net revenue +25K; OpEx Feb 133.5K and Mar 138.5K; Q1 OpEx 417K vs 375K). Remove "Net Q1 impact: $0" and "$402K vs $360K".
  - Lines 65–66: OPEX-001 is 🔴.
- **3.1 Forecast Writer:**
  - Add the tool `get_tm1_server_process_execution_error_logs` (analysis MCP). The Step 4 tool table goes from 4 to 5 tools.
  - Reason: `execute_tm1_processes_asynchronously` returns success even when the TI fails. Tested on a copy of the cube: a write with `pDept = "NA Sales"` returned success, and the error ("Invalid key: … Element Name (Key): "NA Sales"") appeared only in the process error log.
  - In forecast-writer-agent.yaml, make the read-back in step 4 mandatory. If any value mismatches, call the error-log tool for FPA_Write_Forecast and report the error.
  - forecast-writer-agent.yaml lines 29–30: replace "Net quarter impact = slipped amount …" with "Net quarter impact = sum of V3 forecast − sum of V2 budget across the quarter's months."
  - For each affected account, write all three months of the quarter (6 cells for the Jan 2024 case) so V3 holds a complete Q1 reforecast.
- **3.2:** switch to the PA-only orchestrator you created (`fpa-replan-orchestrator-pa-only.yaml`). No README references it today.
  - Step 1 should list only PA Data Agent and Forecast Writer Agent.
  - Step 3 imports the pa-only YAML.
  - Redraw the flow diagram without CRM/ERP; "STEP 8" → "STEP 7".
  - Keep `fpa-replan-orchestrator.yaml` as the labeled optional variant for people who did 2.3/2.4.
- **fpa-replan-orchestrator-pa-only.yaml:**
  - STEP 3 uses one threshold set (HIGH > 25% or > $150K; MEDIUM 15–25%), so OPEX-001 (+20.8%) becomes MEDIUM, which contradicts pa_data_agent (expense > 20% = HIGH). Tell it to keep the severity returned by pa_data_agent.
  - STEP 7 calls the writer "if user asked to replan OR if any HIGH variance exists". That conflicts with the 3.3 prompt "do NOT update the forecast". Change it to: call forecast_writer_agent only if the user asked to replan or update the forecast; if the user said not to, never call it; otherwise ask.
  - Pass only HIGH unfavorable variances to the writer. MEDIUM and favorable variances are reported, not replanned, so the V3 table stays the 6 NA Sales cells in Section 0.4.
- **3.3:**
  - Prompt: "investigate root causes using the CRM and ERP systems" → "using the root cause explanations in the cube".
  - Trace table: 2 sub-agents (pa_data_agent, forecast_writer_agent).
  - Expected output: Section 0.3 (4 material variances, root-cause text verbatim from the cube) and the Section 0.4 V3 table (6 cells). Summary: revenue -147,000 (-7.4%), OpEx +58,500 (+4.7%), "Material variances: 4 (2 HIGH, 1 MEDIUM, 1 FAVORABLE)".
  - Remove the "Sub-agents: … crm_context_agent · erp_context_agent" line. EMEA +10.5% is not material; mention it as a non-material note only.
  - "More prompts":
    - APAC March 2024: root cause from the cube (China regulatory delay, $90K) → timing → V3 Mar 195,000, Apr 300,000 + 90,000 = 390,000.
    - Replace Prod Eng 2025 with Finance OPEX-008 March 2024: one-time → March V3 = actual 48,000, no future change.
    - "do NOT update the forecast": report only, the writer is not called.
  - Troubleshooting "Step 8" → "STEP 7".
- **QUICK-START.md:** the Lab 3 row says "Bob + Orchestrate" but links only the Bob README. List both tracks.
- **Root README.md:** add Lab 3 to the lab table, the repository structure and the agenda (or mark it optional).

### A11. Facilitator docs

- **FACILITATOR-SETUP.md (root), line 67:** `FPA_Create_Account_Dim` doesn't exist. The actual processes are `FPA_Build_Dimensions`, `FPA_Build_Time`, `FPA_Load_Facts`, `FPA_Write_Forecast` (plus `FPA_Reset_Forecast` after Part B). Add a pre-session checklist:
  - warm up the grid service;
  - pre-analyze FPA_Variance in PAW;
  - run FPA_Reset_Forecast.
- **lab-03 FACILITATOR-SETUP.md:**
  - Line 107 still says `server/mcp`. Use `/agentic-ai/analysis/mcp` for process tools and `/agentic-ai/cube/mcp` for cube tools.
  - The verify step (lines 73–81) has the same FC-Q1 + V1/V2 problem as Lab 3 Exercise 5. Use the Actual/Budget/FC-Q1 side-by-side prompt from A9.
  - "Reset Between Workshop Runs": there is no MCP tool that clears data. Add a TI process `FPA_Reset_Forecast` that zeroes all FC-Q1 × V3 cells (temporary view + ViewZeroOut), and tell the facilitator to run it.

---

## Part B — Live smartco environment (wait for my "go")

**Current state (checked Oct 20):**

- FPA_Variance dimensions:
  - FPA_Scenario = Actual, Budget, Forecast, FC-Q1, FC-Q2, FC-Q3
  - FPA_Version = Final, Draft, V1, V2, V3
  - FPA_Time = 2024-01..2025-06 only
  - FPA_Measures = Amount, Units, Rate, Variance, Variance_Pct, RootCause (**RootCause is Numeric**)
- Loaded data: 96 Actual/Budget cells (all match the CSV), 20 legacy cells in version `Final`, and 6 FC-Q1/V3 test write-backs.
- Missing members: DEPT-LATAM-SALES, DEPT-CUST-SUC, DEPT-CLOUD-OPS, OPEX-005..008, all 2023 and 2026 months, scenarios PY-ACT and FC-Q4, versions V4 and V5. Because of this, all PY-ACT and FC rows and 60 Actual/Budget rows cannot load.
- There is no RootCause text anywhere, so Lab 2's "root causes from the cube" cannot work.

**Steps:**

1. Delete the cube FPA_Variance. Everything in it will be reloaded. Keep the process FPA_Write_Forecast.
2. Rebuild the 6 dimensions exactly from the fixed CSVs (FPA_Build_Dimensions / FPA_Build_Time): elements, consolidations and text attributes. FPA_Measures = `Amount` (Numeric) + `RootCause` (String). The legacy elements (Final, Draft, Forecast, REV-005, DEPT-OPERATIONS, DEPT-LEGAL, DEPT-EXEC, Units, Rate, Variance, Variance_Pct) go away; no lab references them.
3. Recreate FPA_Variance with dimensions in this order: FPA_Account, FPA_Department, FPA_Scenario, FPA_Time, FPA_Version, FPA_Measures.
4. Rewrite FPA_Load_Facts to load all 280 rows: `CellPutN(amount, …, 'Amount')`, plus `CellPutS(text, …, 'RootCause')` where `variance_explanation` is not empty. Escape single quotes. The MCP TI tools have no file data source, so embed the rows in the Epilog.
5. Verify with MDX and report:
   - 280 non-empty Amount leaf cells;
   - 90 non-empty RootCause cells, 34 of them on Actual;
   - the Jan 2024 totals in Section 0.3;
   - FC-Q1 × V3 is empty;
   - the RootCause query from A8 returns text.
6. Create and run FPA_Reset_Forecast. Then test FPA_Write_Forecast: write 325000 to REV-001 / DEPT-NA-SALES / FC-Q1 / 2024-01 / V3, read it back, then reset.
7. Delete the test objects Claude created:
   - cube `CLAUDETEST_FPA_Variance` (its view `CLAUDETEST_Jan2024_Revenue_Variance` goes with it);
   - dimensions `CLAUDETEST_Account`, `CLAUDETEST_Department`, `CLAUDETEST_Scenario`, `CLAUDETEST_Time`, `CLAUDETEST_Version`, `CLAUDETEST_Measures`;
   - processes `CLAUDETEST_Build_Dimensions`, `CLAUDETEST_Load_Facts`, `CLAUDETEST_Write_Forecast`.
8. Manual step for me: pre-analyze FPA_Variance in PAW.

---

## Part C — Final checks (report the results)

1. Run the A5 integrity check and paste the output.
2. Search the repo (excluding `node_modules` and the optional 2.3/2.4 files) for the following. Each should return nothing, or only lines you can justify:
   - `granite-3-3`, `agentic-ai/mcp"`, `server/mcp`
   - `ACT` as a scenario (not `PY-ACT`), `BUD`
   - `700,000`, `$700K`, `128,500`, `$128.5K`, `Net Q1 impact: $0`, `$402K`
   - `Enterprise Software Revenue`, `Sales & Marketing OpEx`
   - `crm_context_agent` in core-path files
3. List every file you changed, with one line each.
