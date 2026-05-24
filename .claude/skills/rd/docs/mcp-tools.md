# MCP Tools Reference

## MCP Tools Overview

| Tool | Purpose | Required | Primary Use |
|------|---------|----------|-------------|
| **Sequential Thinking** | Orchestrated analysis and cognitive budgeting | ✓ | Complexity management |
| **Serena** | Semantic code intelligence and context loading | ✓ | Codebase analysis |
| **Memory** | Knowledge persistence and retrieval | ✓ | Pattern storage |
| **Brave Search** | Broad web search and current information | ✓ | External research |
| **Tavily** | Specialized research and deep insights | ✓ | Technical research |
| **Context7** | Library documentation access | Optional | Framework docs |
| **Playwright** | Interactive web exploration | Optional | Web interaction |
| **21st-dev-magic** | UI component research | Optional | Component patterns |

## MCP Tool Documentation

### Sequential Thinking

**Purpose**: Orchestrates analysis through structured thinking steps with cognitive budgeting.

**Primary Use Cases**:
- Breaking down complex problems into manageable steps
- Maintaining context across multi-step analysis
- Adjusting thinking depth based on query complexity
- Coordinating other MCP tools

**Key Functions**:
| Function | Description | Use When |
|----------|-------------|----------|
| think | Basic analysis | Simple queries |
| think_hard | Enhanced analysis | Implementation tasks |
| think_harder | Deep analysis | Architecture decisions |
| ultrathink | Maximum analysis | System-wide changes |

**Integration Points**:
- **Orchestrates**: All other MCP tools based on thinking strategy
- **Receives**: Query complexity signals from context detection
- **Provides**: Structured analysis and tool coordination

**Configuration**:
- Automatically selected based on keyword detection
- Can be overridden with explicit complexity hints

**Example Usage**:
```
/r "implement user authentication"
# Triggers "think_hard" level with implementation focus
# Coordinates Serena for existing patterns + external research
```

**Best Practices**:
- Let auto-detection handle complexity for most queries
- Use explicit hints only when auto-detection is wrong
- Higher levels provide better accuracy but use more tokens

---

### Serena

**Purpose**: Semantic code intelligence providing symbol-level analysis, code relationships, and project structure understanding.

**Primary Use Cases**:
- Finding and analyzing code symbols (classes, functions, components)
- Understanding code dependencies and relationships
- Discovering existing patterns for consistent implementation
- Navigating complex codebases efficiently
- Providing precise context without loading entire files

**Key Functions**:
| Function | Description | Token Cost | Use When |
|----------|-------------|------------|----------|
| `get_symbols_overview` | Project structure analysis | Low | Understanding file organization |
| `find_symbol` | Locate specific symbols | Low | Finding classes/functions |
| `find_referencing_symbols` | Dependency mapping | Medium | Impact analysis |
| `search_for_pattern` | Pattern discovery | Medium | Finding implementations |
| `read_memory` | Retrieve stored knowledge | Low | Accessing cached insights |
| `write_memory` | Store insights | Low | Saving analysis results |
| `list_dir` | Directory listing | Low | Project exploration |
| `find_file` | File search | Low | Locating specific files |

**Integration Points**:
- **Provides**: Code context to all other tools
- **Receives**: Pattern queries from Sequential Thinking
- **Works with**: Memory for caching discoveries
- **Enhances**: External research with project context

**Configuration Options**:
- `--context=code`: Prioritize Serena analysis
- `--context-depth`: Control relationship traversal
- `--scope`: Limit to specific files/modules

**Context Strategies**:
1. **Symbol Lookup**: Direct component/function references
2. **Architecture Analysis**: Project structure understanding
3. **Relationship Mapping**: Dependency and impact analysis
4. **Pattern Discovery**: Finding existing implementations

**Example Usage**:
```
/r "how does UserAuth handle login errors"
# Serena workflow:
1. find_symbol("UserAuth") → Component definition
2. find_referencing_symbols("UserAuth") → Usage patterns
3. search_for_pattern("login.*error") → Error handling
# Result: Complete understanding of error handling implementation
```

**Advanced Features**:
- **Token Efficiency**: Loads only relevant symbols (50-200 tokens) vs entire files (2000+ tokens)
- **Semantic Navigation**: Navigate by meaning, not just text search
- **Relationship Graphs**: Understand component interactions
- **Pattern Recognition**: Discover coding patterns across codebase
- **Memory Integration**: Cache discoveries for future queries

**Best Practices**:
- Use for multi-file navigation and understanding
- Ideal for finding references and relationships
- Perfect for understanding existing patterns before implementing
- Not needed for single-file tasks or creating new code from scratch
- Always verify symbol names if getting unexpected results

