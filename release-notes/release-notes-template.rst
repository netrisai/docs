.. include:: ../_includes/links.rst

.. meta::
    :description: Netris Release Notes {{version}}

.. -----------------------------------------------------------------------------
.. Release Notes Template (RST) for Sphinx
.. Usage:
.. - Replace {{placeholders}}.
.. - Keep one-liners crisp: what changed + why it matters.
.. - Use Areas to group by product components (Controller, SoftGate, EVPN, UI, API, Agents, etc.).
.. - Only include "Customer action required" callouts when true.
.. -----------------------------------------------------------------------------

.. _release_{{version}}:

{{product}} {{version}} ({{date}})
==================================

Compatibility
-------------
.. Summarize deprecations/breakers up top so readers don’t miss them.

- Backward compatibility: Compatible / Behavior change / Migration required
- Deprecations: None / <short line with timeline>
- Breaking changes: None / <short line; details below if any>

Highlights
----------
.. 2–5 bullets that capture the essence of the release in customer language.

- {{high-impact change 1}} — {{customer value/why it matters}}
- {{high-impact change 2}} — {{customer value}}

Features
--------
.. New capabilities visible to customers. One line each; optional 1–2 lines of context.

- [Area: {{component}}] {{what changed in one sentence}} — {{why it matters}}
  {{Optional detail: 1–2 lines for context or defaults.}}
  Tickets: {{NOT-1234, NOT-5678}}  Docs: {{link or “N/A”}}

Improvements
------------
.. Enhancements to existing behavior, performance, UX, observability.

- [Area: {{component}}] {{improvement}} — {{benefit}}
  Tickets: {{ids}}  Docs: {{link or “N/A”}}

Bug fixes
---------
.. Customer-facing defect fixes. If internal-only, keep wording generic.

- [Area: {{component}}] {{symptom or scenario}} now {{expected behavior}}
  Tickets: {{ids}}

Security
--------
.. Keep details minimal if sensitive; link internally if needed.

- {{CVE/issue identifier if public}} — {{impact summary}} (fixed)

Deprecations
------------
.. Announce with timelines and replacements.

- {{feature/config}} is deprecated; removal in {{YYYY-MM}}. Use {{replacement}}.

Breaking changes
----------------
.. List only the true breakers. Put migrations here or link to a guide.

- [Area: {{component}}] {{what broke/changed}} — {{reason}}
  Migration:
  1. {{step}}
  2. {{step}}

Known issues
------------
.. Issues discovered late; provide a safe workaround or status.

- [Area: {{component}}] {{issue description / when it appears}}
  Workaround: {{steps}}  Status: {{investigating/fix in next release}}

Upgrade notes
-------------
.. Call out any required actions, order of operations, or downtime windows.
.. If no action is needed, say so.

- Customer action required: {{Yes/No}}
- Steps:
  1. {{step}}
  2. {{step}}

Component versions & artifacts
------------------------------
.. Useful when customers pin versions or verify upgrades.

- Controller: {{x.y.z}} (build {{hash/ID}})
- SoftGate: {{x.y.z}}
- Switch Agent(s): {{list}}
- Checksums / artifact index: {{link}}

References
----------
.. Link deeper docs; prefer permalinks.

- :doc:`Supported Platforms <../supported-platform-matrix>`
- :doc:`Supported Switch Hardware <../supported-switch-hardware>`
- Schedule a Demo_
- Follow us on LinkedIn_
- Follow us on X-Twitter_
- Join our Slack_

.. End of file
