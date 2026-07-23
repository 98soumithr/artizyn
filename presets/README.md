# Stack presets

Applied by `scripts/init-stack.sh` at Phase 3. Each folder holds the six scripts plus the
CI runtime block for one stack.

Presets assume conventional project layout. Check the installed scripts against how the
project actually runs — a non-standard test path or entry point needs editing by hand.

Adding a stack: copy a folder, edit the six scripts and `ci-runtime.yml`, then add its
detection keywords to the grep block in `init-stack.sh`.
