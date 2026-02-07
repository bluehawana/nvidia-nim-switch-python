# Switching Between Free NVIDIA NIM and Paid Anthropic

## Two Ways to Use Claude Code

### Option 1: Free NVIDIA NIM Proxy (180+ Models) ⭐ RECOMMENDED
```bash
nim-claude
```
- ✅ **FREE** - Uses NVIDIA NIM's free API
- ✅ 180+ models available (GLM 4.7, MiniMax 2.1, Llama, etc.)
- ✅ **No login required** - Works immediately
- ✅ No Anthropic subscription needed
- ✅ Switch models instantly via `nim-web`
- ⚠️ Rate limited (20 requests/minute by default)

**Perfect for:**
- Learning and experimentation
- When you've used up your Anthropic credits
- Testing different models
- Backup when Anthropic is down

### Option 2: Your Anthropic Subscription (Claude Models)
```bash
claude
```
- ✅ Uses your Claude Pro/Max/Team subscription
- ✅ Official Claude models (Sonnet 4.5, Opus 4.6, etc.)
- ✅ Higher rate limits
- ✅ Premium features
- 💰 Requires active Anthropic subscription
- ⚠️ Requires login/authentication

**Perfect for:**
- Production work
- When you need official Claude models
- Higher rate limits

---

## Common Scenarios

### Scenario 1: Used Up Your Anthropic Credits ⭐
```bash
# Switch to free NVIDIA NIM - NO LOGIN REQUIRED!
nim-claude
```
Keep coding for free with 180+ alternative models! Works immediately without any authentication.

### Scenario 2: Need Claude's Premium Features
```bash
# Use your Anthropic subscription (requires login)
claude
```
Get the full Claude experience with your paid subscription.

### Scenario 3: First Time User (No Anthropic Account)
```bash
# Just use the free proxy - no account needed!
nim-start
nim-claude
```
Start coding immediately with free NVIDIA NIM models. No registration, no credit card, no login!

### Scenario 4: Testing Different Models
```bash
# Terminal 1: Start with free proxy
nim-claude

# Terminal 2: Switch models on the fly
nim-web
# Or: nim-switch
```

### Scenario 4: Working on Multiple Projects
```bash
# Project A - Use free NVIDIA NIM
cd ~/project-a
nim-claude

# Project B - Use Anthropic subscription
cd ~/project-b
claude
```

---

## How It Works

### `nim-claude` Command - NO LOGIN REQUIRED! ⭐
- Sets `ANTHROPIC_AUTH_TOKEN` environment variable
- Claude Code detects this and enters "API-first mode"
- **Skips OAuth login entirely** - works immediately
- Doesn't affect your regular `claude` command
- Your Anthropic login stays intact (if you have one)

**Key Insight**: Claude Code prioritizes environment variables. When it detects `ANTHROPIC_AUTH_TOKEN` + `ANTHROPIC_BASE_URL`, it assumes you're using a third-party API and skips the browser login flow entirely!

### `claude` Command
- Uses your normal Anthropic authentication
- No proxy, no overrides
- Works exactly as before

---

## Troubleshooting

### "Still Asking for Login"
If `nim-claude` still shows a login page:

```bash
# Check if environment variables are set correctly
cat ~/.local/bin/nim-claude

# Should show ANTHROPIC_AUTH_TOKEN (not ANTHROPIC_API_KEY)
# If it shows API_KEY, reinstall:
cd ~/nvidia-nim-switch-python  # or wherever your project is
./scripts/install_global.sh
```

**Important**: Use `ANTHROPIC_AUTH_TOKEN` (not `ANTHROPIC_API_KEY`). Claude Code prioritizes AUTH_TOKEN for API-first mode and skips login.

### "Auth Conflict" Warning
This warning appeared in older versions. If you see it:

```bash
# The warning is harmless but annoying
# Make sure you're using the latest nim-claude command
./scripts/install_global.sh
```

The latest version uses only `ANTHROPIC_AUTH_TOKEN` which eliminates the warning.

### Can't Login to Anthropic
If `claude` asks for login but you have a subscription:

```bash
# Logout and login again
claude /logout

# Then login with your subscription
claude
# Select: "1. Claude account with subscription"
```

### Want to Make NVIDIA NIM the Default
If you want to always use the free proxy:

```bash
# Add to ~/.zshrc or ~/.bashrc
alias claude='nim-claude'
```

Then `claude` will use the free proxy, and you can use `/usr/local/bin/claude` for the original.

---

## Best Practices

1. **Use `nim-claude` for experimentation** - Try different models for free
2. **Use `claude` for production work** - When you need reliability and premium features
3. **Keep both options available** - Don't remove either command
4. **Check your rate limits** - Free tier has limits, paid tier has higher limits

---

## Quick Reference

| Command | Cost | Models | Rate Limit | Use Case |
|---------|------|--------|------------|----------|
| `nim-claude` | FREE | 180+ NVIDIA NIM | 20/min | Experimentation, learning, backup |
| `claude` | Paid | Claude family | Higher | Production, premium features |

---

## Need Help?

- **Switch models**: `nim-web` or `nim-switch`
- **Check proxy status**: `nim-status`
- **View available models**: Open http://localhost:8089/
- **Report issues**: [GitHub Issues](https://github.com/bluehawana/nvidia-nim-switch-python/issues)
