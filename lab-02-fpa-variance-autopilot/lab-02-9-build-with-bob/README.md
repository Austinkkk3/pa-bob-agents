# Lab 2.9 — Build the Lab 2 Agents with Bob *(draft — being tested)*

**Duration:** ~15 minutes (after the one-time setup)
**Replaces:** Labs 2.1, 2.2 (Steps 1–5) and 2.5 when each participant has their own Orchestrate environment
**Prerequisite:** [Lab 0](../../lab-00-setup/README.md) ✅ · your own watsonx Orchestrate environment

> ⚠️ This path has not been run end to end yet. Use the click-through labs (2.1 → 2.2 → 2.5) for a live session until this note is removed.

---

## Goal

Instead of clicking through the Orchestrate UI, ask Bob to build the same two agents with the watsonx Orchestrate **Agent Development Kit (ADK)**:

| What | Name | Notes |
|------|------|-------|
| PA connection | `planning-analytics-basic` | Basic Auth, team credentials, draft and live |
| PA MCP toolkit | `planning-analytics-cube-mcp` | 6 read-only tools |
| Sub-agent | `pa_data_agent` (PA Data Agent) | Same validated instructions as Lab 2.2 |
| Orchestrator | `fpa_variance_autopilot` (FP&A Variance Autopilot) | Same instructions as Lab 2.5, collaborator `pa_data_agent` |

The files in this folder are ready to use. Bob should run them, not rewrite them: the PA Data Agent's fixed MDX was tested and is easy to break.

| File | Purpose |
|------|---------|
| [`pa-data-agent.adk.yaml`](pa-data-agent.adk.yaml) | PA Data Agent with its 6 tools, GPT-OSS 120B, ReAct Core style |
| [`fpa-orchestrator.adk.yaml`](fpa-orchestrator.adk.yaml) | Orchestrator with `pa_data_agent` as collaborator |
| [`setup-agents.sh`](setup-agents.sh) | Creates the connection and toolkit, imports both agents, deploys them to Live |

---

## Before you start

- **Python 3.11–3.13** on your laptop (`python3 --version`). The Python that ships with macOS is too old; install a newer one from python.org or with Homebrew.
- **Orchestrate API key and service URL:** in Orchestrate, open your profile menu → **Settings** → **API details** → generate an API key. Copy the service instance URL shown on the same page.
- **PA MCP URL** from your facilitator: `http://<HOST>:<PORT>/api/<TENANT_ID>/v0/agentic-ai/cube/mcp`

---

## Ask Bob to build the agents

Bob does the setup and the checks. You run one command yourself in the VS Code terminal, because that is the only place where the API key and password you type stay hidden. Bob's own command runner would show them in the chat, so the script refuses to run there.

**1.** Open a new Bob task and switch Bob to **Agent** mode. Planning Analytics mode cannot run terminal commands, so Bob only hands you copy-paste blocks there.

**2.** Replace the two URLs, then send this in Bob:

```
Build the Lab 2 agents in my watsonx Orchestrate environment with the Orchestrate ADK.
Use the files in the repo exactly as they are: do not rewrite the YAML files, the script
or the agent instructions. Run steps 1, 2 and 4 yourself in the terminal, one at a time.
1. Clone https://github.com/Austinkkk3/pa-bob-agents.git into ~/pa-bob-agents-client,
   or run git pull if it is already there.
2. Check that Python 3.11-3.13 is available, create the virtual environment
   ~/pa-bob-agents-client/.venv-adk with it and install ibm-watsonx-orchestrate.
3. Do not run setup-agents.sh yourself: it asks for my Orchestrate API key and PA password,
   and your command runner cannot hide what I type. Give me one command to paste into the
   VS Code terminal that goes to lab-02-fpa-variance-autopilot/lab-02-9-build-with-bob,
   activates the virtual environment and runs ./setup-agents.sh with
   WXO_URL=<my Orchestrate service instance URL>
   PA_MCP_URL=<PA MCP URL from the facilitator>
   Never ask me to paste the key or the password into the chat. Wait until I say it finished.
4. Then run "orchestrate agents list" and "orchestrate toolkits list" and confirm that
   pa_data_agent, fpa_variance_autopilot and planning-analytics-cube-mcp are there.
   If a step fails, show me the error and fix it.
```

**3.** Click **Approve once** for each command Bob wants to run (clone, Python check, virtual environment, install). Read each command before you approve it.

**4.** When Bob gives you the command, open the VS Code terminal (**View → Terminal** or ⌘J), paste the command and press Enter. When asked, paste your Orchestrate API key, then type the PA password. Nothing is shown while you type.

**5.** Wait for `Done.` (1–2 minutes), then tell Bob `It finished` so it can run the checks in step 4 of the prompt.

> If step 3/5 fails with `502 ... ConnectTimeout`, Orchestrate could not reach the PA server in time. Wait a minute and run the same command again (press ↑ in the terminal); it reuses what was already created.

### Build a second copy next to existing agents

If the environment already has the Lab 2 agents (for example a facilitator demo), run the script with `VARIANT=Bob` (add it next to `WXO_URL` in the prompt, and add `_bob` / `-bob` to the names in step 4). It builds **PA Data Agent (Bob)** and **FP&A Variance Autopilot (Bob)** with their own connection (`planning-analytics-basic-bob`) and toolkit (`planning-analytics-cube-mcp-bob`). The agents, connection and toolkit without the suffix are not changed.

Without `VARIANT`, the script reuses an existing `planning-analytics-basic` connection and toolkit and updates agents with the same names.

---

## Test

In Orchestrate → **Chat**, pick **FP&A Variance Autopilot** and ask:

```
Run the FP&A variance analysis for January 2024 on the FPA_Variance cube on smartco.
Identify all material variances, explain the root causes, and generate a full variance report.
```

Expected: the same report as Lab 2.5 — 4 material variances (🔴 NA Sales REV-001 -$175,000, 🔴 NA Sales OPEX-001 +$25,000, 🟡 IT OPEX-007 +$14,000, ✅ NA Sales OPEX-004 -$17,500) and company totals of TOTAL-REV -$147,000 (-7.44%).

---

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| `orchestrate: command not found` | The virtual environment is not active. Ask Bob to activate `.venv-adk` and re-run |
| Python version error during install | Install Python 3.12 and recreate `.venv-adk` with it |
| `401` or authentication error | Regenerate the API key and check `WXO_URL` is the service instance URL from API details |
| Agent import says a tool is not found | Run `orchestrate tools list` and check that the 6 tools start with `planning-analytics-cube-mcp:` |
| Bob rewrites the YAML or instructions | Stop it and resend the prompt; the files must be used as they are |
| Bob gives you commands to paste instead of running them | Switch Bob to **Agent** mode and ask it to run the steps itself |
| `Run this script yourself in the VS Code terminal` | Bob tried to run `setup-agents.sh`. Copy the command into the VS Code terminal and run it there |
| You typed the API key into the Bob chat by mistake | Delete that key in Orchestrate (Settings → API details), generate a new one, and delete that Bob task |
| `502 ... ConnectTimeout` when creating the toolkit | Wait a minute and re-run the script; it reuses the connection that was already created |
