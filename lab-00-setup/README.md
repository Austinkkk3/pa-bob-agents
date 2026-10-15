# Lab 0 — Environment Setup

**Duration:** 10–15 minutes  
**Goal:** Install the Planning Analytics Bob mode & skill, configure MCP, and validate connectivity — all using Bob.

---

## Prerequisites

- IBM Bob IDE installed and logged in ([download here](https://bob.ibm.com/download))
- TechZone credentials from your facilitator: `HOST`, `PORT`, `TENANT_ID`, `USERNAME`, `PASSWORD`
- Workshop folder open as your workspace root in Bob

---

## Step 1 — Install Mode & Skill

Paste this into the Bob chat panel and hit Enter:

```
Run these commands to install the Planning Analytics mode and skill:

git clone https://github.com/ibm-self-serve-assets/building-blocks.git /tmp/bb --depth=1 --filter=blob:none --sparse && \
cd /tmp/bb && git sparse-checkout set optimize/budget-and-forecasting && \
mkdir -p .bob/modes .bob/skills && \
unzip -o "/tmp/bb/optimize/budget-and-forecasting/bob-modes/base-modes/planning-analytics-mode.zip" -d .bob/modes/planning-analytics && \
mv .bob/modes/planning-analytics/custom_modes.yaml .bob/custom_modes.yaml && \
unzip -o "/tmp/bb/optimize/budget-and-forecasting/bob-skills/planning-analytics-skill.zip" -d .bob/skills/

Then restart Bob: Cmd+Shift+P → Bob: Restart
```

✅ **Done when:** The mode selector shows **📊 Planning Analytics**.

---

## Step 2 — Configure MCP

Paste this into Bob, replacing the five placeholders with your TechZone credentials:

```
Configure my Planning Analytics MCP connection with these credentials:
- Host: <TECHZONE_HOST>
- Port: <PORT>
- Tenant ID: <TENANT_ID>
- Username: <PA_USERNAME>
- Password: <PA_PASSWORD>

Steps:
1. Run: echo -n "<PA_USERNAME>:<PA_PASSWORD>" | base64
2. Open Cmd+Shift+P → Bob: Open MCP Settings
3. Replace the contents of mcp.json with the configuration from lab-00-setup/mcp.json,
   substituting the correct HOST, PORT, TENANT_ID, and the base64 value you just generated
4. Save and run Cmd+Shift+P → Bob: Restart
```

The MCP template is in [`lab-00-setup/mcp.json`](./mcp.json).

✅ **Done when:** Bob restarts with no MCP errors.

---

## Step 3 — Validate

Switch to **📊 Planning Analytics** mode and send:

```
List all available TM1 servers
```

✅ **Done when:** Bob returns at least one server name (e.g. `DemoGuide`).

---

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| Mode not in selector | Check `.bob/custom_modes.yaml` exists → restart Bob |
| `401 Unauthorized` | Re-check base64 encoding: format must be `username:password` before encoding |
| `Connection refused` | Confirm HOST and PORT with facilitator |
| MCP servers show disconnected | Save `mcp.json` → Bob: Restart |

---

**→ [Continue to Lab 1](../lab-01-bob-planning-analytics-mcp/README.md)**
