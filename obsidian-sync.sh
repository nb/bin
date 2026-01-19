#!/usr/bin/env bash
#
# obsidian-sync.sh - Push Obsidian vault to GitHub
# Designed to run via cron every 2-3 hours
#
# Sample crontab line:
# 19 */2 * * * /Users/nb/bin/obsidian-sync.sh >> ~/.obsidian-sync.log 2>&1

set -euo pipefail

VAULT_DIR="${HOME}/brain"
SCRIPT_NAME="$(basename "$0")"

log() {
    echo "[${SCRIPT_NAME}] $(date '+%Y-%m-%d %H:%M:%S') - $1" >&2
}

error() {
    log "ERROR: $1"
    /opt/homebrew/bin/terminal-notifier -title "Obsidian Sync Failed" -message "$1" -sound Basso -open "file://${HOME}/.obsidian-sync.log"
    exit 1
}

# Verify vault directory exists
if [[ ! -d "$VAULT_DIR" ]]; then
    error "Vault directory does not exist: $VAULT_DIR"
fi

# Change to vault directory
cd "$VAULT_DIR" || error "Failed to change to vault directory: $VAULT_DIR"

# Verify it's a git repository
if [[ ! -d ".git" ]]; then
    error "Not a git repository: $VAULT_DIR"
fi

# Check if remote is configured
if ! git remote get-url origin &>/dev/null; then
    error "No 'origin' remote configured"
fi

# Fetch latest from remote to detect potential conflicts
log "Fetching from remote..."
if ! git fetch origin main 2>&1; then
    error "Failed to fetch from remote"
fi

# Check for diverged history (local and remote both have new commits)
LOCAL=$(git rev-parse HEAD 2>/dev/null || echo "")
REMOTE=$(git rev-parse origin/main 2>/dev/null || echo "")
BASE=$(git merge-base HEAD origin/main 2>/dev/null || echo "")

if [[ -n "$REMOTE" && -n "$BASE" && "$LOCAL" != "$REMOTE" && "$BASE" != "$REMOTE" && "$BASE" != "$LOCAL" ]]; then
    error "Local and remote have diverged. Manual intervention required."
fi

# Pull if remote is ahead (fast-forward only)
if [[ -n "$REMOTE" && -n "$BASE" && "$BASE" == "$LOCAL" && "$LOCAL" != "$REMOTE" ]]; then
    log "Remote is ahead, pulling changes..."
    if ! git pull --ff-only origin main 2>&1; then
        error "Failed to pull from remote"
    fi
fi

# Stage all changes (new, modified, deleted)
git add --all

# Check if there are changes to commit
if git diff --cached --quiet; then
    log "No changes to commit"
    exit 0
fi

# Generate commit message with timestamp and summary
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
CHANGED_FILES=$(git diff --cached --name-only | wc -l | tr -d ' ')
COMMIT_MSG="Auto-sync: ${TIMESTAMP} (${CHANGED_FILES} file(s) changed)"

# Commit changes
log "Committing ${CHANGED_FILES} file(s)..."
if ! git commit -m "$COMMIT_MSG" 2>&1; then
    error "Failed to commit changes"
fi

# Push to remote
log "Pushing to origin/main..."
if ! git push origin main 2>&1; then
    error "Failed to push to remote. You may need to pull first or resolve conflicts."
fi

log "Successfully synced vault to GitHub"
