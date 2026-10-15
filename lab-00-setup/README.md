# Lab 0 — Environment Setup

**Duration:** 10–15 minutes  
**Goal:** Install the Planning Analytics Bob mode & skill, configure MCP, and validate connectivity — all using Bob.

---

## Prerequisites

- IBM Bob IDE installed and logged in ([download here](https://bob.ibm.com/download))
- TechZone credentials from your facilitator: `HOST`, `PORT`, `TENANT_ID`, `USERNAME`, `PASSWORD`
- Workshop folder open as your workspace root in Bob

---

## Step 1 — Install the Skill

**Download the skill folder first:**
Go to [github.com/Austinkkk3/pa-bob-agents/tree/main/planning-analytics-skill](https://github.com/Austinkkk3/pa-bob-agents/tree/main/planning-analytics-skill), download the folder (or clone the repo), and note where it is on your computer.

**Then drag the folder into Bob's chat panel**, and send this message:

```
I've uploaded the planning-analytics-skill folder.
Please install it as a Bob skill:
1. Create the directory .bob/skills/planning-analytics/ in my workspace
2. Copy all files from the uploaded folder into .bob/skills/planning-analytics/
3. Confirm the files SKILL.md, README.md, and USAGE-GUIDE.md are in place
Then I'll restart Bob.
```

After Bob confirms, restart Bob: `Cmd+Shift+P` → **Bob: Restart**

✅ **Done when:** Ask Bob `What skills do you have available?` — `planning-analytics` appears in the list.

---

## Step 1b — Install the Planning Analytics Mode *(optional)*

The mode gives Bob deeper TM1 expertise and financial analysis workflows. Download `planning-analytics-mode.zip` from the [Building Blocks repo](https://github.com/ibm-self-serve-assets/building-blocks/tree/main/optimize/budget-and-forecasting/bob-modes/base-modes), then tell Bob:

```
I've downloaded planning-analytics-mode.zip.
Please install it as a Bob mode:
1. Create .bob/modes/ if it doesn't exist
2. Unzip planning-analytics-mode.zip into .bob/modes/planning-analytics/
3. Move .bob/modes/planning-analytics/custom_modes.yaml to .bob/custom_modes.yaml
Then I'll restart Bob.
```

After Bob confirms, restart Bob. The mode selector should show **📊 Planning Analytics**.

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
