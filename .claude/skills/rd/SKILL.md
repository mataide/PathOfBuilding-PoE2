---
name: "rd"
description: "Comprehensive research and analysis using sequential thinking, MCP tool orchestration, and intelligent project context loading. Use when deep research, code analysis, or multi-tool investigation is needed. Also loads PoB2 `docs/` rules (modSyntax, addingMods, addingSkills, calcOffence, rundown) as a domain-rules layer and auto-revises recommendations that violate them."
---
<!-- Metadata
argument-hint: '"your research question" [--context=auto|smart|code|docs|minimal|full|none] [--version]'
version: "1.6.5-rd.1"
author: "marckaraujo (project-local fork)"
parent_skill: "r v1.6.5"
tags: ["research", "analysis", "mcp", "context", "orchestration", "pob2", "docs-aware"]
trigger_patterns:
  - "/rd"
  - "research"
  - "analyze"
  - "investigate"
  - "deep analysis"
allowed_tools:
  - "sequential-thinking"
  - "serena"
  - "memory"
  - "brave-search"
  - "tavily-mcp"
  - "context7"
  - "playwright"
  - "git"
  - "gemini"
-->

# Research-with-Docs Skill

Comprehensive research and analysis using unified sequential thinking, MCP tool orchestration, and intelligent project context loading.

## Overview

The `/rd "prompt"` command is a unified research and analysis tool that combines sequential thinking with comprehensive research capabilities and intelligent project context loading. It automatically optimizes complexity level, context discovery, and research tool selection based on your prompt, providing research-backed answers with full source attribution and project-aware insights.

## Quick Start

### Basic Syntax
```
/rd "your research question or analysis request"
/rd --help                                      # Show comprehensive help (if available)
/rd --version                                   # Show skill version
```

### Common Examples
```bash
# Simple research query
/rd "what is TypeScript"

# Code analysis with project context
/rd "how does our UserAuth component handle errors"

# Implementation planning
/rd "add Stripe payment to our form system"

# Architecture analysis
/rd --context=code "analyze our authentication flow"

# General research without project context
/rd --context=none "React performance best practices"
```

## Code Navigation Rules

> **CRITICAL — applies at every step: research, planning, and execution.**
> Every `Agent(Explore)` call creates a child process with no Serena access, defaulting
> to Bash `find`/`grep` and bypassing semantic understanding entirely.

```
❌ FORBIDDEN (always):
   Agent({ subagent_type: "Explore", ... })    ← no Serena access, defaults to find/grep
   Agent({ description: "find ...", ... })      ← same problem
   Bash("grep ...")                             ← raw grep bypasses Serena entirely
   Glob(...)                                    ← file path guessing, not semantic search
   Read(file) without first locating via Serena ← blind full-file reads waste context

✅ REQUIRED order for ANY code investigation:
   1. mcp__serena__activate_project             → ensure project is loaded (once per session)
   2. mcp__serena__get_symbols_overview         → structural overview of a file/dir
   3. mcp__serena__find_symbol                  → locate a specific symbol by name
   4. mcp__serena__search_for_pattern           → regex/text across codebase
   5. mcp__serena__find_referencing_symbols     → all usages of a symbol

   FALLBACK (only if Serena returns empty or is unavailable):
   6. Grep  → raw text search
   7. Glob  → file path search
   8. Read  → full file (last resort — prefer symbol reads via Serena)

   BEFORE every Edit or Write to a code file:
   - Use mcp__serena__find_symbol to confirm the exact symbol location
   - Use mcp__serena__search_for_pattern to verify the edit target exists
   - Only then open Read for the specific symbol body if needed
```

### Output Format
Each response includes:
1. **Direct Answer** - Clear, actionable response
2. **Source Attribution** - Full citations and methodology
3. **Code Examples** - When applicable
4. **Scope Assessment & Execution Plan** - TASK/STORY/EPIC classification with execution routing
5. **Next Steps** - Recommended actions
6. **Knowledge References** - Stored insights for future use

## Configuration Options

### Context Loading Modes
| Mode | Flag | Description | Use Case |
|------|------|-------------|----------|
| Auto | (default) | Automatic context detection | Most queries |
| Smart | `--context=smart` | Aggressive optimization | Power users |
| Code | `--context=code` | Code-focused analysis | Refactoring |
| Docs | `--context=docs` | Documentation-focused | Planning |
| Minimal | `--context=minimal` | Essential info only | Quick queries |
| Full | `--context=full` | Maximum context | Complex analysis |
| None | `--context=none` | No project context | General research |

### Performance Tuning
```bash
# Token control
--tokens=low        # ~500 tokens max
--tokens=medium     # ~1000 tokens max (default)
--tokens=high       # ~2000 tokens max
--tokens=unlimited  # No limit

# Context depth
--context-depth=1   # Direct symbols only
--context-depth=2   # 1-level relationships
--context-depth=3   # 2-level relationships (default)
--context-depth=max # Full traversal

# Cache control
--cache=prefer      # Use cache when available (default)
--cache=refresh     # Force fresh analysis
--cache=disable     # No caching

# Debug mode
--debug            # Show detailed execution flow

# Memory staleness control
--ignore-staleness         # Skip staleness detection
--force-staleness-check    # Force check even with --context=none
--staleness-info          # Show staleness details without warnings
```

### Common Configurations
```bash
# Quick answers with minimal tokens
/rd --context=minimal --tokens=low "what TypeScript version"

# Deep code analysis
/rd --context=code --context-depth=max "analyze auth dependencies"

# Fresh comprehensive analysis
/rd --context=full --cache=refresh "security review"

# Pure external research
/rd --context=none "latest React patterns"

# Quick research without staleness warnings
/rd --ignore-staleness --context=minimal "what TypeScript version"

# Research with staleness info display
/rd --staleness-info "add authentication to our app"
```

## Complexity Levels

The command automatically detects query complexity and adjusts thinking depth:

| Level | Keywords | Use Cases | Thinking Budget |
|-------|----------|-----------|-----------------|
| **Basic** | fix, debug, what is, explain | Simple queries | Moderate thinking |
| **Moderate** | implement, build, create, integrate | Feature development | Enhanced thinking |
| **Advanced** | architecture, optimize, refactor, complex | System design | Deep thinking |
| **Maximum** | migration, security, scalability, algorithm | Major changes | Maximum thinking |

## Quick Troubleshooting

### Common Issues
- **Slow context loading**: Use `--context=smart` or `--tokens=low`
- **Missing symbols**: Try `--cache=refresh` to refresh Serena
- **Poor relevance**: Use explicit mode like `--context=code`
- **High token usage**: Use `--context=minimal` for simple queries
- **MCP server issues**: Restart Claude Code to refresh connections
- **Memory staleness warnings**: Run `/sync --validate` to check accuracy, `/sync` to update

### Debug Commands
```bash
/rd --debug "test query"                    # Show execution details
/rd --context=none "MCP server test"        # Test MCP availability
/rd --ignore-staleness "query"              # Skip staleness check for this query
```

