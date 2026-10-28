# Lab 0 — Environment Setup

**Duration:** 10–15 minutes  
**Goal:** Install the Planning Analytics Bob mode & skill, configure MCP, and validate connectivity — all using Bob.

---

## Prerequisites

- IBM Bob IDE installed and logged in ([download here](https://bob.ibm.com/download))
- TechZone credentials from your facilitator: `HOST`, `PORT`, `TENANT_ID`
- Workshop folder open as your workspace root in Bob

> ⚠️ **Planning Analytics version must be 2.1.20** — other versions are not compatible with the MCP tools used in this workshop.

---

## Step 1 — Install the Skill

**Download the skill first:**
Click **[planning-analytics-skill.zip](https://github.com/Austinkkk3/pa-bob-agents/raw/main/lab-00-setup/planning-analytics-skill.zip)** to download it, then unzip it. You get a `planning-analytics-skill` folder with `SKILL.md`, `README.md` and `USAGE-GUIDE.md`; note where it is on your computer. If you cloned the repo, the same folder is at [`planning-analytics-skill/`](../planning-analytics-skill/).

> **Alternative:** Download directly from the IBM Building Blocks repo:
> Skill ZIP → [planning-analytics-skill.zip](https://github.com/ibm-self-serve-assets/building-blocks/blob/main/automation/optimize/budget-and-forecasting/bob-skills/planning-analytics-skill.zip)
> Mode ZIP → [planning-analytics-mode.zip](https://github.com/ibm-self-serve-assets/building-blocks/blob/main/automation/optimize/budget-and-forecasting/bob-modes/base-modes/planning-analytics-mode.zip)

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

The mode gives Bob deeper TM1 expertise and financial analysis workflows. Download `planning-analytics-mode.zip` from the [Building Blocks repo](https://github.com/ibm-self-serve-assets/building-blocks/tree/main/automation/optimize/budget-and-forecasting/bob-modes/base-modes), then tell Bob:

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

MCP (Model Context Protocol) is what lets Bob talk directly to your Planning Analytics TM1 server. You will point Bob at your TechZone environment by editing one JSON file.

### What you need first

Get these three values from your facilitator (written on the screen or whiteboard):

| Value | Example | Where to get it |
|-------|---------|-----------------|
| `TECHZONE_HOST` | `192.168.100.50` | Facilitator / TechZone reservation page |
| `PORT` | `8080` | Facilitator |
| `TENANT_ID` | `abc123def` | Facilitator |

Your login credentials for this workshop are fixed:

| Field | Value |
|-------|-------|
| Username | `pm` |
| Password | `IBMDem0s` |

---

### 2a — Generate your Base64 credential string

The MCP connection uses HTTP Basic Auth, which requires your credentials encoded in Base64.

**Mac / Linux** — open Terminal and run:
```bash
echo -n "pm:IBMDem0s" | base64
```

**Windows (PowerShell)** — run:
```powershell
[Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes("pm:IBMDem0s"))
```

Both commands produce the same output:
```
cG06SUJNRGVtMHM=
```

> ⚠️ Copy the **exact** output — no extra spaces or line breaks. This string does not change because the username and password are fixed for this workshop.

---

### 2b — Open the MCP Settings file in Bob

1. Make sure Bob (VS Code) is in focus.
2. Press **`Cmd+Shift+P`** (Mac) or **`Ctrl+Shift+P`** (Windows) to open the Command Palette.
3. Type `Bob: Open MCP Settings` and press **Enter**.

> A file called `mcp.json` opens in the editor. It may be empty `{}` or contain a previous configuration — that is fine, you will replace it entirely.

---

### 2c — Fill in the MCP template

Open [`lab-00-setup/mcp.json`](./mcp.json) in this repository. It looks like this:

```json
{
  "mcpServers": {
    "ibm-pa-tools-tz-server": {
      "type": "streamable-http",
      "url": "http://<TECHZONE_HOST>:<PORT>/api/<TENANT_ID>/v0/agentic-ai/analysis/mcp",
      "headers": {
        "Authorization": "Basic <BASE64_CREDENTIALS>",
        "Accept": "text/event-stream",
        "Cache-Control": "no-cache"
      },
      ...
    },
    "ibm-pa-tools-tz-cube": {
      "type": "streamable-http",
      "url": "http://<TECHZONE_HOST>:<PORT>/api/<TENANT_ID>/v0/agentic-ai/cube/mcp",
      "headers": {
        "Authorization": "Basic <BASE64_CREDENTIALS>",
        ...
      },
      ...
    }
  }
}
```

**Replace all four placeholders** with your real values:

| Placeholder | Replace with | Example result |
|-------------|-------------|----------------|
| `<TECHZONE_HOST>` | Your HOST from the facilitator | `192.168.100.50` |
| `<PORT>` | Your PORT from the facilitator | `8080` |
| `<TENANT_ID>` | Your TENANT_ID from the facilitator | `abc123def` |
| `<BASE64_CREDENTIALS>` | Output from Step 2a | `cG06SUJNRGVtMHM=` |

> 💡 There are **two** places where `<TECHZONE_HOST>`, `<PORT>`, `<TENANT_ID>`, and `<BASE64_CREDENTIALS>` appear — one for the `ibm-pa-tools-tz-server` block and one for the `ibm-pa-tools-tz-cube` block. Replace all occurrences.

**Paste the fully substituted JSON** into the `mcp.json` file that Bob opened, replacing everything that was there before.

---

### 2d — Save the file

Press **`Cmd+S`** (Mac) or **`Ctrl+S`** (Windows) to save `mcp.json`.

---

### 2e — Restart Bob

1. Press **`Cmd+Shift+P`** (Mac) or **`Ctrl+Shift+P`** (Windows).
2. Type `Bob: Restart` and press **Enter**.
3. Wait about 10–15 seconds for Bob to reload.

---

### 2f — Verify the connection

After Bob restarts, send this message in the chat:

```
List all available TM1 servers
```

Bob should reply with a list that includes `DemoGuide`. If it does, the MCP connection is working.

✅ **Done when:** Bob returns a list of TM1 server names with no error messages.

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
| `401 Unauthorized` | Re-check base64 encoding — format must be `username:password` (no spaces) before encoding |
| `Connection refused` | Confirm HOST and PORT with facilitator; check you are on the same network as the TechZone environment |
| MCP servers show disconnected | Save `mcp.json` → Bob: Restart |
| Both `<TECHZONE_HOST>` placeholders not replaced | Search the file for `<` — every placeholder must be gone before saving |

---

**→ [Continue to Lab 1](../lab-01-bob-planning-analytics-mcp/README.md)**
