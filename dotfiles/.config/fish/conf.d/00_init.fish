# -----------------------------------------------------
# INIT
# -----------------------------------------------------

set -U fish_greeting ""

# -----------------------------------------------------
# Exports
# -----------------------------------------------------
export EDITOR=nvim

set -U fish_user_paths "/usr/lib/ccache/bin/"
set -U fish_user_paths "$fish_user_paths" "~/.cargo/bin/"
set -U fish_user_paths "$fish_user_paths" "~/.local/bin/"

# -----------------------------------------------------
# Setup
# -----------------------------------------------------
# Start up ssh-agent
if status is-interactive
    # Only start an agent if we don't already have one
    if not set -q SSH_AUTH_SOCK
        eval (ssh-agent -c) >/dev/null
    end
end