**Troubleshooting**:
- **Missing symbols**: Use `--cache=refresh` or check with `get_symbols_overview`
- **Ambiguous matches**: Use full paths like "src/auth/UserAuth"
- **Slow loading**: Reduce `--context-depth` or use `--scope`

---

### Memory

**Purpose**: Persistent knowledge storage and retrieval using a knowledge graph structure.

**Primary Use Cases**:
- Storing architectural decisions and insights
- Caching successful query patterns
- Building cumulative project knowledge
- Avoiding re-analysis of unchanged code
- Creating relationships between concepts

**Key Functions**:
| Function | Description | Token Cost | Use When |
|----------|-------------|------------|----------|
| `read_graph` | Get entire knowledge graph | High | Initial analysis |
| `create_entities` | Add knowledge nodes | Low | Storing insights |
| `create_relations` | Link concepts | Low | Building connections |
| `search_nodes` | Query knowledge | Medium | Retrieving insights |
| `open_nodes` | Get specific entities | Low | Targeted retrieval |
| `delete_entities` | Remove outdated info | Low | Cleanup |

**Integration Points**:
- **Receives**: Analysis results from Serena, research from Brave/Tavily
- **Provides**: Historical context, cached patterns, decisions
- **Enhances**: All tools with persistent knowledge

**Configuration**:
- Automatic caching of valuable insights
- Can be disabled with `--cache=disable`
- Refresh with `--cache=refresh`

**Example Usage**:
```
/r "what architectural decisions have we made about authentication"
# Memory retrieves:
- Previous auth implementations
- Decision rationale
- Timestamps and context
```

**Best Practices**:
- Use for recurring queries and pattern storage
- Store architectural decisions and trade-offs
- Clean up outdated information periodically

---

### Brave Search

**Purpose**: Broad web search for current information, best practices, and general knowledge.

**Primary Use Cases**:
- Finding current best practices
- Technology comparisons
- General knowledge queries
- Recent news and updates
- Documentation searches

**Key Functions**:
| Function | Description | Use When |
|----------|-------------|----------|
| `web_search` | General web search | Broad information gathering |
| `news_search` | Recent news | Current events |

**Integration Points**:
- **Provides**: External knowledge to complement project context
- **Works with**: Tavily for comprehensive research
- **Enhanced by**: Serena context for relevant filtering

**Example Usage**:
```
/r "latest React performance optimization techniques"
# Brave Search finds current articles and best practices
```

**Best Practices**:
- Use for broad, current information
- Combine with Tavily for depth
- Filter results with project context when relevant

---

### Tavily

**Purpose**: Specialized research providing deep technical insights and comprehensive analysis.

**Primary Use Cases**:
- In-depth technical research
- Implementation guides
- Architecture patterns
- Specialized domain knowledge
- Detailed tutorials

**Key Functions**:
| Function | Description | Use When |
|----------|-------------|----------|
| `tavily_search` | Deep technical search | Specialized insights |
| `tavily_extract` | Content extraction | Detailed analysis |

**Integration Points**:
- **Complements**: Brave Search with specialized depth
- **Enhanced by**: Project context for relevance
- **Provides**: Technical insights for implementation

**Example Usage**:
```
/r "implement WebSocket real-time features"
# Tavily provides detailed implementation guides
```

**Best Practices**:
- Use for technical depth over breadth
- Ideal for implementation guidance
- Combine with Brave for comprehensive coverage

---

### Optional MCP Tools

#### Context7
**Purpose**: Library and framework documentation access.
- Use for framework-specific questions
- Provides official documentation
- Best for React, Vue, Angular queries

#### Playwright
**Purpose**: Interactive web exploration and testing.
- Web page interaction
- Screenshot capture
- Form testing

#### 21st-dev-magic
**Purpose**: UI component patterns and examples.
- Component design patterns
- UI implementation examples
- Best practices for common components

## Adding New MCP Tools

To add a new MCP tool to the research skill:

1. **Update Prerequisites**: Add to required/optional list
2. **Add to Overview Table**: Include purpose and primary use
3. **Create Documentation Section**: Use this template:

```markdown
### [Tool Name]

**Purpose**: [One sentence description]

**Primary Use Cases**:
- [Use case 1]
- [Use case 2]
- [Use case 3]

**Key Functions**:
| Function | Description | Token Cost | Use When |
|----------|-------------|------------|----------|
| function_1 | What it does | Low/Med/High | Scenario |

**Integration Points**:
- How it integrates with other tools
- Data flow in/out

**Configuration**:
- Specific options

**Example Usage**:
```example
[Usage example]
```

**Best Practices**:
- When to use
- When NOT to use
```

4. **Update Tool Selection Logic**: Add triggers in SKILL.md implementation
5. **Test Integration**: Verify tool works with existing workflow
