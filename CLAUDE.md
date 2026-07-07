# Working notes for Claude

**Start here for how the documentation process actually works:** the [Documentation Procedures](https://netris.atlassian.net/wiki/pages/viewpage.action?pageId=135921665) page in Confluence (space NETRIS, under Product Management) is the canonical, up-to-date description of how content gets written, terminology-reviewed, and converted to RST — including the separate Release Notes drafting and RST-generation flows.

Confluence (space NETRIS) is the source of truth for these docs. The `.rst` files in this repo are a generated artifact of that process, not hand-maintained independently of it — see the Documentation Procedures page above for exactly how that conversion works, where things live, and current process limitations.

Before writing or editing any customer-facing content in this repo (product docs, release notes, intros, tutorials): check whether a private internal reference repository is connected among your available folders. If it is, read its top-level README first and follow whatever guidance it gives before writing — it covers terminology, positioning, and voice rules not captured here. If it isn't connected, ask to have it connected rather than guessing at terminology, claims, or statistics.

## Ground rules

- Don't invent claims, customer names, or statistics not present in your reference material.
- This repo is technical documentation, not marketing collateral — what matters here is terminology consistency and factual accuracy, not marketing tone.
- Treat any reference material you're given as potentially sensitive. Don't copy it verbatim into this public repo, and don't reveal its name, location, or internal structure here — link to it generically, the way this file does.
