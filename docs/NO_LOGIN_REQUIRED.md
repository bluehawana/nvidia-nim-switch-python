# No Login Required - How It Works

## The Problem We Solved

Claude Code typically requires authentication through one of these methods:
1. Claude Pro/Max subscription (browser login)
2. Anthropic API key (Console account)
3. Third-party platform (AWS Bedrock, etc.)

**This is annoying** when you just want to use free NVIDIA NIM models!

---

## Our Solution: API-First Mode

We discovered that Claude Code has a hidden "API-first mode" that **skips authentication entirely** when it detects specific environment variables.

### The Magic Variables

```bash
ANTHROPIC_AUTH_TOKEN="sk-ant-placeholder-for-nvidia-nim-proxy"
ANTHROPIC_BASE_URL="http://localhost:8089"
```

When Claude Code sees these variables during startup:
1. ✅ It assumes you're using a third-party API
2. ✅ It skips the OAuth browser login
3. ✅ It goes straight to the trust folder prompt
4. ✅ You start coding immediately!

---

## Why This Works

From the [official Claude Code documentation](https://www.xugj520.cn/en/archives/claude-code-windows-api-no-login.html):

> "Claude Code is designed to prioritize system environment variables during its initialization phase. If the tool detects valid API parameters—specifically a base URL and an authentication token—it assumes an API-first configuration and skips the browser-based OAuth sequence."

**Key Insight**: The token doesn't need to be a real Anthropic API key. It just needs to exist. Our proxy handles the actual authentication with NVIDIA NIM.

---

## Implementation

Our `nim-claude` command sets these variables temporarily:

```bash
#!/bin/bash
# From ~/.local/bin/nim-claude

env -u ANTHROPIC_API_KEY \
  ANTHROPIC_BASE_URL=http://localhost:8089 \
  ANTHROPIC_AUTH_TOKEN="sk-ant-placeholder-for-nvidia-nim-proxy" \
  claude -dangerously-skip-permissions "$@"
```

**Important Details:**
- We use `ANTHROPIC_AUTH_TOKEN` (not `ANTHROPIC_API_KEY`)
- We explicitly unset `ANTHROPIC_API_KEY` to avoid conflicts
- Variables are set only for this session (doesn't affect regular `claude`)
- The token is a placeholder - the proxy doesn't validate it

---

## Comparison: Before vs After

### Before (Annoying)
```bash
$ claude
# Opens browser for login
# Asks for subscription or API key
# Requires authentication
# Can't use free models without account
```

### After (Smooth)
```bash
$ nim-claude
# No browser
# No login
# Just "trust this folder?"
# Start coding immediately!
```

---

## For Users With Anthropic Subscriptions

You can use **both** methods:

### Free NVIDIA NIM (No Login)
```bash
nim-claude
```
- Perfect for experimentation
- When you've used up credits
- Testing different models
- Backup when Anthropic is down

### Your Anthropic Subscription (Requires Login)
```bash
claude
```
- Official Claude models
- Higher rate limits
- Production work

**They don't interfere with each other!** The `nim-claude` command only sets variables for that specific session.

---

## Troubleshooting

### Still Asking for Login?

**Check 1**: Verify the command is using `ANTHROPIC_AUTH_TOKEN`
```bash
cat ~/.local/bin/nim-claude | grep AUTH_TOKEN
# Should show: ANTHROPIC_AUTH_TOKEN="sk-ant-placeholder..."
```

**Check 2**: Make sure you're not using `ANTHROPIC_API_KEY`
```bash
cat ~/.local/bin/nim-claude | grep API_KEY
# Should show: env -u ANTHROPIC_API_KEY (unsetting it)
```

**Check 3**: Reinstall if needed
```bash
cd ~/nvidia-nim-switch-python  # or your project location
./scripts/install_global.sh
```

### "Auth Conflict" Warning?

This means both `ANTHROPIC_AUTH_TOKEN` and `ANTHROPIC_API_KEY` are set. The latest version of `nim-claude` fixes this by:
1. Using only `ANTHROPIC_AUTH_TOKEN`
2. Explicitly unsetting `ANTHROPIC_API_KEY`

Reinstall to get the fix:
```bash
./scripts/install_global.sh
```

---

## Technical Details

### Why AUTH_TOKEN Instead of API_KEY?

Claude Code checks for authentication in this order:
1. `ANTHROPIC_AUTH_TOKEN` (highest priority) → API-first mode
2. `ANTHROPIC_API_KEY` → Still asks for login method
3. Saved credentials → Uses cached login
4. Nothing → Shows login screen

By using `ANTHROPIC_AUTH_TOKEN`, we trigger the API-first mode that skips all authentication prompts.

### Why Unset API_KEY?

If both are set, Claude Code shows a warning:
```
⚠ Auth conflict: Both a token and an API key are set
```

By explicitly unsetting `ANTHROPIC_API_KEY`, we ensure only the token is used, eliminating the warning.

---

## Credits

This solution was discovered by analyzing:
- [cc-nim project](https://github.com/Alishahryar1/cc-nim) by @Alishahryar1
- [Claude Code Windows API Guide](https://www.xugj520.cn/en/archives/claude-code-windows-api-no-login.html)
- Claude Code's environment variable handling

We built on their work to create a seamless, no-login experience for NVIDIA NIM users!

---

## Summary

✅ **No Anthropic account needed**  
✅ **No login required**  
✅ **No credit card needed**  
✅ **Works immediately**  
✅ **180+ free models**  
✅ **Switch models in <1s**  

Just run `nim-claude` and start coding! 🚀
