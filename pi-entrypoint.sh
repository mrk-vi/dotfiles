#!/bin/bash
set -e

# pi management subcommands: run directly, no interactive session
case "${1:-}" in
    update|install|remove|uninstall|list|config)
        exec pi "$@"
        ;;
esac

# Legacy --update flag: run update first, then start pi with remaining args
if [[ "${1:-}" == "--update" ]]; then
    shift
    echo "Checking for pi updates..."
    pi update || echo "Warning: pi update failed, running current version" >&2
    exec pi "$@"
fi

# Legacy PI_UPDATE env var (backward compat)
if [ -n "${PI_UPDATE:-}" ]; then
    echo "Checking for pi updates..."
    pi update || echo "Warning: pi update failed, running current version" >&2
fi

exec pi "$@"