### Memory Staleness Control
```bash
# Skip staleness detection for quick queries
/rd --ignore-staleness "what is TypeScript"

# Force staleness check even for --context=none
/rd --force-staleness-check --context=none "general research"

# Show staleness details without warnings
/rd --staleness-info "query"
```

## Implementation Workflow

> **`--version` flag**: If present, output `rd v{version}` (from this file's frontmatter) and stop.

### Step 1: Enhanced Prompt Analysis
```process
1. Parse the `/rd "prompt"` command
2. Extract core research question and context requirements
3. Analyze keywords for complexity detection (think/think hard/think harder/ultrathink)
4. Analyze keywords for context detection (code/implementation/architecture/general)
5. Determine context loading strategy (Serena/Documentation/Memory combination)
6. Determine initial thinking level and tool selection
```

### Step 2: Lightweight Memory Staleness Check with Cached Results
```memory_quick_check_with_cache
# Fast staleness detection with cached validation display (target: <200ms)
1. Quick timestamp comparison: last sync vs current time
2. Display cached validation results from .claude/temp/last-sync-validation.json:
   
   📋 Previous Memory Validation (2 hours ago):
   ✅ project_overview.md - Up to date
   ΓÜá∩╕Å  tech_stack.md - 2 dependencies outdated  
   ΓÜá∩╕Å  configuration.md - 3 new MCP servers detected
   
   Staleness Score: 6/10 (moderate staleness)
   💡 Recommendations from last check: Run /sync to update 2 files
   
3. Quick file modification scan: basic timestamp check on major files only
4. Calculate simple staleness score: primarily time-based + basic file changes
5. Start background /sync --validate process (non-blocking) for Step 11
6. Continue to Step 3 immediately without waiting
```

**Cached Validation Display System:**
- **Source**: Previous `/sync --validate` results stored in temp file
- **Fallback**: If no cache exists, show "No previous validation available"
- **Performance**: Instant display from cached JSON data
- **Freshness**: Show age of cached results (e.g., "2 hours ago", "1 day ago")
- **Background Update**: Fresh validation runs in parallel for Step 11

**Memory Staleness Warning Examples:**
```
ΓÜá∩╕Å  Memory files may be outdated (last sync: 3 days ago, staleness score: 6/10)
💡 Detected changes: 2 new dependencies, 1 config file modified
💡 Run '/sync --validate' to check accuracy
💡 Run '/sync' to update memories before research for more accurate context

Continue with research anyway? (Y/n)
```

**Critical Staleness Example:**
```
🚨 Memory files critically outdated (last sync: 2 weeks ago, staleness score: 9/10)
📋 Major changes detected:
   • package.json: 8 new dependencies added
   • src/ structure: 3 new directories created  
   • vite.config.ts: Build configuration modified
   • New integration: stripe, i18n implementation

🔄 Strongly recommend running '/sync' before research for accurate results
ΓÅ¡∩╕Å  Continue with potentially outdated context? (y/N)
```


### Step 3: Intelligent Context Loading

> **Code Navigation:** Always use Serena tools first — see [Code Navigation Rules](#code-navigation-rules) above.
> Fallback to Grep/Glob only if Serena returns empty or is unavailable.

```context_loading_workflow
# Context Strategy Selection
IF code_related_context_detected:
    context_strategy = determine_serena_strategy(query_analysis)
    
    # Multi-Layer Context Loading
    LAYER_1_serena_context = execute_serena_discovery(context_strategy)
    LAYER_2_docs_context = load_selective_documentation(context_strategy, serena_findings)  
    LAYER_3_memory_context = retrieve_relevant_memory(query_hash, context_strategy)
    
    # Context Integration
    project_context = merge_contexts(
        primary=serena_context,
        secondary=docs_context, 
        historical=memory_context
    )
ELSE:
    # Minimal or no project context for general research
    project_context = load_minimal_context(query_type)
```

### Step 4: Project Domain Rules Loading

> **Code Navigation:** docs files are plain markdown, not code, so the Serena-first rule does not apply here — load them directly with Read.

```domain_rules_loading
# Inputs:
#   - query_classification (from Step 1)
#   - serena_findings (from Step 3) — symbols and files in scope
#   - query text (for keyword routing)

# ─── Routing matrix ────────────────────────────────────────────
# Trigger signals in query OR Serena findings    → Docs to load
# ───────────────────────────────────────────────────────────────
# ModParser, mod(), flag(), ModType, modFlags,
#   keywordFlags, extraTags, "add a mod",         → modSyntax.md
#   item-affix parsing, jewel radius,             + addingMods.md
#   src/Modules/ModParser.lua, src/Data/Mod*.lua,
#   src/Classes/ModDB.lua/ModList.lua/ModStore.lua
#
# SkillStatMap, src/Data/Skills/, src/Export/     → addingSkills.md
#   Skills/, "add a skill", template directive,   + modSyntax.md
#   #skill, #flags, #mods, #baseMod, #noGem,        (skills also use mod grammar)
#   gem, granted effect
#
# CalcOffence, CalcPerform, CalcDefence, pass,    → calcOffence.md
#   output, globalOutput, combineStat,
#   MainHand, OffHand, "damage pass",
#   any src/Modules/Calc*.lua except
#   CalcFormat/CalcSections/CalcBreakdown
#
# src/Classes/, src/Modules/, "where is",         → rundown.md
#   "file layout", architecture orientation         (headings + matched section body only)
#
# None of the above                               → skip; record routing_reason

LOAD STRATEGY:
  - Read each routed file fully (each < 10 KB; total budget ≤ 36 KB).
  - rundown.md when routed: load section headings + only the section body matched
    by serena_findings/query keywords.

EXTRACT structured rule_set:
  {
    grammars:   [ { source, rule } ],  # closed-set enums and call signatures
    invariants: [ { source, rule } ],  # properties that must hold
    procedures: [ { source, rule } ],  # required ordered steps / mandatory helpers
  }
  # Cite by "<file>§<heading>" so Step 10 can show the source.

OUTPUTS forwarded to Steps 5, 7, 10:
  - rule_set
  - docs_loaded (list of docs/ paths)
  - routing_reason (short string explaining which trigger fired, or "out of scope")
```

#### Worked examples the conformance check (Step 7) must catch

1. **Illegal ModType** — `mod("X", "ADD", ...)` → revise to `"BASE"` (closed set: BASE/INC/MORE/OVERRIDE/FLAG). Source: `modSyntax.md§ModType`.
2. **Edit to generated skill data** — proposed edit to `src/Data/Skills/spell/fireball.lua` → revise to "edit `src/Export/Skills/spell/fireball.lua` and rerun exporter; commit both." Source: `addingSkills.md`.
3. **Pass-local output assignment** — `output.X = ...` inside a damage pass → revise to `globalOutput.X = ...` OR keep in-pass + `combineStat("X", type)` after the loop. Source: `calcOffence.md`.
4. **Hand-rolled jewel radius** — revise to use `getSimpleConv` / `getPerStat` / `getThreshold` or the `function(node, out, data)` form. Source: `addingMods.md`.
5. **Wrong ModParser bucket** — pattern proposed in `formList` that's actually a pre-flag → revise to `preFlagList`. Source: `addingMods.md` scan order.
6. **Missing ModCache regen note** — append "reload PoB with Ctrl+F5 to regenerate src/Data/ModCache.lua and commit the diff." Source: `addingMods.md`.

#### Always-rendered Domain Rule Compliance block (Step 10)

The response template emits this block even when nothing was loaded or revised, so the user can see at a glance whether the rules layer engaged:

```
### Domain Rule Compliance
- **Docs consulted:** {list of docs/ files, or `none — {routing_reason}`}
- **Auto-revisions applied:** {numbered revisions list, or `none`}
```

### Step 5: Context-Aware Sequential Thinking Orchestration
```thinking_workflow
1. Initialize sequential thinking with:
   - Detected complexity level
   - Rich project context (if applicable)
   - Context-informed research strategy
2. Use thinking process to:
   - Break down research question with project context awareness
   - Identify information gaps considering current codebase state
   - Plan research strategy leveraging both project context and external sources
   - Guide dynamic tool activation based on context findings and research needs
```

### Step 6: Context-Enhanced Research Execution
```context_enhanced_research
# Research tools are triggered by sequential thinking process with context awareness
# Context from Step 3 is now available for all research activities

if (technology_question):
    tools = [BraveSearch, Tavily, Context7]
    # Context enhancement: If project uses specific tech, prioritize project-specific research
    if project_context_available:
        research_parameters.add_context_filter(project_tech_stack)
        
elif (implementation_query_with_context):
    # Context-informed implementation research
    tools = [Serena(primary), BraveSearch, Tavily, Memory]
    research_parameters = merge_contexts(
        code_context=serena_findings,
        external_research=implementation_patterns,
        project_constraints=documentation_context
    )
    
elif (architecture_query_with_context):
    # Architecture research enhanced with current project state
    tools = [Serena(structure_analysis), BraveSearch, Tavily, Memory]
    research_parameters = combine_contexts(
        current_architecture=serena_structure_analysis,
        architecture_patterns=external_research,
        documented_decisions=architecture_docs
    )
    
elif (codebase_modification_query):
    # Code modification with full context awareness
    tools = [Serena(primary), Memory, Task]
    research_parameters = integrate_contexts(
        target_code=serena_symbol_analysis,
        dependencies=serena_relationship_mapping,
        project_standards=code_style_docs,
        previous_patterns=memory_similar_changes
    )
    
elif (general_research_query):
    # Standard research with minimal context
    tools = [BraveSearch, Tavily]
    # Optional: Add minimal project context for relevance filtering
    if minimal_context_beneficial:
        research_parameters.add_relevance_filter(project_domain)

# Execute context-enhanced research
for tool in tools:
    enhanced_research_result = execute_research(
        tool=tool, 
        parameters=research_parameters,
        context=project_context  # Available from Step 3
    )
```

### Step 7: Context-Informed Knowledge Synthesis
```synthesis
1. Combine findings from all research tools with project context awareness
2. Validate information sources and quality (external + project context sources)
3. Identify relationships and patterns between external research and project state
4. Reconcile external recommendations with project constraints and existing patterns
5. Generate coherent, actionable recommendations that fit project architecture
6. Prepare comprehensive source attribution (external sources + Serena findings + documentation)
7. Ensure recommendations align with project standards and existing implementations
8. Run rule_set conformance check against the synthesized recommendation R:
   FOR rule IN rule_set.grammars ∪ rule_set.invariants ∪ rule_set.procedures:
       IF R violates rule:
           R_new = revise(R, rule)
           revisions.append({original, revised, rule, source})
           R = R_new
   Re-run the loop until a full pass yields no further revisions.
   Carry `revisions` forward to Step 10 (Response Delivery).
```

### Step 8: Enhanced Memory Integration
```memory_operations
1. Store valuable insights in Knowledge Graph with project context
2. Create entity relationships between concepts and project-specific elements
3. Link to source materials, timestamps, and context strategies used
4. Cache successful context loading patterns for future optimization
5. Update project knowledge base with new architectural insights
```

### Step 9: Scrum-Based Task Sizing and Execution Planning
```scope_sizing_and_execution
# Evaluate research findings from Steps 1-8 to determine work scope
# Classify as EPIC / STORY / TASK and route to appropriate execution flow

# ═══════════════════════════════════════════════════════════════
# PART A: Scope Classification
# ═══════════════════════════════════════════════════════════════

# Pragmatic Scrum Sizing Criteria
TASK_CRITERIA:
  - Single-file or single-function change
  - No new dependencies or integrations
  - Can be completed in one focused session (< 30 min)
  - No cross-cutting concerns or architectural impact
  - Examples: fix a bug, add a field, update a config, rename a variable,
    write a unit test, update documentation

STORY_CRITERIA:
  - Multiple related files or one new module/component
  - May introduce a dependency or minor integration
  - Requires 2-6 discrete implementation steps
  - Contained within a single domain or feature area
  - Examples: add a new API endpoint with validation, implement a UI form
    with state management, add authentication to an existing route,
    create a new utility module with tests

EPIC_CRITERIA:
  - Spans multiple modules, services, or architectural layers
  - Introduces new system capabilities or cross-cutting concerns
  - Requires 3+ stories to deliver, each with multiple tasks
  - May affect project structure, build pipeline, or deployment
  - Examples: add a payment system, implement i18n across the app,
    migrate from REST to GraphQL, add real-time features with WebSockets,
    redesign the authentication architecture

# ═══════════════════════════════════════════════════════════════
# PART B: Classification Algorithm
# ═══════════════════════════════════════════════════════════════

1. Gather sizing signals from research context (Steps 3, 5-8):
   - files_affected = count of files identified by Serena context discovery
   - new_dependencies = external libraries or services not yet in project
   - cross_cutting = touches auth, logging, error handling, or shared utils
   - architectural_change = new patterns, structural changes, new directories
   - estimated_steps = discrete implementation actions identified in synthesis

2. Apply classification decision tree:

   IF estimated_steps <= 3
      AND files_affected <= 2
      AND new_dependencies == 0
      AND cross_cutting == false
      AND architectural_change == false:
       → classification = TASK

   ELIF estimated_steps <= 8
      AND files_affected <= 8
      AND architectural_change == false:
       → classification = STORY

   ELSE:
       → classification = EPIC

3. Present classification to user:

   📐 Scope Assessment: [TASK | STORY | EPIC]
   ├── Files affected: {files_affected}
   ├── New dependencies: {new_dependencies}
   ├── Implementation steps: {estimated_steps}
   ├── Cross-cutting concerns: {yes/no}
   └── Architectural impact: {none/minor/significant}

# ═══════════════════════════════════════════════════════════════
# PART C: TASK Flow (Direct Execution)
# ═══════════════════════════════════════════════════════════════

IF classification == TASK:
    1. Present concise execution plan:

       📋 Execution Plan (TASK)
       1. {step_1_description}
       2. {step_2_description}
       3. {step_3_description}
       
       Proceed? (Y/n)

    2. On approval → execute all steps sequentially
    3. Skip temp PRD generation (unnecessary overhead for tasks)
    4. Proceed directly to Step 10 (Context-Aware Response Delivery)

# ═══════════════════════════════════════════════════════════════
# PART D: STORY / EPIC Flow (Structured PRD Generation)
# ═══════════════════════════════════════════════════════════════

IF classification == STORY OR classification == EPIC:

    # D.1: Generate Temp PRD File
    temp_prd_path = ".claude/temp/prd-{timestamp}-{slug}.md"
    # Naming: prd-20260331-add-payment-system.md
    # Slug: lowercase, hyphens, derived from research query (max 40 chars)
    # Ensure .claude/temp/ directory exists (create if needed)

    # D.2: Temp PRD File Format
    """
    # PRD: {title_from_research_query}

    **Generated**: {ISO_timestamp}
    **Classification**: {STORY | EPIC}
    **Source Query**: {original_user_prompt}
    **Status**: IN_PROGRESS

    ## Summary

    {1-2 paragraph synthesis from Steps 5-7 research findings}

    ## Scope

    - **Files affected**: {list}
    - **New dependencies**: {list or "None"}
    - **Architectural impact**: {description or "None"}

    ## Stories
    <!-- For STORY classification: single story with tasks -->
    <!-- For EPIC classification: multiple stories, each with tasks -->

    ### S-001: {story_title}
    **Status**: ⬜ PENDING
    **Description**: As a {role}, I want {goal} so that {benefit}.

    | ID | Task | Status | Notes |
    |----|------|--------|-------|
    | S-001.1 | {task_description} | ⬜ PENDING | |
    | S-001.2 | {task_description} | ⬜ PENDING | |
    | S-001.3 | {task_description} | ⬜ PENDING | |

    ### S-002: {story_title}  (EPIC only — multiple stories)
    **Status**: ⬜ PENDING
    **Description**: As a {role}, I want {goal} so that {benefit}.

    | ID | Task | Status | Notes |
    |----|------|--------|-------|
    | S-002.1 | {task_description} | ⬜ PENDING | |
    | S-002.2 | {task_description} | ⬜ PENDING | |

    ## Execution Log

    | Timestamp | Action | Details |
    |-----------|--------|---------|
    | {ISO_timestamp} | PRD_CREATED | Initial generation from /rd research |
    """

    # D.3: Status Icons for Tracking
    # ⬜ PENDING      — Not started
    # 🔄 IN_PROGRESS  — Currently executing
    # ✅ DONE         — Completed successfully
    # ΓÅ¡∩╕Å DEFERRED     — Postponed by user
    # ❌ CANCELLED    — Removed by user
    # 🚫 BLOCKED      — Waiting on dependency

    # D.4: Present PRD Summary to User
    Display:
       📐 Classification: {STORY | EPIC}
       📄 PRD created: {temp_prd_path}
       
       {For STORY: 1 story, N tasks}
       {For EPIC: N stories, M total tasks}
       
       ### Execution Order:
       1. S-001: {story_title} ({N} tasks)
          └─ S-001.1: {first_task}
          └─ S-001.2: {second_task}
       2. S-002: {story_title} ({N} tasks)  (if EPIC)
          └─ ...
       
       Execute step by step? (Y/n/edit)
       # "edit" allows user to modify the PRD before execution

    # D.5: Step-by-Step Execution with Tracking
    #
    # PERFORMANCE RULES:
    # 1. CONTEXT REUSE: Carry forward context from Steps 1-8. Do NOT
    #    re-run context loading, staleness checks, or sequential thinking
    #    for each task. The research phase is already complete.
    # 2. BATCH PRD UPDATES: Update the temp PRD file ONCE per story
    #    (not per task). Accumulate task statuses in memory and flush
    #    all changes in a single write at story completion.
    # 3. LIGHTWEIGHT EXECUTION: Each task should use direct tool calls
    #    (Read, Edit, Write, Bash) against the already-loaded context.
    #    Do NOT invoke MCP research tools (Brave, Tavily, Serena) unless
    #    a task explicitly requires new external information.
    # 4. MINIMAL DISPLAY: Show one-line progress per task, not full
    #    response formatting. Save detailed output for the final summary.
    # 5. SKIP STEPS 10-11 DURING EXECUTION: Response delivery and
    #    documentation updates happen ONLY after all stories complete,
    #    not after each task or story.

    ON user_approval:
        # ── Display full task checklist before execution begins ──
        # This gives the user a clear view of everything that will run.
        Display:
            📋 Execution Checklist:
            
            ### S-001: {story_title}
            ⬜ S-001.1 — {task_description}
            ⬜ S-001.2 — {task_description}
            ⬜ S-001.3 — {task_description}
            
            ### S-002: {story_title}  (if EPIC)
            ⬜ S-002.1 — {task_description}
            ⬜ S-002.2 — {task_description}
            
            ─────────────────────────────
            Total: {N} stories, {M} tasks
            Starting execution...

        # Cache context once for entire execution
        execution_context = context_from_steps_1_through_8  # Already available
        completed_tasks = []
        execution_log_buffer = []

        FOR each story IN stories_ordered_by_dependency:
            # In-memory status tracking (no file write yet)
            story.status = 🔄 IN_PROGRESS
            
            FOR each task IN story.tasks:
                task.status = 🔄 IN_PROGRESS
                
                # Execute using lightweight mode:
                # - Use execution_context (no re-loading)
                # - Direct tool calls only (Read, Edit, Write, Bash)
                # - Skip MCP research tools unless task needs new info
                execute_task(task, context=execution_context, mode="lightweight")
                
                # Buffer results (no file write yet)
                task.status = ✅ DONE
                completed_tasks.append(task)
                execution_log_buffer.append(
                    {timestamp, "TASK_DONE", f"{task.id}: {task.description}"}
                )
                
                # One-line progress with running checklist update
                Display: ✅ {task.id} — {task.description} ({completed}/{total})
                # The checklist above visually updates:
                #   ✅ S-001.1 — {done task}
                #   🔄 S-001.2 — {current task}
                #   ⬜ S-001.3 — {pending task}
                
                # Pause ONLY on errors or required user input
                IF task_had_errors OR task_needs_user_input:
                    Pause and present options:
                    - Continue to next task
                    - Retry this task
                    - Skip (mark as DEFERRED)
                    - Abort remaining execution
            
            # BATCH WRITE: Flush all task statuses + story completion in ONE write
            story.status = ✅ DONE
            execution_log_buffer.append(
                {timestamp, "STORY_DONE", f"{story.id}: {story.title}"}
            )
            batch_update_prd(temp_prd_path, story, completed_tasks, execution_log_buffer)
            completed_tasks = []  # Reset for next story
            execution_log_buffer = []

    # D.6: Completion Summary
    ON all_stories_complete OR user_abort:
        Update PRD Status → COMPLETED (or PARTIAL)  # Single final write
        
        Display final summary:
            📊 Execution Summary ({temp_prd_path})
            ├── Stories: {done}/{total} completed
            ├── Tasks:   {done}/{total} completed  
            ├── Deferred: {count} (if any)
            └── Status: {COMPLETED | PARTIAL}
        
        # NOW proceed to Steps 10-11 for response delivery + doc updates
        # Temp PRD remains in .claude/temp/ for reference

# ═══════════════════════════════════════════════════════════════
# PART E: Integration Notes
# ═══════════════════════════════════════════════════════════════

# Receives from Step 8 (Enhanced Memory Integration):
#   - Synthesized research findings with source attribution
#   - Project context from Serena (files, symbols, relationships)
#   - Stored knowledge graph entities and relationships
#   - Cached context loading patterns

# Feeds into Step 10 (Context-Aware Response Delivery):
#   - For TASK: execution results + research answer
#   - For STORY/EPIC: execution summary + PRD location + research answer
#   - Step 10 formats the final response with all source attribution

# Task Master Alignment:
#   - Story IDs (S-001) align with PRD template US-001 pattern
#   - Task IDs (S-001.1) align with Task Master hierarchical format (1.1)
#   - Status values map to Task Master statuses:
#       PENDING → pending, IN_PROGRESS → in-progress, DONE → done,
#       DEFERRED → deferred, CANCELLED → cancelled, BLOCKED → blocked
#   - If Task Master is active in the project, optionally sync:
#       task-master add-task for each story/task in the PRD
```

### Step 10: Context-Aware Response Delivery
```response_format
# ROUTING: Haiku sub-agent — pure template formatting, no tools or session state required.

Spawn Agent({
  model: "haiku",
  prompt: """
You are a research response formatter. Fill the template below using the provided context.
Return ONLY the formatted markdown response — no preamble, no commentary.
Your VERY FIRST LINE must be exactly: `<!-- step10:haiku -->` (this confirms the sub-agent ran).

=== RESPONSE FORMAT TEMPLATE ===
{full contents of templates/response-format.md}

=== CONTEXT ===
CLASSIFICATION: {TASK | STORY | EPIC}
DIRECT_ANSWER: {synthesis direct_answer from Step 7}
KEY_FINDINGS: {synthesis key_findings from Step 7}
CODE_EXAMPLES: {synthesis code_examples from Step 7}
SOURCE_ATTRIBUTION: {synthesis source_attribution from Step 7 — external sources, Serena findings, docs used}
RESEARCH_TOOLS_USED: {list of MCP tools activated in Steps 3, 5, 6}
CONTEXT_STRATEGY: {context mode used}
COMPLEXITY_LEVEL: {basic|moderate|advanced|maximum}
SCOPE_SIGNALS: {files_affected, new_dependencies, estimated_steps, cross_cutting, architectural_change from Step 7}
EXECUTION_SUMMARY: {Step 9 checklist/execution results — only if STORY or EPIC, otherwise "N/A"}
PRD_PATH: {temp PRD file path — only if STORY or EPIC, otherwise "N/A"}
NEXT_STEPS: {recommended next actions from synthesis}
KNOWLEDGE_STORED: {list of entities and relationships written to memory in Step 8}
DOCS_CONSULTED: {list of docs/ files loaded in Step 4, or "none — {routing_reason}"}
AUTO_REVISIONS: {revisions list from Step 7, or "none"}
  """,
  description: "Format final research response using Haiku"
})

# Fallback: if sub-agent output is empty or malformed, execute inline:
# 1. Present direct answer informed by project context and external research
# 2. Include full source attribution (external sources + project context sources)
# 3. Provide relevant code examples that align with project patterns and standards
# 4. Suggest next steps considering current project state and capabilities
# 5. Reference stored knowledge for future use and context continuity
```

### Step 11: Project Documentation Update with Fresh Memory Validation
```project_documentation_update_with_validation
# Primary: Research results and documentation updates
# Secondary: Present fresh memory validation results from background process

PART A: Research Results (Primary Response)
1. Deliver comprehensive research results with source attribution
2. Provide code examples and implementation guidance  
3. Include next steps and actionable recommendations

PART B: Fresh Memory Validation Results (Secondary Display)
4. Present background /sync --validate results (started in Step 2):
   
   🔄 Fresh Memory Analysis (just completed):
   Changes since last check:
   ✅ tech_stack.md: Now up to date (dependencies resolved)
   ΓÜá∩╕Å  configuration.md: Still needs sync (3 MCP servers added)
   ΓÜá∩╕Å  project_structure.md: New changes detected (assets/ directory added)
   
   📊 Updated Staleness Score: 4/10 (improved from 6/10)
   
   💡 Updated Recommendations:
   - Run '/sync' to update configuration.md and project_structure.md
   - Memory accuracy improved since last validation
   - Next research queries will be more accurate

PART C: Project Documentation Updates (If Research Recommends Changes)
5. Detect if research recommendations affect fundamental project aspects
6. Map discoveries to appropriate memory files:
   - Tech Stack changes → .serena/memories/tech_stack.md
   - New integrations → .serena/memories/integrations.md
   - Architecture patterns → .serena/memories/architecture.md
   - Development commands → .serena/memories/development.md
   - Configuration changes → .serena/memories/configuration.md
   - Structure changes → .serena/memories/project_structure.md
   - Code style updates → .serena/memories/code_style.md
   - Project scope changes → .serena/memories/project_overview.md

3. For each affected memory file:
   - Read current content from .serena/memories/[file].md
   - Identify the relevant section to update
   - Merge new discoveries with existing content
   - Preserve all existing information while adding new insights
   - Write updated content back to the file

4. Verification:
   - Ensure all memory files remain valid Markdown
   - Verify CLAUDE.md imports are still correct
   - Confirm no duplicate information added

5. Memory persistence:
   - Store update patterns for future optimization
   - Cache successful documentation updates
   - Mark task complete only after all updates successful

Example update scenarios:
- New library discovered (React Query 5.0) → Update tech_stack.md
- New API integration (Stripe) → Update integrations.md
- New build command found → Update development.md
- Architecture pattern identified → Update architecture.md
```

#### Documentation Update Mapping

| Discovery Type | Target File | Section to Update |
|---------------|-------------|-------------------|
| Framework version | tech_stack.md | Application Framework |
| Library addition | tech_stack.md | Dependencies/Libraries |
| External service | integrations.md | Third-Party Services |
| API endpoint | integrations.md | API & Communication |
| Build tool | development.md | Build & Development Tools |
| Script command | development.md | Core Commands |
| Design pattern | architecture.md | Application Patterns |
| File structure | project_structure.md | Directory Structure |
| Config file | configuration.md | Configuration Files |
| Code convention | code_style.md | Coding Standards |

#### Example: Updating tech_stack.md when new framework version discovered

```update_workflow
# When /rd discovers "Project using React 18.3.0 with TypeScript 5.4"
1. Read .serena/memories/tech_stack.md
2. Find "## Application Framework" section
3. Update version numbers:
   - React 18.2.0 → React 18.3.0
   - TypeScript 5.0 → TypeScript 5.4
4. Add any new features discovered:
   - "- Server Components support enabled"
   - "- Strict type checking configured"
5. Write updated content back to tech_stack.md
6. Log update: "Updated React to 18.3.0, TypeScript to 5.4 in tech_stack.md"
```

## Enhanced Context Detection Algorithm

The command automatically analyzes your prompt for project context needs and activates appropriate context loading strategies:

### Code-Related Context Triggers (Activates Serena Context Loading)

- **Component/Function References**
  - **Triggers**: Specific component names, function references, class mentions
  - **Examples**: "UserAuth component", "calculateTotal function", "NavBar implementation"
  - **Context Strategy**: Serena symbol discovery + relationship mapping

- **Architecture Questions about Existing Code**
  - **Triggers**: "our current", "existing", "current setup", "how does our"
  - **Examples**: "how does our routing work", "extend our current auth flow"
  - **Context Strategy**: Serena structure analysis + documentation context

- **Extension/Modification Queries**
  - **Triggers**: "add to our", "modify our", "extend our", "integrate with our"
  - **Examples**: "add notifications to our form system", "modify our API calls"
  - **Context Strategy**: Serena discovery of existing patterns + integration docs

- **File/Path References**
  - **Triggers**: Direct file paths, directory mentions, config file references
  - **Examples**: "src/components/auth", "package.json scripts", "vite.config.ts"
  - **Context Strategy**: Targeted Serena analysis + related symbol discovery

### Documentation Context Triggers (Selective Documentation Loading)

- **Implementation Planning**
  - **Triggers**: "implement", "build", "create", "develop", "design"
  - **Examples**: "implement dark mode", "build user dashboard", "create API endpoint"
  - **Context Strategy**: Tech stack + architecture + development patterns

- **Integration Questions**
  - **Triggers**: "integrate", "connect", "setup", "configure", "deploy"
  - **Examples**: "integrate with Stripe", "setup authentication", "configure deployment"
  - **Context Strategy**: Integrations + configuration + tech stack context

- **Optimization Queries**
  - **Triggers**: "optimize", "performance", "improve", "enhance", "scale"
  - **Examples**: "optimize React components", "improve build performance"
  - **Context Strategy**: Architecture + tech stack + development best practices

### General Research Triggers (Minimal/No Project Context)

- **Knowledge Questions**
  - **Triggers**: "what is", "explain", "definition", "comparison", "difference"
  - **Examples**: "what is TypeScript", "explain React hooks", "difference between REST and GraphQL"
  - **Context Strategy**: No project context (external research only)

- **Best Practices**
  - **Triggers**: "best practices", "should I", "recommended", "standard approach"
  - **Examples**: "best practices for API design", "should I use Next.js"
  - **Context Strategy**: Minimal context for relevance filtering only

### Research Tool Selection Logic

Based on prompt characteristics, the command automatically activates relevant research tools:

**Tool Selection Matrix:**

1. **Technology Questions**
   - **Triggers**: Technology names, framework mentions, library references
   - **Tools**: Brave Search + Tavily + Context7 (if library-specific)
   - **Purpose**: Current best practices, documentation, compatibility

2. **"How to" Queries**
   - **Triggers**: "how to", "best practices", "step by step", "guide"
   - **Tools**: Tavily (primary) + Brave Search
   - **Purpose**: Specialized insights, tutorials, implementation guides

3. **Codebase References**
   - **Triggers**: File paths, component names, existing project mentions
   - **Tools**: Serena (primary) + Memory + Sequential thinking
   - **Purpose**: Local code exploration, pattern analysis, context gathering

4. **Architecture & Design**
   - **Triggers**: "architecture", "design pattern", "structure", "approach"
   - **Tools**: Tavily + Brave Search + Memory (for storing insights)
   - **Purpose**: Design patterns, architectural guidance, trade-off analysis

5. **Performance & Optimization**
   - **Triggers**: "performance", "optimize", "speed", "memory", "scalability"
   - **Tools**: Brave Search + Tavily + Memory
   - **Purpose**: Performance benchmarks, optimization techniques, best practices

6. **Security & Compliance**
   - **Triggers**: "security", "authentication", "authorization", "compliance"
   - **Tools**: Tavily (primary) + Brave Search
   - **Purpose**: Security patterns, vulnerability analysis, compliance guidelines

7. **Code Intelligence & Navigation**
   - **Triggers**: "symbol", "class", "function", "method", "navigate", "understand code", "code structure", "find usage", "references"
   - **Tools**: Serena (primary) + Memory + Sequential thinking
   - **Purpose**: 
     - Semantic code navigation - Navigate by meaning, not just text
     - Symbol-based operations - Find and edit classes, functions, variables intelligently
     - Code relationships - Understand connections between code components
     - Memory persistence - Access stored project knowledge anytime
     - Intelligent editing - Precise code modifications using symbolic tools
   - **When NOT to use Serena**:
     - Single-file tasks where reading/editing the entire file is sufficient
     - Creating code from scratch (no existing structure to navigate)
     - Tasks that don't require understanding relationships across files
   - **When to use Serena**:
     - Multi-file navigation and understanding
     - Finding references and relationships across the codebase
     - Symbolic operations on existing code structures
     - Understanding complex code architectures

## Serena Context Discovery Integration

When code-related context is detected, Serena provides intelligent context loading through its semantic code analysis capabilities:

### Core Serena Tools for Context Loading

- **`get_symbols_overview`**: High-level project structure analysis
  - **Purpose**: Understand file organization, main components, and architectural patterns
  - **Use Case**: Get project layout when answering "how is our project structured"
  - **Token Efficiency**: Provides structural overview without loading full file contents

- **`find_symbol`**: Precise symbol location and definition discovery
  - **Purpose**: Find specific classes, functions, components, or variables by name
  - **Use Case**: Locate "UserAuth" component when query mentions authentication
  - **Token Efficiency**: Returns exact symbol definitions with minimal surrounding context

- **`find_referencing_symbols`**: Code relationship and dependency mapping
  - **Purpose**: Discover how code components interact and depend on each other
  - **Use Case**: Understand impact when modifying existing functionality
  - **Token Efficiency**: Shows relevant relationships without loading entire dependency trees

- **`search_for_pattern`**: Intelligent pattern discovery across codebase
  - **Purpose**: Find code patterns, similar implementations, or usage examples
  - **Use Case**: Discover existing authentication patterns when implementing new auth features
  - **Token Efficiency**: Returns matching patterns with contextual boundaries

- **`read_memory`/`write_memory`**: Persistent project knowledge storage
  - **Purpose**: Store and retrieve architectural insights and code relationships
  - **Use Case**: Remember previous analysis for faster future context loading
  - **Token Efficiency**: Avoid re-analyzing unchanged code structures

### Serena Context Discovery Workflow

```context_discovery_workflow
# Step 1: Query Analysis and Context Strategy Selection
IF query_contains_code_references:
    context_strategy = determine_serena_strategy(query_analysis)
    
# Step 2: Serena Context Discovery Based on Strategy
SWITCH context_strategy:
    CASE "symbol_lookup":
        # Direct symbol or component references
        relevant_symbols = find_symbol(extracted_entities)
        context = symbol_definitions + immediate_dependencies
        
    CASE "architecture_analysis":  
        # Questions about project structure or existing patterns
        project_overview = get_symbols_overview(relevant_directories)
        related_patterns = search_for_pattern(architecture_keywords)
        context = project_overview + related_patterns + architecture_docs
        
    CASE "relationship_mapping":
        # Queries about extending or modifying existing functionality
        target_symbols = find_symbol(modification_targets)
        dependencies = find_referencing_symbols(target_symbols)
        context = target_symbols + dependencies + integration_docs
        
    CASE "pattern_discovery":
        # Implementation queries that should follow existing patterns
        existing_patterns = search_for_pattern(implementation_keywords)
        similar_implementations = find_referencing_symbols(pattern_symbols)
        context = existing_patterns + similar_implementations + tech_stack_docs

# Step 3: Documentation Context Enhancement
IF context_strategy_requires_docs:
    relevant_docs = load_selective_documentation(doc_triggers)
    enhanced_context = merge_contexts(serena_context, relevant_docs)
ELSE:
    enhanced_context = serena_context

# Step 5: Memory Integration and Caching
write_memory(context_analysis_results)  # For future query optimization
cached_context = enhanced_context
```

### Context Strategy Selection Examples

**Symbol Lookup Strategy:**
```
Query: "/rd how does the UserAuth component handle login errors"
Serena Actions:
1. find_symbol("UserAuth") → UserAuth component definition
2. find_referencing_symbols("UserAuth") → Components that use UserAuth  
3. search_for_pattern("login.*error|error.*login") → Error handling patterns
Context Result: UserAuth implementation + error handling logic + usage examples
```

**Architecture Analysis Strategy:**
```
Query: "/rd how is our routing structured and where should I add the new dashboard route"
Serena Actions:
1. get_symbols_overview("src/") → Project structure overview
2. search_for_pattern("route|Route|router") → Routing implementation patterns
3. find_symbol("App|Router|routes") → Main routing configuration
Context Result: Routing architecture + route definitions + navigation patterns
```

**Relationship Mapping Strategy:**
```
Query: "/rd add email notifications to our existing form submission process"
Serena Actions:
1. search_for_pattern("form.*submit|submit.*form") → Form submission patterns
2. find_referencing_symbols("form_components") → Form dependencies
3. search_for_pattern("email|notification") → Existing email/notification code
Context Result: Form submission flow + existing notification patterns + integration points
```

## Multi-Layer Context Strategy

The `/rd` command employs a sophisticated multi-layer context loading approach that combines Serena's code intelligence with documentation context and persistent memory for maximum accuracy and efficiency:

### Layer Architecture

**Layer 1: Serena Code Intelligence (Primary Context)**
- **Purpose**: Semantic understanding of actual codebase structure and relationships
- **Scope**: Symbol-level analysis, code dependencies, implementation patterns
- **Token Efficiency**: Precise, relevant code context without entire file loading
- **Dynamic**: Real-time analysis of current codebase state

**Layer 2: Documentation Context (Complementary Context)**
- **Purpose**: Project constraints, architecture decisions, development guidelines
- **Scope**: CLAUDE.md + .serena/memories/*.md files (selective loading)
- **Token Efficiency**: Load only relevant documentation sections based on query type
- **Static**: Captured project knowledge and standards

**Layer 3: Memory Context (Persistent Context)**
- **Purpose**: Historical insights, cached analysis results, learned patterns
- **Scope**: Previous Serena discoveries, architectural insights, recurring patterns
- **Token Efficiency**: Avoid re-analyzing unchanged code structures
- **Cumulative**: Builds project knowledge over time

### Context Layer Integration Matrix

| Query Type | Serena Layer | Documentation Layer | Memory Layer | Integration Strategy |
|------------|--------------|-------------------|--------------|----------------------|
| **Code Analysis** | Primary | Minimal | Cached Results | Serena discoveries + relevant standards |
| **Implementation** | Primary | Architecture + Tech Stack | Patterns + Previous Solutions | Code patterns + project constraints + learned approaches |
| **Architecture** | Structure Analysis | Architecture + Integration Docs | Architectural Decisions | Current structure + documented decisions + historical insights |
| **Optimization** | Performance Patterns | Tech Stack + Development | Previous Optimizations | Current bottlenecks + tech constraints + proven optimizations |
| **Integration** | Existing Integrations | Integration + Configuration | Integration Patterns | Current APIs + integration docs + successful patterns |

### Smart Context Merging Algorithm

```context_merging_algorithm
# Step 1: Primary Context Discovery
primary_context = serena_context_discovery(query, context_strategy)

# Step 2: Documentation Context Selection
IF query_requires_constraints_or_standards:
    relevant_docs = select_documentation_context(query_type, serena_findings)
    # Select docs based on what Serena discovered
    IF serena_found_auth_components:
        load_docs = ["integrations.md", "code_style.md"]  
    IF serena_found_routing_patterns:
        load_docs = ["architecture.md", "tech_stack.md"]
ELSE:
    relevant_docs = minimal_project_overview()

# Step 3: Memory Context Retrieval
historical_context = read_memory(query_context_hash)
IF historical_context_exists AND still_relevant:
    memory_context = historical_context
ELSE:
    memory_context = empty()

# Step 5: Intelligent Context Fusion
fused_context = merge_contexts(
    primary_context=primary_context,           # Highest priority
    documentation_context=relevant_docs,       # Constraint/standards overlay
    memory_context=memory_context,            # Historical insights
    fusion_strategy="relevance_weighted"
)

# Step 6: Context Quality Optimization
optimized_context = optimize_context_boundaries(
    context=fused_context,
    token_budget=calculate_token_budget(query_complexity),
    relevance_threshold=determine_relevance_threshold(query_type)
)

RETURN optimized_context
```

### Context Layer Benefits

**Enhanced Accuracy:**
```benefits
✅ Serena provides actual code structure (not assumptions)
✅ Documentation provides project-specific constraints
✅ Memory prevents redundant analysis and captures insights
✅ Multi-layer validation ensures consistency
```

**Token Efficiency:**
```efficiency
✅ Serena: Precise symbol context vs entire file loading
✅ Documentation: Selective loading based on Serena findings
✅ Memory: Cached results avoid re-analysis
✅ Smart merging: Eliminate redundant or conflicting information
```

**Context Quality:**
```quality
✅ Real-time code state (Serena) + documented standards (Docs) + learned patterns (Memory)
✅ Symbol-level precision with architectural context
✅ Historical continuity across multiple queries
✅ Adaptive learning from successful context strategies
```

### Context Loading Decision Tree

```decision_tree
Query Analysis:
├── Code-heavy query detected
│   ├── Activate Serena (Primary)
│   ├── Load relevant docs (Secondary)
│   └── Check memory for cached analysis
├── Implementation query detected
│   ├── Activate Serena for existing patterns
│   ├── Load architecture + tech stack docs
│   └── Retrieve similar implementation memory
├── Architecture query detected
│   ├── Activate Serena for structure analysis
│   ├── Load architecture + integration docs  
│   └── Retrieve architectural decision memory
└── General research query detected
    ├── Skip Serena (no code context needed)
    ├── Minimal project context (if any)
    └── Focus on external research tools
```

### Context Persistence and Learning

```context_learning
# After successful query resolution:
write_memory(
    query_pattern=query_classification,
    context_strategy=used_context_strategy, 
    serena_discoveries=code_analysis_results,
    documentation_relevance=doc_selection_effectiveness,
    resolution_quality=user_feedback_implied
)

# Future query optimization:
IF similar_query_detected:
    optimized_context = apply_learned_context_strategy(
        previous_successful_pattern,
        current_query_specifics
    )
```

This multi-layer approach ensures that the `/rd` command has comprehensive understanding of both the current codebase state (Serena), project constraints and standards (Documentation), and accumulated insights (Memory), while maintaining optimal token efficiency through intelligent context selection and merging.

## Configuration Options & Context Control

The `/rd` command provides flexible configuration options to control context loading behavior, allowing users to optimize for different use cases and preferences:

### Context Loading Modes

**Syntax with Context Control:**
```
/rd "your research question"                    # Auto-detection (default)
/rd --context=smart "your research question"    # Intelligent context loading
/rd --context=code "your research question"     # Code-focused context only
/rd --context=docs "your research question"     # Documentation-focused context  
/rd --context=minimal "your research question"  # Minimal context loading
/rd --context=full "your research question"     # Maximum context loading
/rd --context=none "your research question"     # No project context
```

**Context Mode Details:**

**Auto-Detection Mode (Default)**
```
Behavior: Automatic context strategy selection based on query analysis
Context Loading: 
- Code queries → Serena + relevant documentation
- Implementation queries → Serena + architecture + tech stack docs
- General queries → Minimal or no project context
Performance: Optimized token usage with intelligent relevance filtering
Use Case: Best for most users, provides optimal balance
```

**Smart Mode (--context=smart)**  
```
Behavior: Enhanced auto-detection with aggressive optimization
Context Loading:
- Multi-layer context with advanced relevance scoring
- Predictive context loading based on query patterns
- Dynamic context expansion if initial context insufficient
Performance: Highest token efficiency with maximum context quality
Use Case: Power users who want optimal context with minimal tokens
```

**Code-Focused Mode (--context=code)**
```
Behavior: Prioritizes Serena code intelligence, minimal documentation
Context Loading:
- Primary: Serena symbol discovery and relationship mapping
- Secondary: Code-related documentation sections only
- Memory: Code pattern and architectural decision history
Performance: Moderate token usage, high code context precision
Use Case: Deep code analysis, refactoring, and architectural queries
```

**Documentation-Focused Mode (--context=docs)**
```
Behavior: Prioritizes documentation context, minimal code analysis
Context Loading:
- Primary: Comprehensive documentation loading (.serena/memories/*, CLAUDE.md)
- Secondary: High-level Serena project structure only
- Memory: Documentation updates and decision history
Performance: Moderate token usage, comprehensive project knowledge
Use Case: Requirements analysis, project planning, documentation queries
```

**Minimal Context Mode (--context=minimal)**
```
Behavior: Load only essential project information
Context Loading:
- Core project overview (project_overview.md only)
- Basic tech stack information
- No code analysis or comprehensive documentation
Performance: Low token usage, fast response times
Use Case: Quick questions, general research with project relevance filter
```

**Full Context Mode (--context=full)**
```
Behavior: Load comprehensive context regardless of query type
Context Loading:
- Complete Serena analysis of relevant project areas
- All relevant documentation sections
- Comprehensive memory integration
Performance: High token usage, maximum context awareness
Use Case: Complex system analysis, major architectural decisions
```

**No Context Mode (--context=none)**
```
Behavior: Pure external research, no project context loading
Context Loading:
- No Serena analysis
- No documentation loading  
- No memory integration
Performance: Minimal token usage, fastest response times
Use Case: General knowledge questions, technology comparisons, learning
```

### Advanced Configuration Options

**Context Depth Control:**
```
/rd --context-depth=1 "query"    # Direct symbols/sections only
/rd --context-depth=2 "query"    # Include 1-level relationships
/rd --context-depth=3 "query"    # Include 2-level relationships (default)
/rd --context-depth=max "query"  # Full relationship traversal
```

**Context Scope Control:**
```
/rd --scope=file "query"         # Limit context to specific files
/rd --scope=module "query"       # Limit context to related modules
/rd --scope=project "query"      # Full project scope (default)
```

**Performance Tuning:**
```
/rd --tokens=low "query"         # Aggressive token optimization (500 tokens max)
/rd --tokens=medium "query"      # Balanced token usage (1000 tokens max, default)
/rd --tokens=high "query"        # Generous token budget (2000 tokens max)
/rd --tokens=unlimited "query"   # No token limits for context loading
```

**Cache Control:**
```
/rd --cache=disable "query"      # Disable context caching for fresh analysis
/rd --cache=refresh "query"      # Force cache refresh before analysis
/rd --cache=prefer "query"       # Prefer cached context when available (default)
```

### Configuration Examples

**Development Workflow Examples:**
```bash
# Deep code analysis for refactoring
/rd --context=code --context-depth=max "analyze the authentication flow dependencies"

# Quick implementation guidance with project patterns
/rd --context=smart "how to add a new API endpoint following our patterns"

# Architecture planning with comprehensive context  
/rd --context=full --tokens=high "design approach for adding real-time features"

# Fast general research without project overhead
/rd --context=none "latest best practices for React performance optimization"

# Documentation-focused project planning
/rd --context=docs --scope=project "what integrations do we currently support"
```

**Performance Optimization Examples:**
```bash
# Token-optimized for quick answers
/rd --context=minimal --tokens=low "what version of TypeScript are we using"

# Fresh analysis without cached context
/rd --context=smart --cache=refresh "review our current security implementations"

# Maximum context for complex decisions
/rd --context=full --tokens=unlimited --context-depth=max "migration strategy analysis"
```

### Default Configuration Behavior

**Automatic Mode Selection Logic:**
```
IF query_contains_code_specific_terms:
    default_mode = "smart"
    default_depth = 3
    default_tokens = "medium"
ELIF query_contains_implementation_terms:
    default_mode = "smart" 
    default_depth = 2
    default_tokens = "medium"
ELIF query_contains_general_terms:
    default_mode = "minimal"
    default_depth = 1
    default_tokens = "low"
ELSE:
    default_mode = "auto-detection"
    default_depth = 2  
    default_tokens = "medium"
```

These configuration options provide fine-grained control over the context loading behavior, allowing users to optimize the `/rd` command for their specific workflow needs, token budgets, and query types.

---

## Reference Documentation

For detailed reference material, see the following supporting documents:

- **[MCP Tools Reference](docs/mcp-tools.md)** — Complete documentation for all MCP tools used by the research skill, including Sequential Thinking, Serena, Memory, Brave Search, Tavily, and optional tools. Includes the template for adding new MCP tools.
- **[Technical Appendices](docs/appendices.md)** — Deep technical reference covering context loading strategies, tool orchestration patterns, performance optimization, token efficiency, caching mechanisms, and scalability considerations.
- **[Response Format Template](templates/response-format.md)** — Standard output template for research responses including direct answer, source attribution, code examples, next steps, and knowledge references.
