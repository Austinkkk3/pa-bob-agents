#!/usr/bin/env python3
"""CSV integrity check for FP&A workshop assets (A5)."""
import csv, sys
from pathlib import Path

assets = Path("pa-bob-agents/lab-01-bob-planning-analytics-mcp/assets")

def load_ids(filename, id_col):
    p = assets / filename
    with open(p, newline='', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        # verify header is first line
        assert reader.fieldnames is not None, f"{filename}: no header"
        return {row[id_col].strip() for row in reader}

errors = []

# Load dimension ID sets
time_ids     = load_ids("dim_time.csv",     "time_id")
account_ids  = load_ids("dim_account.csv",  "account_id")
dept_ids     = load_ids("dim_department.csv","dept_id")
scenario_ids = load_ids("dim_scenario.csv", "scenario_id")
version_ids  = load_ids("dim_version.csv",  "version_id")

# Check fact file
fact_path = assets / "fact_financial_data.csv"
seen_keys = {}
row_count = 0

with open(fact_path, newline='', encoding='utf-8') as f:
    reader = csv.DictReader(f)
    expected_cols = len(reader.fieldnames)
    for i, row in enumerate(reader, start=2):
        row_count += 1
        # Column count
        if len(row) != expected_cols:
            errors.append(f"Row {i}: expected {expected_cols} cols, got {len(row)}")
        # Ref checks
        t = row['time_id'].strip()
        a = row['account_id'].strip()
        d = row['dept_id'].strip()
        s = row['scenario_id'].strip()
        v = row['version_id'].strip()
        if t not in time_ids:
            errors.append(f"Row {i}: time_id '{t}' not in dim_time")
        if a not in account_ids:
            errors.append(f"Row {i}: account_id '{a}' not in dim_account")
        if d not in dept_ids:
            errors.append(f"Row {i}: dept_id '{d}' not in dim_department")
        if s not in scenario_ids:
            errors.append(f"Row {i}: scenario_id '{s}' not in dim_scenario")
        if v not in version_ids:
            errors.append(f"Row {i}: version_id '{v}' not in dim_version")
        # Duplicate key
        key = (t, a, d, s, v)
        if key in seen_keys:
            errors.append(f"Row {i}: duplicate key {key} (first seen row {seen_keys[key]})")
        else:
            seen_keys[key] = i

print(f"Fact rows: {row_count}")
print(f"Unique keys: {len(seen_keys)}")
if errors:
    print(f"\nERRORS ({len(errors)}):")
    for e in errors:
        print(" ", e)
    sys.exit(1)
else:
    print("OK: 0 errors, 0 duplicates, 0 missing references")
