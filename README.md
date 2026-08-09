# Autopoietic Harness (`@codeofficer/autopoietic-harness`)

> Additive self-improving AI governance harness and layered knowledge engine for Claude Code.

---

# 📖 Part 1: Plugin Consumer Guide
> *For developers using this plugin in their project repositories.*

## 1. Installation & Registration

To enable the plugin locally in Claude Code, link this plugin repository into your Claude plugins directory:

```bash
mkdir -p ~/.claude/plugins
ln -s /home/code/orca/workspaces/shuky-test/claude-plugin-conversion ~/.claude/plugins/autopoietic-harness
```

---

## 2. Zero-Impact Default & Opt-In (`/init`)

Installing the plugin does **NOT** activate governance or telemetry on your repositories by default. All hooks remain 100% inactive (<1ms bypass exit) until you explicitly initialize a repository.

### Initializing a Repository
To activate Autopoietic Harness in a project repository:
1. Open Claude Code inside your target project directory:
   ```bash
   cd /path/to/my-project
   claude
   ```
2. Run the initialization slash command:
   ```slash
   /autopoietic-harness:init
   ```

### What `/init` Creates in Your Repository:
- `kb/governance/constitution.md` — The active 8 Constitutional Laws.
- `kb/index.md` — Local knowledge base index.
- `CLAUDE.md` — Project governance rules.
- `.autopoietic/` — Plugin state directory containing `.autopoietic/enabled`, `.autopoietic/friction/`, `.autopoietic/staging/`.
- `.gitignore` — Entry for `.autopoietic/`.

---

## 3. ⚙️ Configuration Guide

Autopoietic Harness can be configured globally via Claude Code, per session via environment variables, or per project via local configuration files.

### Configuration Resolution Hierarchy (Order of Precedence)

```
┌────────────────────────────────────────────────────────────────────────┐
│ 1. Project Local Overrides (.autopoietic/config.json) [Highest]        │
├────────────────────────────────────────────────────────────────────────┤
│ 2. Namespaced Environment Variables (AUTOPOIETICO_<KEY>) [Medium]       │
├────────────────────────────────────────────────────────────────────────┤
│ 3. Plugin Manifest Defaults (.claude-plugin/plugin.json) [Default]     │
└────────────────────────────────────────────────────────────────────────┘
```

#### Method 1: Project Local Override (`.autopoietic/config.json`) — *Highest Priority*
Create `.autopoietic/config.json` inside your project root to customize thresholds specifically for that repository:
```json
{
  "event_threshold": 5,
  "cooldown_minutes": 30
}
```

#### Method 2: Namespaced Environment Variables (`AUTOPOIETICO_<KEY>`) — *Medium Priority*
Set environment variables in your terminal or `.bashrc`:
- `AUTOPOIETICO_ENABLED=true|false` — Master kill switch
- `AUTOPOIETICO_QUARANTINE_MODE=true|false` — Stage proposals in `~/.autopoietic/staging/` to keep project working tree clean
- `AUTOPOIETICO_EVENT_THRESHOLD=5` — Telemetry failure count required to trigger automated review
- `AUTOPOIETICO_COOLDOWN_MINUTES=30` — Cooldown period between automated reviews
- `AUTOPOIETICO_PLUGIN_SOURCE_PATH=~/code/autopoietic-harness` — Path to plugin engine repo for Maintainer Mode

*Note: Environment variables set by Claude Code (`CLAUDE_PLUGIN_OPTION_<KEY>`) are also supported automatically.*

#### Method 3: Claude Code Global Plugin Options
Run `/plugin configure autopoietic-harness` inside Claude Code to set global user options interactively.

### Configuration Options Reference

| Option | Type | Default | Environment Variable | Description |
|---|---|---|---|---|
| `enabled` | `boolean` | `true` | `AUTOPOIETICO_ENABLED` | Master kill switch (true/false) |
| `quarantine_mode` | `boolean` | `false` | `AUTOPOIETICO_QUARANTINE_MODE` | Stage proposals in `~/.autopoietic/staging/` instead of repo `.autopoietic/staging/` |
| `plugin_source_path` | `directory` | `~/code/autopoietic-harness` | `AUTOPOIETICO_PLUGIN_SOURCE_PATH` | Path to autopoietic-harness plugin engine repository |
| `event_threshold` | `integer` | `3` | `AUTOPOIETICO_EVENT_THRESHOLD` | Minimum un-synthesized friction events before automated review triggers |
| `cooldown_minutes` | `integer` | `60` | `AUTOPOIETICO_COOLDOWN_MINUTES` | Cooldown period (in minutes) between automated reviews |

---

## 4. Daily Usage

### Check Harness Health & Telemetry
```slash
/autopoietic-harness:status
```
Displays active plugin version, recorded friction events count, threshold progress (`1 / 3 events`), review cooldown status, and pending proposals.

### Ratify & Adopt Self-Improvements
When recurring friction occurs, automated background synthesis creates proposal cards. To review and adopt fixes:
```slash
/autopoietic-harness:ratify
```
- Select **Option A: Adopt Locally** to apply the fix strictly inside your target repository.

---

# 🛠️ Part 2: Plugin Engine Developer Guide
> *For engineers maintaining or building the `@codeofficer/autopoietic-harness` plugin engine.*

## 1. Engine vs. State Architecture

The plugin enforces a strict boundary between **Engine** (shipped code) and **State** (project data):

- **The Plugin (Engine)**: Lives in this repository. Contains `.claude-plugin/`, `hooks/`, `skills/`, `core-kb/`, `templates/`, and `.claude-plugin/system-prompt.md`.
- **The Repository (State)**: Lives in the consumer's repo. Contains `kb/`, `.autopoietic/staging/`, and `.autopoietic/friction/`.

---

## 2. Dogfooding (Plugin Consuming Itself)

When developing the plugin engine itself inside this repository:
- Run `/autopoietic-harness:init` to scaffold maintainer governance.
- `plugin_source_path` automatically resolves to `$CLAUDE_PROJECT_DIR` without requiring manual configuration.
- Local maintainer thresholds can be customized via `.autopoietic/config.json`.

---

## 3. Target Layout

```
.claude-plugin/
├── plugin.json                 # Manifest: name, version, userConfig parameters
├── hooks.json                  # Event bindings
├── marketplace.json            # Marketplace catalog entry
└── system-prompt.md            # XML-fenced prompt injection (<30 tokens)
hooks/                          # Executable Hook Scripts
├── session-start-prompt.sh     # SessionStart prompt injection
├── log-friction.sh             # Telemetry logger (secret redaction, mcp__* payload filter)
├── end-session-review.sh       # Debounced background review (cooldown + threshold guards)
├── pending-proposals.sh        # Pending proposal notice at session start
├── enforce-policy.sh           # PreToolUse deterministic policy enforcer
└── status-check.sh             # Dynamic 3-tier config & health status check (<0.02s)
skills/                         # Interactive Verbs
├── ratify/                     # Interactive ratification & Maintainer Upstream Mode
├── status/                     # Harness health & status dashboard
├── init/                       # Repository initialization verb
└── migrate/                    # Legacy single-repo upgrade verb
core-kb/                        # Baseline OKF concepts shipped with plugin
templates/                      # Scaffolding templates used by /init
```

---

## 4. Documentation & Test Suites

- **[docs/EXAMPLE-PROMPTS.md](docs/EXAMPLE-PROMPTS.md)**: Realistic example prompts and test suites for Consumer & Maintainer workflows.
