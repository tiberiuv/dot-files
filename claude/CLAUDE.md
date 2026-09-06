<!--
The rules live in agents/AGENTS.md, linked to ~/.agents/AGENTS.md, so agents
that read the AGENTS.md open format get the same file. Claude Code only looks
for CLAUDE.md, hence this stub. `@` is an import, expanded at launch -- prose
telling Claude to go read the file would be a runtime tool call it may skip.
Claude-specific rules go below the import; everything shared goes in AGENTS.md.
This comment is stripped before the file enters context, so it costs nothing.
-->

@~/.agents/AGENTS.md
