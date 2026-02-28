# Project Estimate: Claude-Powered Assistant MVP

## Scope
This estimate covers building a production-ready MVP assistant using patterns from this repository:
- Prompting and skills
- Tool use integrations
- Basic retrieval-augmented responses
- Evaluation and safety checks

## Assumptions
- 1 product owner, 1 designer (part-time), 2 engineers, 1 QA engineer (part-time)
- Existing cloud environment and CI/CD are already available
- No complex enterprise compliance requirements (SOC2/HIPAA-specific work excluded)
- Target release includes web chat experience and one internal tool integration

## Effort Estimate (6-8 weeks)

| Workstream | Activities | Est. Effort |
|---|---|---:|
| Discovery & requirements | Use-case definition, success criteria, model selection, data boundaries | 3-5 days |
| Prompt and workflow design | System prompts, conversation flows, fallback behavior, refusal handling | 4-6 days |
| Tool use integration | Define tool schemas, implement calls, retries, and error handling | 6-9 days |
| Retrieval setup | Document ingestion, chunking, embeddings/vector store, citation formatting | 6-10 days |
| App integration | API layer, session/state management, logging, analytics hooks | 7-10 days |
| Safety and evals | Eval dataset, regression tests, harmful-content checks, quality scorecards | 5-8 days |
| QA and release | UAT fixes, load checks, runbooks, launch checklist | 4-6 days |

### Total
- **Engineering + QA effort:** **35-54 person-days**
- **Calendar timeline:** **6-8 weeks** (with parallel workstreams)

## Budgetary Estimate (USD)

| Team composition | Weekly burn | 6-week total | 8-week total |
|---|---:|---:|---:|
| 2 Engineers + part-time QA/Design/PM | $18k-$26k | $108k-$156k | $144k-$208k |

> This excludes variable model/API usage, hosting, and third-party SaaS costs.

## API/Infrastructure Cost Range (MVP)
- **Low traffic pilot:** $300-$1,500/month
- **Moderate internal rollout:** $1,500-$7,500/month
- **Higher usage / heavier context windows:** $7,500+/month

Actual spend depends on model mix, token volume, context length, and caching strategy.

## Key Risks and Contingency
- **Tool reliability issues:** add 10-15% contingency for integration hardening
- **RAG quality variance:** add time for chunking and retrieval tuning
- **Scope creep:** lock MVP features and defer advanced routing/agent behaviors

## Recommended Milestones
1. **Week 1:** Requirements, architecture, baseline prompt workflows
2. **Week 2-3:** Core app + tool integration functional
3. **Week 4-5:** Retrieval + eval harness + safety pass
4. **Week 6:** UAT, launch readiness, and pilot rollout
5. **Week 7-8 (optional):** Hardening and post-pilot iteration

## Next Step
Turn this into a detailed statement of work by defining:
- exact user journeys
- data sources and access controls
- concrete SLA and quality targets
- expected daily/weekly query volume
