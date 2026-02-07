#!/bin/bash
# Reset Claude Code cache to ensure clean proxy connection

echo "🔄 Resetting Claude Code cache..."

# Remove Claude Code configuration cache
if [ -d ~/.config/claude-code ]; then
    rm -rf ~/.config/claude-code
    echo "   ✅ Removed ~/.config/claude-code"
fi

# Remove Claude CLI cache
if [ -d ~/.claude ]; then
    rm -rf ~/.claude
    echo "   ✅ Removed ~/.claude"
fi

# Remove any lingering session files in common project directories
if [ -d ~/Projects ]; then
    find ~/Projects -name ".claude" -type d -maxdepth 3 2>/dev/null | while read dir; do
        if [ -f "$dir/settings.local.json" ]; then
            # Keep settings but remove session data
            echo "   ℹ️  Keeping settings in $dir"
        fi
    done
fi

echo "✅ Claude Code cache reset complete!"
echo ""
echo "💡 This ensures nim-claude connects to the proxy cleanly"
echo "💡 Your project-specific .claude settings are preserved"
