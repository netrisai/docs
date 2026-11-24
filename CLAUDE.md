# Working notes for Claude

**Start here for how the documentation process actually works:** the [Documentation Procedures](https://netris.atlassian.net/wiki/x/AQAaC) page in Confluence (space NETRIS, under Product Management) is the canonical, up-to-date description of how content gets written, reviewed, and converted to RST — including the separate Release Notes drafting and RST-generation flows.

Confluence (space NETRIS) is the source of truth for these docs. The `.rst` files in this repo are a generated artifact of that process, not hand-maintained independently of it.

**The writing rules are not in this repo.** Terminology, positioning, approved claims and voice are defined on Confluence pages linked from Documentation Procedures, and the internal `netris-docs-rules` repository carries machine-readable copies of them for Claude to read. Before writing or editing any customer-facing content here (product docs, release notes, intros, tutorials), work with that repository connected — its own instructions load automatically and take precedence over this file. If it isn't connected, ask for it rather than guessing at terminology, claims, or statistics.

## Ground rules

- Don't invent claims, customer names, or statistics not present in your reference material.
- This repo is technical documentation, not marketing collateral — what matters here is terminology consistency and factual accuracy, not marketing tone.
- Treat any reference material you're given as potentially sensitive. The rules repository may be referred to here by name, but don't reproduce its contents, file paths, or internal structure in this public repo, and don't copy reference material verbatim into it.

## Editing user docs = editing Confluence, not this repo

When asked to "update the docs" / "update the Inventory Profiles page" / similar for customer-facing content, that means editing the Confluence page in the NETRIS space — never editing the `.rst` files in this repo directly. Propose changes as a diff against the current Confluence page content and wait for explicit approval before writing (see the Documentation Procedures page, and the `confluence-pages` skill if it is available). The `.rst` files here are regenerated from Confluence via a separate, documented RST-generation process — don't touch them as part of an "update the docs" request.
