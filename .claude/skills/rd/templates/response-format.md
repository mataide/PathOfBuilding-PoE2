# Research Response Format Template

Standard output template for the research skill. Each response should follow this structure to ensure consistency and completeness.

## Response Structure

### 1. Direct Answer
Clear, actionable response to the research question. Lead with the most important finding.

```
## Answer

[Concise, direct answer to the query]

[Supporting details, context, and nuance]
```

### 2. Source Attribution
Full citations and methodology transparency.

```
## Sources

**External Sources:**
- [Source 1] — [Brief description of what was found]
- [Source 2] — [Brief description of what was found]

**Project Context Sources:**
- [Serena: symbol/pattern discovered] — [What it revealed]
- [Documentation: section referenced] — [What it provided]
- [Memory: cached insight used] — [Historical context]

**Research Methodology:**
- Tools used: [list of MCP tools activated]
- Context strategy: [auto/smart/code/docs/minimal/full/none]
- Complexity level: [basic/moderate/advanced/maximum]
```

### 3. Code Examples
When applicable, provide code that aligns with project patterns and standards.

```
## Code Examples

[Code snippets that follow project conventions]
[Include comments explaining key decisions]
[Reference existing project patterns when possible]
```

### 4. Scope Assessment & Execution Plan
Scrum-based sizing of the user's request with appropriate execution routing (Step 9).

**Always include the scope assessment block:**
```
## Scope Assessment

📐 Classification: [TASK | STORY | EPIC]
├── Files affected: [count]
├── New dependencies: [count or "None"]
├── Implementation steps: [count]
├── Cross-cutting concerns: [yes/no]
└── Architectural impact: [none/minor/significant]
```

**If TASK — inline execution plan:**
```
## Execution Plan (TASK)

1. [Step 1 description]
2. [Step 2 description]
3. [Step 3 description]

Proceed? (Y/n)
```

**If STORY or EPIC — PRD reference and execution summary:**
```
## Execution Plan (STORY | EPIC)

📄 PRD: [.claude/temp/prd-{timestamp}-{slug}.md]

### Execution Order:
1. S-001: [story_title] ([N] tasks)
   └─ S-001.1: [first_task]
   └─ S-001.2: [second_task]
2. S-002: [story_title] ([N] tasks)  (EPIC only)
   └─ ...

Execute step by step? (Y/n/edit)
```

**After execution completes (STORY/EPIC only):**
```
## Execution Summary

📊 Results ([PRD path])
├── Stories: [done]/[total] completed
├── Tasks:   [done]/[total] completed
├── Deferred: [count] (if any)
└── Status: [COMPLETED | PARTIAL]
```

### 5. Next Steps
Recommended actions considering current project state and capabilities.

```
## Next Steps

1. [Most important action item]
2. [Secondary action item]
3. [Optional follow-up]

**Prerequisites:** [Any required setup or dependencies]
**Estimated complexity:** [TASK/STORY/EPIC — from Step 9 classification]
```

### 6. Knowledge References
Stored insights for future use and context continuity.

```
## Knowledge Stored

- [Entity/concept stored in memory graph]
- [Relationship created between concepts]
- [Pattern cached for future queries]
- [PRD location stored for follow-up queries] (if STORY/EPIC)

💡 Use `/rd "related query"` to build on these findings.
```

### 7. Domain Rule Compliance
Always render this block — even when nothing was loaded or revised — so users can confirm the `docs/` rules layer engaged for the query.

```
## Domain Rule Compliance

- **Docs consulted:** [list of docs/ files loaded in Step 4, or `none — {routing_reason}`]
- **Auto-revisions applied:** [numbered revisions list from Step 7, or `none`]
```

When auto-revisions exist, each entry should cite the source as `docs/<file>§<section>` and show the before/after fragment so the user can verify the rewrite:

```
1. **docs/modSyntax.md§ModType** — was: `mod("X", "ADD", ...)` → now: `mod("X", "BASE", ...)`.
   Reason: ModType enum is closed; "ADD" is not a legal value.
```
