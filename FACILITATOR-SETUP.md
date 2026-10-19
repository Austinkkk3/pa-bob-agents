# Facilitator Setup — Environment Values

Fill in the values below before each session. **Share the completed credential sheet with each participant** at the start of the workshop — keep this page open during the session.

**Workshop lab repo:** https://github.com/Austinkkk3/pa-bob-agents

---

## Section 1 — IBM Planning Analytics (TechZone)

TechZone shared instance — used in Lab 0, Lab 1, Lab 2, Lab 3.

| Placeholder | Your Value |
|-------------|------------|
| `<TECHZONE_HOST>` | |
| `<PORT>` | |
| `<TENANT_ID>` | |
| `<PA_USERNAME>` | `pm` |
| `<PA_PASSWORD>` | `IBMDem0s` |

**Full MCP URL to share with participants:**
```
http://<TECHZONE_HOST>:<PORT>/api/<TENANT_ID>/v0/agentic-ai/cube/mcp
```

**Bob MCP config** (`~/.bob/settings/mcp.json`) — already configured in Lab 0. No changes needed for Lab 2/3.

---

## Section 2 — watsonx Orchestrate

Used in Lab 2 only. Each participant gets their own Orchestrate environment.

### How to provision participant environments

1. Go to your IBM TechZone reservation or IBM Cloud account
2. For each participant, provision a **watsonx Orchestrate** instance or share access to your tenant
3. Each participant logs in at their own Orchestrate URL (format: `https://<tenant>.watson-orchestrate.ibm.com`)

### What to share with each participant

Give each person a credential card with:

| Item | Value |
|------|-------|
| Orchestrate URL | `https://<their-tenant>.watson-orchestrate.ibm.com` |
| Login | IBM ID (their own) or shared credentials |
| PA MCP URL | `http://<TECHZONE_HOST>:<PORT>/api/<TENANT_ID>/v0/agentic-ai/cube/mcp` |
| PA Username | `pm` |
| PA Password | `IBMDem0s` |

### If using a shared tenant (simplest option)

All participants log into **your** Orchestrate tenant. Ask each person to prefix their agent names with their initials to avoid collisions (e.g. `JD-PA-Data-Agent`).

---

## Section 3 — Lab 3 Setup (Bob write-back)

Run once before Lab 3. The `FPA_Write_Forecast` TI process has already been created on `smartco`. To verify:

```
In Bob (Planning Analytics mode):
"Show me the TI processes on smartco that start with FPA"
```

Expected: `FPA_Build_Dimensions`, `FPA_Create_Account_Dim`, `FPA_Load_Facts`, `FPA_Write_Forecast`

If `FPA_Write_Forecast` is missing, see [`lab-03-forecast-replan-autopilot/FACILITATOR-SETUP.md`](lab-03-forecast-replan-autopilot/FACILITATOR-SETUP.md).

---

## Quick Reference — All Placeholders

| Placeholder | Where used | Value |
|-------------|-----------|-------|
| `<TECHZONE_HOST>` | Lab 0, 1, 2, 3 | TechZone reservation details |
| `<PORT>` | Lab 0, 1, 2, 3 | TechZone reservation details |
| `<TENANT_ID>` | Lab 0, 1, 2, 3 | TechZone reservation details |
| `<PA_USERNAME>` | Lab 0, 1, 2, 3 | `pm` |
| `<PA_PASSWORD>` | Lab 0, 1, 2, 3 | `IBMDem0s` |
| `<ORCHESTRATE_URL>` | Lab 2 | Per-participant Orchestrate tenant |
