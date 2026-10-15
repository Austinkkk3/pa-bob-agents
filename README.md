# Planning Analytics × Bob × watsonx Orchestrate Workshop

**Duration:** 6 hours · Intermediate · Instructor-led

---

## What You'll Build

| | Lab | What you do |
|-|-----|-------------|
| 🛠 | [Lab 0 — Setup](./lab-00-setup/README.md) | Install PA mode & skill, configure MCP — all via Bob |
| 📊 | [Lab 1 — Bob + PA via MCP](./lab-01-bob-planning-analytics-mcp/README.md) | Query TM1 cubes, run variance analysis, build a model from CSV |
| 🤖 | [Lab 2 — FP&A Variance Autopilot](./lab-02-fpa-variance-autopilot/README.md) | Multi-agent system: detect variances, investigate CRM/ERP root causes, generate CFO report |
| 💡 | [Session 3 — Your Scenario](./session-03-your-scenario/README.md) | Adapt the autopilot pattern to your own use case |

---

## Agenda

| Session | Duration |
|---------|----------|
| Welcome + watsonx Orchestrate overview | 40 min |
| Bob overview + PA demo | 30 min |
| **Lab 0** — Environment setup | 30 min |
| *Break* | 15 min |
| **Lab 1** — Bob + Planning Analytics via MCP | 60 min |
| FP&A Variance Autopilot overview | 10 min |
| *Lunch* | 60 min |
| **Lab 2** — FP&A Variance Autopilot | 90 min |
| **Session 3** — Your Scenario | 15 min |
| Wrap-up + Q&A | 10 min |

---

## Prerequisites

| Requirement | Details |
|-------------|---------|
| **IBM Bob IDE** | [Download](https://bob.ibm.com/download) · min 200 coins |
| **IBM Planning Analytics** | TechZone environment — URL + credentials from facilitator |
| **watsonx Orchestrate** | Trial or SaaS tenant — confirm with facilitator |
| **Laptop** | macOS or Windows with internet access |

---

## Repository Structure

```
pa-bob-agents/
├── lab-00-setup/                         ← Environment setup (Bob-assisted)
├── lab-01-bob-planning-analytics-mcp/    ← Lab 1: Bob + PA via MCP
│   └── assets/                           ← CSV files for Exercise 5
├── lab-02-fpa-variance-autopilot/        ← Lab 2: FP&A Variance Autopilot
│   ├── assets/                           ← Agent YAMLs + SalesLens API
│   └── lab-02-0 through lab-02-8/        ← Sub-labs
└── session-03-your-scenario/             ← Adapt to your use case
```

---

**→ [Start with Lab 0](./lab-00-setup/README.md)**
