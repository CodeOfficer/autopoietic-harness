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
- `kb/governance/constitution.md` — The active 7 Constitutional Laws.
- `kb/index.md` — Local knowledge base index.
- `CLAUDE.md` — Project governance rules.
- `.claude/autopoietic-enabled` — Opt-in flag enabling harness hooks.
- `.gitignore` — Entries for `.claude/friction/` and `.staging/`.

---

## 3. Daily Usage

### Check Harness Health & Telemetry
```slash
/autopoietic-harness:status
```
Displays active plugin version, recorded friction events count, synthesis review status, and pending proposals.

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

- **The Plugin (Engine)**: Lives in this repository. Contains `.claude-plugin/`, `hooks/`, `skills/`, `core-kb/`, `templates/`, and `system-prompt.md`.
- **The Repository (State)**: Lives in the consumer's repo. Contains `kb/`, `.staging/`, and `.claude/friction/`.

---

## 2. Target Layout

```
.claude-plugin/
├── plugin.json                 # Manifest: name, version, userConfig parameters
└── hooks.json                  # Event bindings (SessionStart, PostToolUseFailure, PermissionDenied, SessionEnd)
hooks/                          # Executable Hook Scripts
├── session-start-prompt.sh     # XML-fenced prompt injection (<30 tokens)
├── log-friction.sh             # Telemetry logger (secret redaction, mcp__* payload filter)
├── end-session-review.sh       # Debounced background review (cooldown + threshold guards)
└── pending-proposals.sh        # Pending proposal notice at session start
skills/                         # Interactive Verbs
├── ratify/                     # Interactive ratification & Maintainer Upstream Mode
├── status/                     # Harness health & status dashboard
├── init/                       # Repository initialization verb
└── migrate/                    # Legacy single-repo upgrade verb
core-kb/                        # Baseline OKF concepts shipped with plugin
templates/                      # Scaffolding templates used by /init
```

---

## 3. Configuration Flags (`userConfig`)

Configurable via `.claude-plugin/plugin.json` or environment variables:

| Option | Environment Variable | Default | Description |
|---|---|---|---|
| `enabled` | `CLAUDE_PLUGIN_OPTION_ENABLED` | `true` | Master kill switch |
| `quarantine_mode` | `CLAUDE_PLUGIN_OPTION_QUARANTINE_MODE` | `false` | Global staging directory |
| `plugin_source_path` | `CLAUDE_PLUGIN_OPTION_PLUGIN_SOURCE_PATH` | `~/code/autopoietic-harness` | Path to upstream plugin repo for Maintainer Mode |
| `event_threshold` | `CLAUDE_PLUGIN_OPTION_EVENT_THRESHOLD` | `3` | Minimum un-synthesized friction events before review triggers |
| `cooldown_minutes` | `CLAUDE_PLUGIN_OPTION_COOLDOWN_MINUTES` | `60` | Cooldown period between synthesis runs |

---

## 4. Upstream Maintainer Mode Promotion

When testing self-improvement in consumer repositories, plugin maintainers can graduate verified fixes upstream:
1. Run `/autopoietic-harness:ratify` in the consumer repository.
2. Choose **Option B: Promote Upstream (Maintainer Mode)**.
3. Staged artifacts will copy directly into `$CLAUDE_PLUGIN_OPTION_PLUGIN_SOURCE_PATH` for global plugin updates.
